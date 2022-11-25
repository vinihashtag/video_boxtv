import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_boxtv/core/adapters/local_storage/local_storage_adapter.dart';
import 'package:video_boxtv/core/adapters/toast/toast_adapter.dart';
import 'package:video_boxtv/core/controllers/connectivity_controller.dart';
import 'package:video_boxtv/core/utils/app_constants.dart';
import 'package:video_boxtv/core/utils/app_exceptions.dart';
import 'package:video_boxtv/data/models/local_file_model.dart';
import 'package:video_boxtv/data/repositories/file/file_repository_interface.dart';
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
  final IFileRepository _fileRepository;
  final ILocalStorageAdapter _localStorageAdapter;

  HomeController(
    this._videoRepository,
    this._authController,
    this._connectivityController,
    this._toastAdapter,
    this._fileRepository,
    this._localStorageAdapter,
  );

  // Controls status page
  final _statusPage = StatusPage.idle.obs;
  StatusPage get statusPage => _statusPage.value;
  set statusPage(StatusPage value) => _statusPage.value = value;

  // Controls button play
  final _visibleControls = false.obs;
  bool get visibleControls => _visibleControls.value;
  set visibleControls(bool value) => _visibleControls.value = value;

  // Controls list of videos
  ResponseVideoModel? _responseVideoModel;
  late AudioPlayerModel _audioPlayerModel;
  DownloadFileModel downloadFileModel = DownloadFileModel(files: []);
  int indexVideo = -1;
  bool tapOnVideo = false;
  bool _lastStatusConnection = false;
  String get appName => _responseVideoModel?.appName ?? '';
  late Worker _worker;

  // Controller players
  List<VideoPlayerController> listPlayers = [];
  final player = AudioPlayer(
    handleInterruptions: false,
    handleAudioSessionActivation: false,
    androidApplyAudioAttributes: false,
  );

  @override
  void onInit() {
    loadInitialInfos();

    _lastStatusConnection = _connectivityController.isConnected;

    _worker = ever<bool>(_connectivityController.rxConnected, (isConnected) {
      if (_lastStatusConnection == isConnected) return;

      if (isConnected) {
        if (statusPage == StatusPage.failure) {
          loadInitialInfos();
          return;
        }
        player.stop().whenComplete(() => player.setUrl(_audioPlayerModel.appStreaming).then((_) => player.play()));
      } else {
        player.stop().whenComplete(() => player.setAsset(AppConstants.localAudio).then((_) => player.play()));
      }

      _lastStatusConnection = isConnected;
    });

    // Enter on full screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    // Change preferred Orientations to landscape only
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);

    super.onInit();
  }

  /// Validates if file is not expired and update local list videos
  Future<void> _updateLocalListVideos() async {
    try {
      final String? localFiles = _localStorageAdapter.read(AppConstants.directoryFiles);
      if (localFiles != null) {
        downloadFileModel = DownloadFileModel.fromJson(localFiles);

        final futures = <Future>[];

        final list = List<LocalFileModel>.from(downloadFileModel.files);
        for (final file in list) {
          if (file.createdAt.isBefore(DateTime.now().subtract(const Duration(days: 3))) &&
              _connectivityController.isConnected) {
            futures.add(_fileRepository
                .deleteFile(file.localPath)
                .then((value) => Helpers.debug(value.isError ? value.error!.errorText : 'File is deleted')));

            downloadFileModel.files.remove(file);
          }
        }

        await Future.wait(futures);

        return _localStorageAdapter.write(AppConstants.directoryFiles, downloadFileModel.toJson());
      }
    } catch (e, s) {
      Helpers.error(e, s, identifier: '[HOME_CONTROLLER][_updateLocalListVideos]');
    }
  }

  /// Load all videos and start audio
  Future<void> loadInitialInfos({bool forceRestart = false}) async {
    try {
      statusPage = StatusPage.loading;

      if (forceRestart) {
        Get.back();
        await player.stop();
        for (final player in listPlayers) {
          player.pause();
          player.dispose();
        }
        listPlayers.clear();
      }

      final futures = await Future.wait([
        _videoRepository.getVideos(app: _authController.app.appName),
        _updateLocalListVideos(),
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
            if (_connectivityController.isConnected)
              player.setUrl(_audioPlayerModel.appStreaming)
            else
              player.setAsset(_audioPlayerModel.appStreaming)
          ]);

          _localStorageAdapter.write(AppConstants.directoryFiles, downloadFileModel.toJson());
          await listPlayers.first.play();
          listPlayers.first.addListener(listenerVideoPlayer);
          Helpers.debug('INDEX $indexVideo isInitialized: ${listPlayers[indexVideo].value.isInitialized}');
          Helpers.debug('INDEX $indexVideo isPlaying: ${listPlayers[indexVideo].value.isPlaying}');

          statusPage = StatusPage.success;

          if (!player.playing) await player.play();
        }
      } else {
        statusPage = StatusPage.failure;
        _toastAdapter.messageError(text: resultVideos.error?.errorText ?? 'Algo deu errado, verifique');
      }
    } catch (e, s) {
      statusPage = StatusPage.failure;
      Helpers.error(identifier: '[HOME_CONTROLLER][loadInitialInfos]', e, s);
      _toastAdapter.messageError(text: 'Algo deu errado, verifique: \n $e');
    }
  }

  Future<void> _loadVideo(String url) async {
    late final VideoPlayerController playerController;

    final LocalFileModel? localFileModel = downloadFileModel.files.firstWhereOrNull((element) => element.url == url);

    if (localFileModel == null) {
      if (!_connectivityController.isConnected) return;

      final file = await _fileRepository.downloadFileFromUrlByIsolate(url: url, folder: 'videos');

      if (file.isError) {
        playerController = VideoPlayerController.network(url);
      } else {
        playerController = VideoPlayerController.file(file.data!);
        downloadFileModel.files.add(LocalFileModel(createdAt: DateTime.now(), url: url, localPath: file.data!.path));
      }
    } else {
      playerController = VideoPlayerController.file(File(localFileModel.localPath));
      final int index = downloadFileModel.files.indexOf(localFileModel);
      if (index >= 0) {
        localFileModel.createdAt = DateTime.now();
        downloadFileModel.files[index] = localFileModel;
      }
    }

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
      if (statusPage == StatusPage.loading) return;
      statusPage = StatusPage.loading;

      final int position = indexVideo > 0 ? indexVideo - 1 : listPlayers.length - 1;

      listPlayers[position].removeListener(listenerVideoPlayer);
      listPlayers[position].pause();
      listPlayers[position].setVolume(0);
      listPlayers[position].seekTo(const Duration());

      await listPlayers[indexVideo].play();
      listPlayers[indexVideo].addListener(listenerVideoPlayer);
      Helpers.debug('INDEX $indexVideo isInitialized: ${listPlayers[indexVideo].value.isInitialized}');
      Helpers.debug('INDEX $indexVideo isPlaying: ${listPlayers[indexVideo].value.isPlaying}');
    } catch (e, s) {
      Helpers.error(identifier: '[HOME_CONTROLLER][_updateVideoPlayer]', e, s);
    }
  }

  void listenerVideoPlayer() {
    final bool isFinishedVideo = listPlayers[indexVideo].value.duration == listPlayers[indexVideo].value.position;

    if (isFinishedVideo) {
      indexVideo++;
      if (indexVideo >= (_responseVideoModel?.videos.length ?? 0)) indexVideo = 0;
      _updateVideoPlayer()
          .catchError((e, s) => Helpers.error(e, s, identifier: '[HOME_CONTROLLER][listenerVideoPlayer]'))
          .then((value) => statusPage = StatusPage.success);
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
      player.pause();
      player.dispose();
    }
    listPlayers.clear();
    _worker.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    super.onClose();
  }
}
