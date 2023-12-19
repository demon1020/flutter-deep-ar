import 'package:ar_deep/src/tryon_provider.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/theme.dart';
import '../widgets/app_circle_icon_button.dart';
import '../widgets/show_snackbar.dart';

class TryOnScreen extends StatefulWidget {
  const TryOnScreen({Key? key}) : super(key: key);

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  @override
  void initState() {
    super.initState();
    var provider = Provider.of<TryOnProvider>(context, listen: false);
    provider.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    var provider = Provider.of<TryOnProvider>(context, listen: false);
    provider.disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TryOnProvider>(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Transform.scale(
            scale: (1 / provider.deepArController.aspectRatio) /
                size.aspectRatio,
            child: provider.deepArController.isInitialized
                ? DeepArPreview(
                    provider.deepArController,
                    onViewCreated: () {
                      // deepArController.switchEffect(specList[deepIndex].deeparPath);
                    },
                  )
                : const Center(child: Text("Loading Preview...")),
          ),
          _topMediaOptions(context),
          _buildSpecs(context),
          _bottomMediaOptions(context),
        ],
      ),
    );
  }

  Container _topMediaOptions(BuildContext context) {
    var provider = Provider.of<TryOnProvider>(context);
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 40,left: 20,right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              provider.isFrontCameraOpen
                  ? SizedBox.shrink()
                  : AppCircleIconButton(
                      onTap: () async {
                        String message = await provider.toggleFlash();
                        if (message.isNotEmpty) {
                          showSnackBar(context: context, message: message);
                        }
                      },
                      iconData: provider.deepArController.flashState
                          ? Icons.flash_on
                          : Icons.flash_off,
                    ),

              Visibility(
                visible: provider.deepArController.isRecording,
                child: Container(
                  height: 50,
                  width: 100,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      shape: StadiumBorder(),
                      color: AppTheme.primaryLight.withOpacity(0.2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.fiber_manual_record,
                        color:
                            (provider.timer != null && provider.timer!.tick.isEven)
                                ? Colors.pink
                                : Colors.black,
                      ),
                      Text(provider.recordingTime),
                    ],
                  ),
                ),
              ),
              AppCircleIconButton(
                onTap: provider.changeCamera,
                iconData: Icons.cameraswitch,
              ),
            ],
          ),
          SizedBox(height: 10,),
          provider.currentFile == null
              ? SizedBox.shrink()
              : AppCircleIconButton(
            onTap: provider.shareMedia,
            iconData: Icons.share,
          ),
        ],
      ),
    );
  }

  Positioned _bottomMediaOptions(BuildContext context) {
    var provider = Provider.of<TryOnProvider>(context);
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppCircleIconButton(
              onTap: () {
                provider.deepIndex--;
                if (provider.deepIndex < 0) {
                  provider.deepIndex = provider.specList.length - 1;
                }
                provider.changeSpec(provider.deepIndex);
              },
              iconData: Icons.arrow_back_ios,
            ),
            GestureDetector(
              onTap: () async {
                String message = await provider.takeScreenshot();
                if (message.isNotEmpty) {
                  showSnackBar(context: context, message: message);
                }
              },
              onLongPress: () async {
                await provider.startVideoRecording();
              },
              onLongPressEnd: (value) async {
                await provider.stopVideoRecording();
              },
              child: Container(
                height: 90,
                width: 90,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryLight,
                  border: Border.all(
                    color: provider.deepArController.isRecording
                        ? AppTheme.primaryDark
                        : AppTheme.primaryDark.withOpacity(0.5),
                    width: provider.deepArController.isRecording ? 10 : 7,
                  ),
                ),
                child: provider.deepArController.isRecording
                    ? Icon(Icons.videocam, size: 40)
                    : Icon(Icons.photo_camera, size: 40),
              ),
            ),
            AppCircleIconButton(
              onTap: () {
                provider.deepIndex++;
                if (provider.deepIndex > provider.specList.length - 1) {
                  provider.deepIndex = 0;
                }
                provider.changeSpec(provider.deepIndex);
              },
              iconData: Icons.arrow_forward_ios,
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildSpecs(BuildContext context) {
    var provider = Provider.of<TryOnProvider>(context);
    return Positioned(
      bottom: 100,
      child: Container(
        height: provider.specList[provider.deepIndex].isSelected ? 90 : 70,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          controller: provider.scrollController,
          children: [
            ...List.generate(
              provider.specList.length,
              (index) => GestureDetector(
                onTap: () {
                  provider.changeSpec(index, onTap: true);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withOpacity(0.4),
                    shape: BoxShape.circle,
                    border: provider.specList[index].isSelected
                        ? Border.all(
                            color: AppTheme.primaryDark,
                            width: 5,
                          )
                        : Border.all(
                            color: AppTheme.primaryLight,
                          ),
                  ),
                  child: SizedBox(
                    height: provider.specList[provider.deepIndex].isSelected
                        ? 70
                        : 90,
                    width: provider.specList[provider.deepIndex].isSelected
                        ? 70
                        : 90,
                    child: ClipOval(
                      child: Image.asset(
                        provider.specList[index].thumbPath,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
