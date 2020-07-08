import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos_youtube/models/video.dart';

import '../api.dart';

class VideosBloc implements BlocBase {
  Api api;

  List<Video> videos;

  final _videosControler = StreamController<List<Video>>();
  Stream get outVideos => _videosControler.stream;
  // Sink get inVideos => _videosControler.sink;

  final _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if (search != null) {
      _videosControler.sink.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }
    _videosControler.sink.add(videos);
  }

  @override
  void dispose() {
    _videosControler.close();
    _searchController.close();
  }
}
