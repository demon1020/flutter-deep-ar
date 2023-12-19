import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ar_deep/src/spec_model.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../theme/theme.dart';
import 'api_key.dart';
import 'asset_constants.dart';
import 'asset_effects_constants.dart';

class TryOnProvider extends ChangeNotifier {
  late final DeepArController deepArController;
  late ScrollController scrollController;
  Timer? timer;
  Duration _elapsedTime = Duration.zero;

  bool isFrontCameraOpen = true;
  int deepIndex = 0;
  File? videoFile;
  File? currentFile;
  String recordingTime = "00:00";
  List<SpecModel> specList = [
    SpecModel("Black", AssetConstants.one, AppTheme.primaryLight,
        AssetEffectsConstants.sunglassBlack,
        isSelected: true),
    SpecModel("Blue", AssetConstants.two, AppTheme.primaryLight,
        AssetEffectsConstants.sunglassBlue,
        isSelected: false),
    SpecModel("Green", AssetConstants.three, AppTheme.primaryLight,
        AssetEffectsConstants.sunglassGreen,
        isSelected: false),
    SpecModel("Pink", AssetConstants.four, AppTheme.primaryLight,
        AssetEffectsConstants.sunglassPink,
        isSelected: false),
    SpecModel("Purple", AssetConstants.five, AppTheme.primaryLight,
        AssetEffectsConstants.sunglassPurple,
        isSelected: false),
    SpecModel("Red", AssetConstants.six, AppTheme.primaryLight,
        AssetEffectsConstants.sunglassRed,
        isSelected: false),
    SpecModel("White", AssetConstants.seven, AppTheme.primaryLight,
        AssetEffectsConstants.sunglassWhite,
        isSelected: false),
    SpecModel("Yellow", AssetConstants.eight, AppTheme.primaryLight,
        AssetEffectsConstants.sunglassYellow,
        isSelected: false),
  ];

  init() async {
    deepArController = DeepArController();
    scrollController = ScrollController();
    await deepArController.initialize(
      androidLicenseKey: ApiKey.deepArAndroidLicenceKey,
      iosLicenseKey: "---iOS key---",
      resolution: Resolution.high,
    );
    changeSpec(deepIndex);
    notifyListeners();
  }

  void changeSpec(int index, {bool onTap = false}) {
    var itemIndex =
        specList.indexWhere((element) => element.isSelected == true);
    deepIndex = index;
    if (itemIndex != -1) {
      specList[itemIndex].isSelected = false;
    }
    if (!onTap) {
      scrollController.jumpTo(deepIndex.toDouble() * 100);
    }
    specList[index].isSelected = !specList[index].isSelected;
    deepArController.switchEffect(specList[index].deeparPath);
    notifyListeners();
  }

  changeCamera() async {
    var cameraDirection = await deepArController.flipCamera();
    isFrontCameraOpen =
        cameraDirection.toString() == "CameraDirection.front" ? true : false;
    notifyListeners();
  }

  Future<String> toggleFlash() async {
    if (!isFrontCameraOpen) {
      await deepArController.toggleFlash();
    } else {
      return "Please switch to rear camera to enable flash";
    }
    notifyListeners();
    return "";
  }

  disposeData() async {
    currentFile = null;
    scrollController.dispose();
    await deepArController.destroy();
  }

  Future<String> takeScreenshot() async {
    try {
      var file = await deepArController.takeScreenshot();
      currentFile = file;
      // openAnyFile(currentFile!);
      notifyListeners();
      return "";
    } catch (e) {
      notifyListeners();
      return e.toString();
    }
  }
  //
  // openAnyFile(File file) {
  //   OpenFile.open(file.path);
  //   notifyListeners();
  // }

  Future<void> startVideoRecording() async {
    await deepArController.startVideoRecording();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      recordingTime = timer.tick.toString();
      log("babu : $recordingTime");
      _elapsedTime = Duration(seconds: timer.tick);
      recordingTime = _formatDuration(_elapsedTime);
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> stopVideoRecording() async {
    if (deepArController.isRecording) {
      File? file = await deepArController.stopVideoRecording();
      timer!.cancel();
      recordingTime = "";
      // OpenFile.open(file.path);
      currentFile = file;
    }
    notifyListeners();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  shareMedia() async {
    if (currentFile != null) {
      await Share.shareFiles([currentFile!.path], text: 'Check out this amazing 3D try on feature!',);
      currentFile = null;
    }
    notifyListeners();
  }
}
