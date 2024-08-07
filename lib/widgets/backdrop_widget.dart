import 'package:flutter/material.dart';
import 'package:view_model/view_model.dart';

class BackdropWidget extends StatefulWidget {
  const BackdropWidget({
    super.key,
    required this.vm,
    required this.film,
    this.opacity = 1,
  });

  final BaseFilmViewModelInterface vm;
  final FilmUiModel film;
  final double opacity;

  @override
  State<BackdropWidget> createState() => _BackdropWidgetState();
}

class _BackdropWidgetState extends State<BackdropWidget> {
  @override
  Widget build(BuildContext context) {
    var backdropPath = widget.film.backdropPathHd;
    if (backdropPath == null) return Container();
    var cachedImage = widget.vm.cachedImage(backdropPath);
    return Opacity(
      opacity: widget.opacity,
      child: cachedImage != null
          ? Image.memory(cachedImage)
          : Image.network(
              backdropPath,
              fit: BoxFit.cover,
            ),
    );
  }
}
