import 'dart:io';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/return_code.dart';
import 'package:video_editor/video_editor.dart';

class ExportService {
  static Future<File?> runExportVideo(
    VideoEditorController controller, {
    void Function(double progress)? onProgress,
  }) async {
    // 1. टाइमलाइन से स्टार्ट और एंड टाइम निकालना
    final start = controller.startTrim.inMilliseconds / 1000;
    final duration = (controller.endTrim - controller.startTrim).inMilliseconds / 1000;
    final inputPath = controller.file.path;
    
    // 2. आउटपुट फ़ाइल का पाथ तैयार करना
    final outputPath = inputPath.replaceAll('.mp4', '_10x_export.mp4');

    // 3. हमारी 18-स्टेप्स वाली टेस्टेड 10x रेंडरिंग कमांड
    final String command = 
        "-y -ss $start -t $duration -i \"$inputPath\" "
        "-c:v libx264 -preset ultrafast -crf 22 "
        "-c:a aac -b:a 128k \"$outputPath\"";

    final session = await FFmpegKit.execute(command);
    final returnCode = await session.getReturnCode();

    if (ReturnCode.isSuccess(returnCode)) {
      return File(outputPath);
    } else {
      return null;
    }
  }
}
