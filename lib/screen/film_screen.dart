import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_architecture/fake_response/configuration_response.dart';
import 'package:flutter_architecture/fake_response/film_list_response.dart';
import 'package:flutter_architecture/fake_response/genre_response.dart';
import 'package:flutter_architecture/screen/details_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var configuration = configurationResponse["images"] as Map;
    var films = (filmResponse["results"]! as List);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: films.length,
        itemBuilder: (context, index) {
          var film = films.elementAt(index);
          return SizedBox(
            height: 180,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(details: film),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: double.infinity,
                        child: Hero(
                          tag: "${film["id"]}_poster",
                          child: Image.network(
                            "${configuration["base_url"]!}${configuration["poster_sizes"].last}${film["poster_path"]}",
                            fit: BoxFit.cover,
                            loadingBuilder: (ctx, child, imageChunkEvent) {
                              if (imageChunkEvent == null) return child;
                              return Stack(
                                children: [
                                  Image.network(
                                    "${configuration["base_url"]!}${configuration["poster_sizes"].first}${film["poster_path"]}",
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
                                              : imageChunkEvent.cumulativeBytesLoaded /
                                                  imageChunkEvent.expectedTotalBytes!),
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
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Hero(
                              tag: "${film["id"]}_backdrop",
                              child: film["backdrop_path"] != null
                                  ? Image.network(
                                      "${configuration["base_url"]!}${configuration["backdrop_sizes"].last}${film["backdrop_path"]}",
                                      fit: BoxFit.cover,
                                    )
                                  : Container(),
                            ),
                          ),
                          Positioned.fill(
                              child: Hero(
                            tag: "${film["id"]}_black",
                            child: Container(color: Colors.black54),
                          )),
                          SizedBox(
                            width: double.infinity,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: "${film["id"]}_title",
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Text(
                                            film["title"],
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        film["overview"],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const Spacer(),
                                      Text(genreResponse["genres"]!
                                              .where((e) => e["id"] == film["genre_ids"].first)
                                              .firstOrNull?["name"]
                                              .toString() ??
                                          ""),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
