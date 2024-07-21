import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture/generated/app_localizations.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_response_model.dart';
import 'package:flutter_architecture/model/genre_response_model.dart';
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
            Dio client = Dio(BaseOptions(
                baseUrl: "https://api.themoviedb.org/3/",
                queryParameters: {"api_key": "213c1a1d1f356ed0bf10c9656ab5d5cb"}));

            var responses = await Future.wait([
              client.get<Map<String, dynamic>>("movie/popular", queryParameters: {"language": "it-IT", "page": 1}),
              client.get<Map<String, dynamic>>("configuration"),
              client.get<Map<String, dynamic>>("genre/movie/list", queryParameters: {"language": "it-IT", "page": 1}),
            ]);
            print(responses[0].data);
            return {
              "film": responses[0].data != null ? FilmResponse.fromJson(responses[0].data!) : null,
              "configuration": responses[1].data != null ? Configuration.fromJson(responses[1].data!) : null,
              "genre": responses[2].data != null ? GenreResponse.fromJson(responses[2].data!) : null,
            };
          }).call(),
          builder: (context, snapshot) {
            var data = snapshot.data;
            if (data == null) return const Center(child: CircularProgressIndicator());
            var configurationResponse = data["configuration"] as Configuration?;
            var filmResponse = data["film"] as FilmResponse?;
            var genreResponse = data["genre"] as GenreResponse?;
            if (configurationResponse == null || filmResponse == null || genreResponse == null) return Container();
            var configuration = (configurationResponse).images;
            var films = filmResponse.films;
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
                                DetailsPage(details: film, configuration: configuration, genre: genreResponse.genres)),
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
                                              Text(genreResponse.genres
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
