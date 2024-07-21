import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/view_models/film_view_model_interface.dart';
import 'package:flutter_architecture/views/details_screen.dart';
import 'package:flutter_architecture/widgets/backdrop_widget.dart';

class FilmCard extends StatelessWidget {
  final Film film;

  const FilmCard({required this.film, super.key});

  FilmViewModelInterface get vm => FilmViewModelInterface.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailsPage(filmId: film.id)),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: double.infinity,
                  child: ValueListenableBuilder(
                      valueListenable: vm.imgConfig,
                      builder: (context, imgConfig, child) {
                        if (imgConfig == null) return Container();
                        return film.posterPath == null
                            ? Container()
                            : Image.network(
                                imgConfig.hdPosterUrl(film.posterPath!),
                                fit: BoxFit.cover,
                                loadingBuilder: (ctx, child, imageChunkEvent) {
                                  if (imageChunkEvent == null) return child;
                                  return Stack(
                                    children: [
                                      Image.network(
                                        imgConfig.ldPosterUrl(film.posterPath!),
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
                              );
                      }),
                ),
              ),
              Expanded(
                flex: 4,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropWidget(vm: vm, film: film),
                    ),
                    Positioned.fill(child: Container(color: Colors.black54)),
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
                                Text(
                                  film.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                Text(
                                  film.overview ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                if (film.genreIds.isNotEmpty)
                                  ValueListenableBuilder(
                                      valueListenable: vm.genres,
                                      builder: (context, genres, child) {
                                        if (genres == null) return Container();
                                        return Text(genres
                                                .where((e) => e.id == film.genreIds.first)
                                                .firstOrNull
                                                ?.name
                                                .toString() ??
                                            "");
                                      }),
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
  }
}
