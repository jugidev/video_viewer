import 'package:helpers/helpers.dart';
import 'package:flutter/cupertino.dart';

import 'package:video_viewer/data/repositories/video.dart';

import 'package:video_viewer/widgets/overlay/widgets/play_and_pause.dart';
import 'package:video_viewer/widgets/overlay/widgets/background.dart';
import 'package:video_viewer/widgets/overlay/bottom.dart';
import 'package:video_viewer/widgets/settings_menu.dart';
import 'package:video_viewer/widgets/helpers.dart';

class VideoOverlay extends StatelessWidget {
  const VideoOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final query = VideoQuery();
    final style = query.videoMetadata(context, listen: true).style;
    final video = query.video(context, listen: true);
    final setting = ValueNotifier<bool>(false);

    final header = style.header;
    final visible = video.showOverlay;
    final controller = video.controller;

    return Stack(children: [
      if (header != null)
        CustomSwipeTransition(
          direction: SwipeDirection.fromTop,
          visible: visible,
          child: Align(
            alignment: Alignment.topLeft,
            child: GradientBackground(
              child: header,
              direction: Direction.top,
            ),
          ),
        ),
      CustomSwipeTransition(
        direction: SwipeDirection.fromBottom,
        visible: visible,
        child: ValueListenableBuilder(
          valueListenable: setting,
          builder: (_, value, ___) => OverlayBottomButtons(
            onShowSettings: () => setting.value = !value,
          ),
        ),
      ),
      AnimatedBuilder(
        animation: controller,
        builder: (_, __) => CustomOpacityTransition(
          visible: visible && !controller.value.isPlaying,
          child: Center(child: PlayAndPause(type: PlayAndPauseType.center)),
        ),
      ),
      ValueListenableBuilder(
        valueListenable: setting,
        builder: (_, value, ___) => CustomOpacityTransition(
          visible: value,
          child: SettingsMenu(
            onChangeVisible: () => setting.value = !value,
          ),
        ),
      ),
    ]);
  }
}
