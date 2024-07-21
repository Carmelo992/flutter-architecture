import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture/generated/app_localizations.dart';
import 'package:flutter_architecture/model/configuration_model.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/model/genre_model.dart';
import 'package:flutter_architecture/model/related_film_response_model.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final Film details;
  final ConfigurationImage configuration;
  final List<Genre> genre;

  const DetailsPage({required this.details, required this.configuration, required this.genre, super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Film get film => widget.details;

  ConfigurationImage get configuration => widget.configuration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        onPressed: Navigator.of(context).pop,
        backgroundColor: Colors.white,
        mini: true,
        shape: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: const Icon(Icons.close, color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              children: [
                Hero(
                  tag: "${film.id}_backdrop",
                  child: Opacity(
                    opacity: 1,
                    child: film.backdropPath != null
                        ? Image.network(
                            configuration.hdBackdropUrl(film.backdropPath!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(),
                  ),
                ),
                Positioned.fill(
                    child: Hero(
                  tag: "${film.id}_black",
                  child: Opacity(opacity: 1, child: Container(color: Colors.black54)),
                )),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Hero(
                    tag: "${film.id}_title",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        film.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
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
                      const SizedBox(width: 20),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalization.of(context).vote_average),
                          Text(
                            film.voteAverage.toStringAsFixed(2),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          Text(AppLocalization.of(context).total_votes),
                          Text(
                            "${film.voteCount.toInt()}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          Text(AppLocalization.of(context).popularity),
                          Text(
                            "${film.popularity.toInt()}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          if (film.releaseDate != null) ...[
                            const SizedBox(height: 10),
                            Text(AppLocalization.of(context).release_date),
                            Text(
                              DateFormat(AppLocalization.of(context).date_format).format(film.releaseDate!),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ]
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalization.of(context).genre,
                    style: const TextStyle(fontSize: 24),
                  ),
                  ...film.genreIds
                      .map((id) => widget.genre.where((e) => e.id == id).firstOrNull)
                      .where((e) => e != null)
                      .map((e) => Text(e!.name)),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalization.of(context).description,
                    style: const TextStyle(fontSize: 24),
                  ),
                  Text(film.overview ?? ""),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalization.of(context).similar_films,
                    style: const TextStyle(fontSize: 24),
                  ),
                  FutureBuilder(
                    future: (() async {
                      Dio client = Dio(BaseOptions(
                          baseUrl: "https://api.themoviedb.org/3/",
                          queryParameters: {"api_key": "213c1a1d1f356ed0bf10c9656ab5d5cb"}));

                      var response = await client.get<Map<String, dynamic>>("movie/${film.id}/similar",
                          queryParameters: {"language": "it-IT", "page": 1});

                      return response.data != null ? RelatedFilmResponse.fromJson(response.data!) : null;
                    }).call(),
                    builder: (context, snapshot) {
                      var data = snapshot.data;
                      if (data == null) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var relatedFilms = data.films;
                      return SizedBox(
                        height: 180,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            var film = relatedFilms.elementAt(index);
                            return AspectRatio(
                                aspectRatio: 3 / 4,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => DetailsPage(
                                          details: film,
                                          configuration: configuration,
                                          genre: widget.genre,
                                        ),
                                      ));
                                    },
                                    child: Stack(
                                      children: [
                                        Hero(
                                          tag: "${film.id}_backdrop",
                                          child: Opacity(
                                            opacity: 0,
                                            child: film.backdropPath != null
                                                ? Image.network(
                                                    configuration.hdBackdropUrl(film.backdropPath!),
                                                    fit: BoxFit.cover,
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                        Hero(
                                          tag: "${film.id}_black",
                                          child: Opacity(opacity: 0, child: Container(color: Colors.black54)),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
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
                                                                  style: const TextStyle(
                                                                      color: Colors.white, fontSize: 10),
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          },
                          separatorBuilder: (context, index) => const SizedBox(width: 10),
                          itemCount: relatedFilms.length,
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
