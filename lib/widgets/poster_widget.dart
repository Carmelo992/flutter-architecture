import 'package:flutter/material.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';

class PosterWidget extends StatefulWidget {
  const PosterWidget({
    super.key,
    required this.vm,
    required this.film,
  });

  final BaseFilmViewModelInterface vm;
  final Film film;

  @override
  State<PosterWidget> createState() => _PosterWidgetState();
}

class _PosterWidgetState extends State<PosterWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
        valueListenable: widget.vm.imgConfig,
        builder: (context, imgConfig, child) {
          var posterPath = widget.film.posterPath;
          if (imgConfig == null || posterPath == null) return Container();
          var cachedImage = widget.vm.cachedImage(imgConfig.hdPosterUrl(posterPath));
          if (cachedImage != null) return Image.memory(cachedImage);
          return Image.network(
            imgConfig.hdPosterUrl(posterPath),
            fit: BoxFit.cover,
            loadingBuilder: (ctx, child, imageChunkEvent) {
              if (imageChunkEvent == null) return child;
              return Stack(
                children: [
                  Image.network(
                    imgConfig.ldPosterUrl(posterPath),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
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
