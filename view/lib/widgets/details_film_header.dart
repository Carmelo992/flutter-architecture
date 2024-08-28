import 'package:flutter/material.dart';
import 'package:view/widgets/backdrop_widget.dart';
import 'package:view_model/view_model.dart';

class DetailsHeader extends StatelessWidget {
  const DetailsHeader({
    super.key,
    required this.vm,
    required this.film,
  });

  final BaseFilmViewModelInterface vm;
  final FilmUiModel film;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.textScalerOf(context).scale(220).clamp(220, 440),
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
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          )
        ],
      ),
    );
  }
}
