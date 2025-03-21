part of 'on_tune_bloc.dart';

sealed class OnTuneEvent extends Equatable {
  const OnTuneEvent();
  @override
  List<Object> get props => [];
}

class LoadTune extends OnTuneEvent {}

class FindAudio extends OnTuneEvent {
  final String youtubeUrl;
  const FindAudio(this.youtubeUrl);
  @override
  List<Object> get props => [youtubeUrl];
}

class FindArtist extends OnTuneEvent {
  final String artistName;
  const FindArtist(this.artistName);
  @override
  List<Object> get props => [artistName];
}

class FindLyrics extends OnTuneEvent {
  final String title;
  final String writer;
  const FindLyrics(this.title, this. writer);
  @override
  List<Object> get props => [title, writer];
}

class FetchWeather extends OnTuneEvent {
  final String city;
  const FetchWeather(this.city);

  @override
  List<Object> get props => [city];
}

class FetchSongs extends OnTuneEvent {
  final String query;
  const FetchSongs(this.query);
}