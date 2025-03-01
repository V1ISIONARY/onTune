part of 'on_tune_bloc.dart';

sealed class OnTuneState extends Equatable {
  const OnTuneState();
  @override
  List<Object> get props => [];
}

class LoadingTune extends OnTuneState {}

class FetchExplorer extends OnTuneState {
  final List<Randomized> explorerList;
  const FetchExplorer(this.explorerList);
  @override
  List<Object> get props => [explorerList];
}

class FetchedAudio extends OnTuneState {
  final String musicTitle;
  final String musicWriter;
  final String audioUrl;
  final String lyrics;
  const FetchedAudio(this.musicTitle, this.musicWriter, this.audioUrl, this.lyrics);
  @override
  List<Object> get props => [musicTitle, musicWriter, audioUrl, lyrics];
}

class FetchedArtist extends OnTuneState {
  final String artist;
  final String description; 

  const FetchedArtist(this.artist, this.description);
  @override
  List<Object> get props => [artist];
}

class ErrorTune extends OnTuneState {
  final String response;
  const ErrorTune(this.response);
  @override
  List<Object> get props => [response];
}
