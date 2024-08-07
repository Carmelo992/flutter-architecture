import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_architecture/router/router.dart';
import 'package:flutter_architecture/widgets/backdrop_widget.dart';
import 'package:flutter_architecture/widgets/poster_widget.dart';
import 'package:view_model/view_model.dart';

class FilmCard extends StatelessWidget {
  final FilmUiModel film;
  final FilmViewModelInterface vm;

  const FilmCard({required this.film, required this.vm, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            DetailsScreenData(film.id, 0).go(context);
          },
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: double.infinity,
                  child: PosterWidget(vm: vm, film: film),
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
