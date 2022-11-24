import 'package:video_boxtv/core/utils/app_exceptions.dart';

import '../../models/response_audio_model.dart';
import '../../models/response_model.dart';
import '../../models/response_video_model.dart';

abstract class IVideoRepository {
  Future<ResponseModel<AudioPlayerModel, Failure>> getConfigs({required String app, required String token});
  Future<ResponseModel<ResponseVideoModel, Failure>> getVideos({required String app});
}
