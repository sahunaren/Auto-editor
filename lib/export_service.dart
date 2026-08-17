import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';

class ExportService {
  static Future<FFmpegSession> runFFmpegCommand(
    String command, {
    void Function(FFmpegSession)? onComplete,
    void Function(String)? onLog,
  }) async {
    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      if (onComplete != null) {
        onComplete(session);
      }
    } else {
      print('FFmpeg failed with return code: $returnCode');
    }

    return session;
  }

  static void dispose() {
    FFmpegKit.cancel();
  }
}
