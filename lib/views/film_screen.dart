import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_architecture/generated/app_localizations.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/services/app_services.dart';
import 'package:flutter_architecture/views/details_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalization.of(context).name),
      ),
      body: FutureBuilder(
          future: (() async {
            await Future.delayed(const Duration(seconds: 2));
            var responses = await Future.wait([
              AppServiceInterface.getImpl().loadFilms(),
              AppServiceInterface.getImpl().loadImageConfiguration(),
              AppServiceInterface.getImpl().loadGenres(),
            ]);
            return {
              "film": responses[0] as List<Film>?,
              "configuration": responses[1] as ConfigurationImage?,
              "genre": responses[2] as List<Genre>?,
            };
          }).call(),
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (data == null) return const Center(child: CircularProgressIndicator());
            var configuration = data["configuration"] as ConfigurationImage?;
            var films = data["film"] as List<Film>?;
            var genres = data["genre"] as List<Genre>?;
            if (configuration == null || films == null || genres == null) return Container();
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: films.length,
              itemBuilder: (context, index) {
                var film = films.elementAt(index);
                return SizedBox(
                  height: 180,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                DetailsPage(details: film, configuration: configuration, genre: genres)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: double.infinity,
                              child: Hero(
                                tag: "${film.id}_poster",
                                child: film.posterPath == null
                                    ? Container()
                                    : Image.network(
                                        configuration.hdPosterUrl(film.posterPath!),
                                        fit: BoxFit.cover,
                                        loadingBuilder: (ctx, child, imageChunkEvent) {
                                          if (imageChunkEvent == null) return child;
                                          return Stack(
                                            children: [
                                              Image.network(
                                                configuration.ldPosterUrl(film.posterPath!),
                                                fit: BoxFit.cover,
                                              ),
                                              Positioned.fill(child: Container(color: Colors.black54)),
                                              Positioned.fill(
                                                child: Center(
                                                  child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                      strokeCap: StrokeCap.round,
                                                      value: imageChunkEvent.expectedTotalBytes == null
                                                          ? null
                                                          : imageChunkEvent.cumulativeBytesLoaded /
                                                              imageChunkEvent.expectedTotalBytes!),
                                                ),
                                              ),
                                              if (imageChunkEvent.expectedTotalBytes != null)
                                                Positioned.fill(
                                                  child: Center(
                                                    child: Text(
                                                      "${(imageChunkEvent.cumulativeBytesLoaded / imageChunkEvent.expectedTotalBytes! * 100).toStringAsFixed(0)}%",
                                                      style: const TextStyle(color: Colors.white, fontSize: 10),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: Hero(
                                    tag: "${film.id}_backdrop",
                                    child: film.backdropPath != null
                                        ? Image.network(
                                            configuration.hdBackdropUrl(film.backdropPath!),
                                            fit: BoxFit.cover,
                                          )
                                        : Container(),
                                  ),
                                ),
                                Positioned.fill(
                                    child: Hero(
                                  tag: "${film.id}_black",
                                  child: Container(color: Colors.black54),
                                )),
                                SizedBox(
                                  width: double.infinity,
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Hero(
                                              tag: "${film.id}_title",
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: Text(
                                                  film.title,
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              film.overview ?? "",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            if (film.genreIds.isNotEmpty)
                                              Text(genres
                                                      .where((e) => e.id == film.genreIds.first)
                                                      .firstOrNull
                                                      ?.name
                                                      .toString() ??
                                                  ""),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
