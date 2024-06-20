import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/subtitle_wrapper_package.dart';
import 'package:video_player/video_player.dart';

class SubtitleWrapper extends StatefulWidget {
  const SubtitleWrapper({
    required this.videoChild,
    required this.subtitleController,
    required this.videoPlayerController,
    super.key,
    this.subtitleStyle = const SubtitleStyle(),
    this.backgroundColor,
  });
  final Widget videoChild;
  final SubtitleController subtitleController;
  final VideoPlayerController videoPlayerController;
  final SubtitleStyle subtitleStyle;
  final Color? backgroundColor;

  @override
  State<SubtitleWrapper> createState() => _SubtitleWrapperState();
}

class _SubtitleWrapperState extends State<SubtitleWrapper> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.videoChild,
        if (widget.subtitleController.showSubtitles)
          Positioned(
            top: widget.subtitleStyle.position.top,
            bottom: widget.subtitleStyle.position.bottom,
            left: widget.subtitleStyle.position.left,
            right: widget.subtitleStyle.position.right,
            child: BlocProvider(
              create: (context) => SubtitleBloc(
                videoPlayerController: widget.videoPlayerController,
                subtitleRepository: SubtitleDataRepository(
                  subtitleController: widget.subtitleController,
                ),
                subtitleController: widget.subtitleController,
              )..add(
                  InitSubtitles(
                    subtitleController: widget.subtitleController,
                  ),
                ),
              child: SubtitleTextView(
                subtitleStyle: widget.subtitleStyle,
                backgroundColor: widget.backgroundColor,
              ),
            ),
          )
        else
          Container(),
      ],
    );
  }
}
