import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:favoritos_youtube/models/video.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {
  Map<String, Video> _favorites = {};
  final key = 'favorites';

  FavoriteBloc() {
    SharedPreferences.getInstance().then((value) {
      if (value.getKeys().contains(key)) {
        _favorites = json.decode(value.getString(key)).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();
        _favoriteController.add(_favorites);
      }
    });
  }

  final _favoriteController =
      BehaviorSubject<Map<String, Video>>(seedValue: {});
  Stream<Map<String, Video>> get outFavorite => _favoriteController.stream;

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else {
      _favorites[video.id] = video;
    }

    _favoriteController.sink.add(_favorites);
    _saveFavorite();
  }

  void _saveFavorite() {
    SharedPreferences.getInstance().then((value) {
      value.setString(key, json.encode(_favorites));
    });
  }

  @override
  void dispose() {
    _favoriteController.close();
  }
}
