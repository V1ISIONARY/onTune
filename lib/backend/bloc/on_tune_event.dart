part of 'on_tune_bloc.dart';

sealed class OnTuneEvent extends Equatable {
  const OnTuneEvent();

  @override
  List<Object> get props => [];
  
}

class LoadTune extends OnTuneEvent {}

class FindAudio extends OnTuneEvent {
  final String youtubeUrl; // Accept youtubeUrl here

  const FindAudio(this.youtubeUrl); // Constructor to receive youtubeUrl

  @override
  List<Object> get props => [youtubeUrl];
}