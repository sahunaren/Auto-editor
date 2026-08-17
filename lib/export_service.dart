import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/statistics.dart';
import 'package:video_editor/video_editor.dart';

class ExportService {
  static Future<void> runFFmpegCommand(
    FFmpegVideoEditorExecute execute, {
    required void Function(File file) onCompleted,
    void Function(Object, StackTrace)? onError,
    void Function(Statistics)? onProgress,
  }) async {
    if (onProgress != null) {
      FFmpegKitConfig.enableStatisticsCallback(onProgress);
    }

    await FFmpegKit.executeAsync(
      execute.command,
      (session) async {
        final state = FFmpegKitConfig.sessionStateToString(
          await session.getState(),
        );
        final returnCode = await session.getReturnCode();

        if (ReturnCode.isSuccess(returnCode)) {
          onCompleted(File(execute.outputPath));
        } else {
          if (onError != null) {
            onError(
              Exception('FFmpeg failed with state :: $state and return code :: $returnCode'),
              StackTrace.current,
            );
          }
        }
      },
      null,
      (statistics) {
        if (onProgress != null) {
          onProgress(statistics);
        }
      },
    );
  }

  static void dispose() {
    FFmpegKit.cancel();
  }
}
