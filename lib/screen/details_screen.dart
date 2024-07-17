import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> details;
  final Map<String, dynamic> configuration;
  final Map<String, dynamic> genre;

  const DetailsPage({required this.details, required this.configuration, required this.genre, super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  dynamic get film => widget.details;

  @override
  Widget build(BuildContext context) {
    var configuration = widget.configuration;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        onPressed: Navigator.of(context).pop,
        backgroundColor: Colors.white,
        mini: true,
        shape: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(4),
          child: const Icon(Icons.close, color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              children: [
                Hero(
                  tag: "${film["id"]}_backdrop",
                  child: Opacity(
                    opacity: 1,
                    child: film["backdrop_path"] != null
                        ? Image.network(
                            "${configuration["base_url"]!}${configuration["backdrop_sizes"].last}${film["backdrop_path"]}",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(),
                  ),
                ),
                Positioned.fill(
                    child: Hero(
                  tag: "${film["id"]}_black",
                  child: Opacity(opacity: 1, child: Container(color: Colors.black54)),
                )),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Hero(
                    tag: "${film["id"]}_title",
                    child: Material(
                      type: MaterialType.transparency,
                      child: Text(
                        film["title"],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
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
                      const SizedBox(width: 20),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Media voto:"),
                          Text(
                            "${film["vote_average"]}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          const Text("Voti ricevuti:"),
                          Text(
                            "${film["vote_count"]}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          const Text("Popolarità:"),
                          Text(
                            "${film["popularity"]}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          const Text("Uscita:"),
                          Text(
                            "${film["release_date"]}",
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Genere:",
                    style: TextStyle(fontSize: 24),
                  ),
                  ...film["genre_ids"]
                      .map((id) => (widget.genre["genres"] as List).where((e) => e["id"] == id).firstOrNull)
                      .where((e) => e != null)
                      .map((e) => Text(
                            e["name"],
                          )),
                  const SizedBox(height: 20),
                  const Text(
                    "Descrizione:",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(film["overview"]),
                  const SizedBox(height: 20),
                  const Text(
                    "Film simili (??):",
                    style: TextStyle(fontSize: 24),
                  ),
                  FutureBuilder(
                      future: (() async {
                        Dio client = Dio(BaseOptions(
                            baseUrl: "https://api.themoviedb.org/3/",
                            queryParameters: {"api_key": "213c1a1d1f356ed0bf10c9656ab5d5cb"}));

                        return client.get<Map<String, dynamic>>("movie/${film["id"]}/similar",
                            queryParameters: {"language": "it-IT", "page": 1});
                      }).call(),
                      builder: (context, snapshot) {
                        var data = snapshot.data?.data;
                        if (data == null) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        var relatedFilms = data["results"] as List;
                        return SizedBox(
                          height: 180,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                var film = relatedFilms.elementAt(index);
                                return AspectRatio(
                                    aspectRatio: 3 / 4,
                                    child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => DetailsPage(
                                              details: film,
                                              configuration: widget.configuration,
                                              genre: widget.genre,
                                            ),
                                          ));
                                        },
                                        child: Stack(
                                          children: [
                                            Hero(
                                              tag: "${film["id"]}_backdrop",
                                              child: Opacity(
                                                opacity: 0,
                                                child: film["backdrop_path"] != null
                                                    ? Image.network(
                                                        "${configuration["base_url"]!}${configuration["backdrop_sizes"].last}${film["backdrop_path"]}",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Container(),
                                              ),
                                            ),
                                            Hero(
                                              tag: "${film["id"]}_black",
                                              child: Opacity(opacity: 0, child: Container(color: Colors.black54)),
                                            ),
                                            SizedBox(
                                              width: double.infinity,
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
                                                                style:
                                                                    const TextStyle(color: Colors.white, fontSize: 10),
                                                              ),
                                                            ),
                                                          )
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                              separatorBuilder: (context, index) => const SizedBox(width: 10),
                              itemCount: relatedFilms.length),
                        );
                      })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
