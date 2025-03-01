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