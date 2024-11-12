import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ontune/backend/services/model/randomized.dart';
import 'package:ontune/backend/services/repository.dart';

part 'on_tune_event.dart';
part 'on_tune_state.dart';

class OnTuneBloc extends Bloc<OnTuneEvent, OnTuneState> {
  final OnTuneRepository repository;

  OnTuneBloc(this.repository) : super(LoadingTune()) {

    on<LoadTune>((event, emit) async {
      emit(LoadingTune());
      try {
        final explorerList = await repository.fetchExplore();
        emit(FetchExplorer(explorerList));
      } catch (e) {
        emit(ErrorTune("Failed to fetch list"));
      }
    });

    on<FindAudio>((event, emit) async {

      emit(LoadingTune());  // Show loading state while fetching data
      try {

        // Fetching the classification data based on youtubeUrl
        final audioProperties = await repository.initializeAudio(event.youtubeUrl);
        if (audioProperties != null) {
          emit(FetchedAudio(
            audioProperties.musicTitle,
            audioProperties.musicWriter,
            audioProperties.audioUrl,
            audioProperties.lyrics,
          ));
        } else {
          emit(const ErrorTune("Failed to fetch audio."));
        }

      } catch (e) {
        emit(ErrorTune("Error occurred: ${e.toString()}"));
      }

    });

  }

}
