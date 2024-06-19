import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class RecordManager {
  FlutterSoundRecorder? _recorder;
  Directory? _appDirectory;

  RecordManager() {
    _recorder = FlutterSoundRecorder();
    _init();
  }

  Future<void> _init() async {
    await _recorder!.openRecorder();
    _appDirectory = await getApplicationDocumentsDirectory();
  }

  Future<String?> startRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    String filePath = '${_appDirectory!.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder!.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );

    return filePath;
  }

  Future<void> stopRecording() async {
    await _recorder!.stopRecorder();
  }

  Future<List<FileSystemEntity>> listFiles() async {
    return _appDirectory?.listSync() ?? [];
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<File?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  void dispose() {
    _recorder!.closeRecorder();
  }
}