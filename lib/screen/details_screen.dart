import 'package:flutter/material.dart';
import 'package:flutter_architecture/fake_response/configuration_response.dart';
import 'package:flutter_architecture/fake_response/genre_response.dart';
import 'package:flutter_architecture/fake_response/related_films_response.dart';

class DetailsPage extends StatefulWidget {
  final Map<String, dynamic> details;

  const DetailsPage({required this.details, super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  dynamic get film => widget.details;

  @override
  Widget build(BuildContext context) {
    var configuration = configurationResponse["images"] as Map;
    var relatedFilms = (relatedFilmResponse["results"] as List).where((e) => e["id"] != film["id"]);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        onPressed: Navigator.of(context).pop,
        backgroundColor: Colors.white,
        mini: true,
        shape: CircleBorder(),
        child: Container(
          padding: EdgeInsets.all(4),
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
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
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
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
                      SizedBox(width: 20),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Media voto:"),
                          Text(
                            "${film["vote_average"]}",
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 10),
                          Text("Voti ricevuti:"),
                          Text(
                            "${film["vote_count"]}",
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 10),
                          Text("Popolarità:"),
                          Text(
                            "${film["popularity"]}",
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 10),
                          Text("Uscita:"),
                          Text(
                            "${film["release_date"]}",
                            style: TextStyle(fontSize: 24),
                          ),
                        ],
                      ))
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Genere:",
                    style: TextStyle(fontSize: 24),
                  ),
                  ...film["genre_ids"]
                      .map((id) => genreResponse["genres"]!.where((e) => e["id"] == id).firstOrNull)
                      .where((e) => e != null)
                      .map((e) => Text(
                            e["name"],
                          )),
                  SizedBox(height: 20),
                  Text(
                    "Descrizione:",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(film["overview"]),
                  SizedBox(height: 20),
                  Text(
                    "Film simili (??):",
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
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
                                      builder: (context) => DetailsPage(details: film),
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
                                    ],
                                  ),
                                ),
                              ));
                        },
                        separatorBuilder: (context, index) => SizedBox(width: 10),
                        itemCount: relatedFilms.length),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
