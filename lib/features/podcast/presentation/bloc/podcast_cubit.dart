
import 'package:legacy_sync/features/podcast/presentation/bloc/podcast_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/images/images.dart';
import '../../data/model/build_own_podcast_model.dart';
import '../../domain/podcast_usecase/podcast_usecase.dart';


class PodcastCubit extends Cubit<PodcastState> {
  PodcastCubit() : super(PodcastState.initial());
  PodcastUsecase podcastUsecase = PodcastUsecase();
  List<BuildOwnPodcastModel> buildOwnPodcastList = [
    BuildOwnPodcastModel(title: "Record Your Thoughts", subtitle: "Start recording solo or invite someone using a collaboration code.", image: Images.icon_1podcast),
    BuildOwnPodcastModel(title: "Use Question Cards", subtitle: "Pick a topic, we’ll give you conversation starters.", image: Images.icon_2podcast),
    BuildOwnPodcastModel(title: "Edit Your Podcast", subtitle: "Trim parts, adjust sound, and make it feel just right.", image: Images.icon_3podcast),
    BuildOwnPodcastModel(title: "Post or Save for Later",  subtitle: "Publish it for your collaborators or keep it as a draft.", image: Images.icon_4podcast),
  ];



  @override
  Future<void> close() async {

    return super.close();
  }

  void fetchBuildOnwPodcast() async {

    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(buildOwnPodcastList: buildOwnPodcastList));
    emit(state.copyWith(isLoading: false));


  }


}