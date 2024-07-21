import 'package:flutter/material.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';

class PosterWidget extends StatelessWidget {
  const PosterWidget({
    super.key,
    required this.vm,
    required this.film,
  });

  final BaseFilmViewModelInterface vm;
  final Film film;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
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
                                    : imageChunkEvent.cumulativeBytesLoaded / imageChunkEvent.expectedTotalBytes!),
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
        });
  }
}
