import 'package:flutter/material.dart';
import 'package:view_model/view_model.dart';

class BackdropWidget extends StatefulWidget {
  const BackdropWidget({
    super.key,
    required this.vm,
    required this.film,
  });

  final BaseFilmViewModel vm;
  final FilmUiModel film;

  @override
  State<BackdropWidget> createState() => _BackdropWidgetState();
}

class _BackdropWidgetState extends State<BackdropWidget> {
  @override
  Widget build(BuildContext context) {
    var backdropPath = widget.film.backdropPathHd;
    if (backdropPath == null) return Container();
    var cachedImage = widget.vm.cachedImage(backdropPath);
    return cachedImage != null
        ? Image.memory(
            cachedImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        : Image.network(
            backdropPath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
  }
}
