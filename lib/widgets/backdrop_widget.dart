import 'package:flutter/material.dart';
import 'package:flutter_architecture/model/film_model.dart';
import 'package:flutter_architecture/view_models/base_film_view_model_interface.dart';

class BackdropWidget extends StatefulWidget {
  const BackdropWidget({
    super.key,
    required this.vm,
    required this.film,
    this.opacity = 1,
  });

  final BaseFilmViewModelInterface vm;
  final Film film;
  final double opacity;

  @override
  State<BackdropWidget> createState() => _BackdropWidgetState();
}

class _BackdropWidgetState extends State<BackdropWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.vm.imgConfig,
        builder: (context, imgConfig, child) {
          if (imgConfig == null) return Container();
          return widget.film.backdropPath != null
              ? Opacity(
                  opacity: widget.opacity,
                  child: Image.network(
                    imgConfig.hdBackdropUrl(widget.film.backdropPath!),
                    fit: BoxFit.cover,
                  ),
                )
              : Container();
        });
  }
}
