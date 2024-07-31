import 'package:flutter/material.dart';
import 'package:app_youtube/services/Api.dart';
import 'package:app_youtube/model/Video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Inicio extends StatefulWidget {

  String? pesquisa;

  Inicio(this.pesquisa);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {

  Future<List<Video>> _listarVideos(String pesquisa){
    Api api = Api();
    return api.pesquisar(pesquisa);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Video>>(
      future: _listarVideos( widget.pesquisa ?? '' ),
      builder: (context, snapshot){
        print("================================================");
        print(snapshot.hasData);
        print(snapshot.data);
        print("================================================");
        switch( snapshot.connectionState ){
          case ConnectionState.none :
          case ConnectionState.waiting :
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active :
          case ConnectionState.done :
            if( snapshot.hasData ){

              return ListView.separated(
                  itemBuilder: (context, index){

                    List<Video>? videos = snapshot.data;
                    Video video = videos![index];

                    print(video);

                    return GestureDetector(
                      onTap: (){
                        YoutubePlayer(
                          controller: YoutubePlayerController.fromVideoId(
                            videoId: video.id,
                            autoPlay: true,
                            startSeconds: 0.0,
                            params: const YoutubePlayerParams(showFullscreenButton: true),
                          ),
                          aspectRatio: 16 / 9,
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage( video.imagem ),
                                )
                            ),
                          ),
                          ListTile(
                            title: Text( video.titulo ),
                            subtitle: Text( video.canal ),
                          )
                        ],
                      ),
                    );

                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  itemCount: snapshot.data!.length
              );

            } else {
              return const Center(
                child: Text("Nenhum dado a ser exibido!"),
              );
            }
        }
      },
    );
  }
}
