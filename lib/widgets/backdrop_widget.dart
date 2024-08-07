import 'package:flutter/material.dart';
import 'package:flutter_architecture/ui_model/film_ui_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';

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
