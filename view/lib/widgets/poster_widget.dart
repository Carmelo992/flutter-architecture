import 'package:flutter/material.dart';
import 'package:view_model/view_model.dart';

class PosterWidget extends StatefulWidget {
  const PosterWidget({
    super.key,
    required this.vm,
    required this.film,
    this.height = double.infinity,
  });

  final BaseFilmViewModel vm;
  final FilmUiModel film;
  final double? height;

  @override
  State<PosterWidget> createState() => _PosterWidgetState();
}

class _PosterWidgetState extends State<PosterWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var posterPathHd = widget.film.posterPathHd;
    var posterPathLd = widget.film.posterPathLd;
    if (posterPathHd == null) return Container();
    var cachedImage = widget.vm.cachedImage(posterPathHd);
    if (cachedImage != null) {
      return Image.memory(
        cachedImage,
        width: double.infinity,
        height: widget.height,
        fit: BoxFit.cover,
      );
    }
    return Image.network(
      posterPathHd,
      fit: BoxFit.cover,
      loadingBuilder: (ctx, child, imageChunkEvent) {
        if (imageChunkEvent == null || posterPathLd == null) return child;
        return Stack(
          children: [
            Image.network(
              posterPathLd,
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
  }
}
