import 'package:flutter/material.dart';
import 'package:flutter_architecture/generated/app_localizations.dart';
import 'package:flutter_architecture/view_models/film_view_model_interface.dart';
import 'package:flutter_architecture/widgets/film_card.dart';

class MyHomePage extends StatefulWidget {
  final FilmViewModelInterface vm;

  const MyHomePage({required this.vm, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilmViewModelInterface get vm => widget.vm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalization.of(context).name),
      ),
      body: ValueListenableBuilder(
        valueListenable: vm.films,
        builder: (context, films, child) {
          if (films == null) return Container();
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: films.length,
            itemBuilder: (context, index) {
              var film = films.elementAt(index);
              return FilmCard(film: film, vm: vm);
            },
          );
        },
      ),
    );
  }
}
