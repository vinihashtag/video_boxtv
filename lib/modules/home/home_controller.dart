import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_boxtv/core/adapters/toast/toast_adapter.dart';
import 'package:video_boxtv/core/controllers/connectivity_controller.dart';
import 'package:video_boxtv/core/utils/custom_cache_manager.dart';
import 'package:video_boxtv/core/utils/app_exceptions.dart';
import 'package:video_player/video_player.dart';

import '../../core/controllers/auth_controller.dart';
import '../../core/enums/status_page.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/response_audio_model.dart';
import '../../data/models/response_model.dart';
import '../../data/models/response_video_model.dart';
import '../../data/repositories/video/video_repository_interface.dart';
import '../../routes/app_pages.dart';

class HomeController extends GetxController {
  final IVideoRepository _videoRepository;
  final AuthController _authController;
  final ConnectivityController _connectivityController;
  final IToastAdapter _toastAdapter;

  HomeController(this._videoRepository, this._authController, this._connectivityController, this._toastAdapter);

  // Controls status page
  final _statusPage = StatusPage.idle.obs;
  StatusPage get statusPage => _statusPage.value;
  set statusPage(StatusPage value) => _statusPage.value = value;

  // Controls button play
  final _visibleControls = false.obs;
  bool get visibleControls => _visibleControls.value;
  set visibleControls(bool value) => _visibleControls.value = value;

  // Controls list of videos
  late ResponseVideoModel _responseVideoModel;
  late AudioPlayerModel _audioPlayerModel;
  int indexVideo = -1;
  bool tapOnVideo = false;

  // Controller players
  List<VideoPlayerController> listPlayers = [];
  final player =
      AudioPlayer(handleInterruptions: false, handleAudioSessionActivation: false, androidApplyAudioAttributes: false);

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    loadInitialInfos();
    super.onInit();
  }

  Future<void> loadInitialInfos({bool forceRestart = false}) async {
    try {
      statusPage = StatusPage.loading;

      if (forceRestart) {
        Get.back();
        await player.stop();
        for (final player in listPlayers) {
          player.dispose();
        }
        listPlayers.clear();
      }

      final futures = await Future.wait([
        _videoRepository.getVideos(app: _authController.app.appName),
        _videoRepository.getConfigs(app: _authController.app.appName, token: _authController.app.apiToken),
      ]);

      final resultVideos = futures.first as ResponseModel<ResponseVideoModel, Failure>;

      final resultAudio = futures.last as ResponseModel<AudioPlayerModel, Failure>;
      if (resultAudio.isSuccess) _audioPlayerModel = resultAudio.data!;

      if (resultVideos.isSuccess) {
        _responseVideoModel = resultVideos.data!;
        if (resultVideos.data!.videos.isEmpty) {
          statusPage = StatusPage.empty;
        } else {
          indexVideo = 0;

          final futures = <Future>[];
          for (final VideoModel video in resultVideos.data!.videos) {
            futures.add(_loadVideo(video.url));
          }

          await Future.wait([
            ...futures,
            if (_audioPlayerModel.appStreaming.startsWith('http'))
              if (_connectivityController.isConnected)
                player.setUrl(_audioPlayerModel.appStreaming)
              else if (_connectivityController.isConnected)
                player.setAsset(_audioPlayerModel.appStreaming)
          ]);

          listPlayers.first.play();
          listPlayers.first.addListener(listenerVideoPlayer);

          statusPage = StatusPage.success;

          if (!player.playing) await player.play();
        }
      } else {
        statusPage = StatusPage.failure;
        _toastAdapter.messageError(text: resultVideos.error!.errorText);
      }
    } catch (e, s) {
      statusPage = StatusPage.failure;
      Helpers.error(identifier: '[HOME_CONTROLLER][loadInitialInfos]', e, s);
      if (e is Failure) _toastAdapter.messageError(text: e.errorText);
    }
  }

  Future<void> _loadVideo(String url) async {
    final cache = CustomCacheManager.fromVideo();

    final file = await cache.getSingleFile(url);

    final playerController = VideoPlayerController.file(file);

    listPlayers.add(playerController);

    await playerController.initialize();

    playerController.setVolume(0);
  }

  void onTapVideo() {
    if (listPlayers[indexVideo].value.isPlaying) {
      listPlayers[indexVideo].pause();
      if (player.playing && _connectivityController.isConnected) player.stop();
      tapOnVideo = true;
    } else {
      listPlayers[indexVideo].play();
      if (!player.playing && _connectivityController.isConnected) player.play();
      visibleControls = false;
      tapOnVideo = false;
    }
  }

  Future<void> _updateVideoPlayer() async {
    try {
      statusPage = StatusPage.loading;
      if (indexVideo > 0) {
        listPlayers[indexVideo - 1].removeListener(listenerVideoPlayer);
        listPlayers[indexVideo - 1].pause();
        listPlayers[indexVideo - 1].seekTo(const Duration());
      }

      listPlayers[indexVideo].play();
      listPlayers[indexVideo].addListener(listenerVideoPlayer);
    } catch (e, s) {
      Helpers.error(identifier: '[HOME_CONTROLLER][_updateVideoPlayer]', e, s);
    }
  }

  void listenerVideoPlayer() {
    final bool isFinishedVideo = listPlayers[indexVideo].value.duration == listPlayers[indexVideo].value.position;

    if (isFinishedVideo) {
      indexVideo++;
      if (indexVideo >= _responseVideoModel.videos.length) indexVideo = 0;
      _updateVideoPlayer().then((value) => statusPage = StatusPage.success);
    }
  }

  Future<void> showControls() async {
    visibleControls = true;

    await Future.delayed(const Duration(seconds: 3));

    if (!tapOnVideo) visibleControls = false;
  }

  void logout() {
    Get.back();
    _authController.logout();
    Get.offAllNamed(Routes.login);
  }

  @override
  void onClose() {
    player.dispose();
    for (final player in listPlayers) {
      player.dispose();
    }
    listPlayers.clear();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.onClose();
  }
}
