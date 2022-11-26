import 'package:video_boxtv/core/adapters/local_storage/local_storage_adapter.dart';
import 'package:video_boxtv/core/controllers/connectivity_controller.dart';
import 'package:video_boxtv/core/utils/app_constants.dart';
import 'package:video_boxtv/core/utils/app_exceptions.dart';

import '../../../core/adapters/rest_client/rest_client_adatper.dart';
import '../../models/response_audio_model.dart';
import '../../models/response_model.dart';
import '../../models/response_video_model.dart';
import 'video_repository_interface.dart';

class VideoRepository implements IVideoRepository {
  final IRestClientAdapter _restClient;
  final ConnectivityController _connectivityController;
  final ILocalStorageAdapter _localStorageAdapter;

  VideoRepository(this._restClient, this._connectivityController, this._localStorageAdapter);

  @override
  Future<ResponseModel<AudioPlayerModel, Failure>> getConfigs({required String app, required String token}) async {
    try {
      if (_connectivityController.isConnected) {
        final response = await _restClient.request(
          url: 'https://midiaindoor.hdmidia.com.br/json/config/?app=$app&token=$token',
          method: MethodRequest.get,
        );

        if (response.isError) return ResponseModel(error: response.error);

        final model = AudioPlayerModel.fromMap(response.data is String ? {} : response.data);

        _localStorageAdapter.write(AppConstants.configsVideoKey, model.toJson());

        return ResponseModel(data: model, error: response.error);
      } else {
        final response = await _localStorageAdapter.read(AppConstants.configsVideoKey);
        if (response != null) {
          return ResponseModel(data: AudioPlayerModel.fromJson(response));
        } else {
          return ResponseModel(error: ConnectionException(stackTrace: StackTrace.empty));
        }
      }
    } catch (e, s) {
      return ResponseModel(error: _restClient.handleError(e, s));
    }
  }

  @override
  Future<ResponseModel<ResponseVideoModel, Failure>> getVideos({required String app}) async {
    try {
      if (_connectivityController.isConnected) {
        final response = await _restClient.request(
          url: 'https://midiaindoor.hdmidia.com.br/json/videos/?app=$app',
          method: MethodRequest.get,
        );

        if (response.isError) return ResponseModel(error: response.error);

        final model = ResponseVideoModel.fromMap(response.data is String ? {} : response.data);

        await _localStorageAdapter.write(AppConstants.listVideosKey, model.toJson());

        return ResponseModel(data: model, error: response.error);
      } else {
        final response = await _localStorageAdapter.read(AppConstants.listVideosKey);
        if (response != null) {
          return ResponseModel(data: ResponseVideoModel.fromJson(response));
        } else {
          return ResponseModel(error: ConnectionException(stackTrace: StackTrace.empty));
        }
      }
    } catch (e, s) {
      return ResponseModel(error: _restClient.handleError(e, s));
    }
  }
}
