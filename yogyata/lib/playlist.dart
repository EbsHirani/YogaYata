import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:yogyata/playlist_card.dart';
import 'package:yogyata/poses.dart';
import 'package:yogyata/scale_route.dart';
import './util/pose_data.dart';

class Playlist extends StatelessWidget {
  final List<CameraDescription> cameras;
  final String title;
  final List<String> playlistNames;
  final String model;
  final Color color;

  const Playlist(
      {this.cameras, this.title, this.playlistNames, this.model, this.color});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(title),
      ),
      body: Center(
        child: Container(
          height: 500,
          child: Swiper(
            itemCount: playlistNames.length,
            loop: false,
            viewportFraction: 0.8,
            scale: 0.82,
            outer: true,
            pagination: SwiperPagination(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.all(32.0),
            ),
            onTap: (index) => _onPlayListSelect(
                context,
                playlistNames[index],
                allPlaylists['${title.toLowerCase()}AsanasPlaylist' +
                    (index + 1).toString()],
                this.color),
            itemBuilder: (BuildContext context, int index) {
              return Center(
                child: Container(
                  height: 360,
                  child: PlaylistCard(
                    asana: playlistNames[index],
                    color: color,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onPlayListSelect(
    BuildContext context,
    String title,
    List<String> asanas,
    Color color,
  ) async {
    Navigator.push(
      context,
      ScaleRoute(
        page: Poses(
          cameras: cameras,
          title: title,
          model: "assets/models/posenet_mv1_075_float_from_checkpoints.tflite",
          asanas: asanas,
          color: color,
        ),
      ),
    );
  }
}
