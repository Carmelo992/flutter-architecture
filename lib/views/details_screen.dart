import 'package:flutter/material.dart';
import 'package:flutter_architecture/generated/app_localizations.dart';
import 'package:flutter_architecture/view_models/film_detail_view_model_interface.dart';
import 'package:flutter_architecture/widgets/backdrop_widget.dart';
import 'package:flutter_architecture/widgets/poster_widget.dart';
import 'package:intl/intl.dart';

class DetailsPage extends StatefulWidget {
  final int filmId;
  final FilmDetailViewModelInterface interface;

  const DetailsPage(this.interface, {required this.filmId, super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  FilmDetailViewModelInterface get vm => widget.interface;

  @override
  void initState() {
    vm.loadFilm(widget.filmId);
    super.initState();
  }

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
      body: ValueListenableBuilder(
          valueListenable: vm.film,
          builder: (context, film, child) {
            if (film == null) return Container();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      BackdropWidget(vm: vm, film: film),
                      Positioned.fill(child: Container(color: Colors.black54)),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Text(
                          film.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
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
                            Expanded(child: PosterWidget(vm: vm, film: film)),
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
                        ValueListenableBuilder(
                          valueListenable: vm.genres,
                          builder: (context, genres, child) {
                            if (genres == null) return Container();
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalization.of(context).genre,
                                  style: const TextStyle(fontSize: 24),
                                ),
                                ...film.genreIds
                                    .map((id) => genres.where((e) => e.id == id).firstOrNull)
                                    .where((e) => e != null)
                                    .map((e) => Text(e!.name)),
                              ],
                            );
                          },
                        ),
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
                        ValueListenableBuilder(
                          valueListenable: vm.relatedFilms,
                          builder: (context, relatedFilms, child) {
                            if (relatedFilms == null) {
                              return const Center(child: CircularProgressIndicator());
                            }
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
                                          onTap: () => Navigator.of(context)
                                              .pushNamed("details", arguments: [film.id]).then((_) {
                                            vm.loadFilm(widget.filmId);
                                          }),
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: PosterWidget(vm: vm, film: film),
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
            );
          }),
    );
  }
}
