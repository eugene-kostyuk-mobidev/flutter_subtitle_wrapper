import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subtitle_wrapper_package/bloc/subtitle/subtitle_bloc.dart';
import 'package:subtitle_wrapper_package/data/constants/view_keys.dart';
import 'package:subtitle_wrapper_package/data/models/style/subtitle_style.dart';

class SubtitleTextView extends StatefulWidget {
  const SubtitleTextView({
    required this.subtitleStyle,
    super.key,
    this.backgroundColor,
  });

  final SubtitleStyle subtitleStyle;
  final Color? backgroundColor;

  @override
  State<SubtitleTextView> createState() => _SubtitleTextViewState();
}

class _SubtitleTextViewState extends State<SubtitleTextView> {
  TextStyle get _textStyle {
    return widget.subtitleStyle.hasBorder
        ? TextStyle(
            fontSize: widget.subtitleStyle.fontSize,
            foreground: Paint()
              ..style = widget.subtitleStyle.borderStyle.style
              ..strokeWidth = widget.subtitleStyle.borderStyle.strokeWidth
              ..color = widget.subtitleStyle.borderStyle.color,
          )
        : TextStyle(
            fontSize: widget.subtitleStyle.fontSize,
            color: widget.subtitleStyle.textColor,
          );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubtitleBloc, SubtitleState>(
      listener: _subtitleBlocListener,
      builder: (context, state) {
        if (state is LoadedSubtitle && state.subtitle != null) {
          return Stack(
            children: <Widget>[
              Center(
                child: Container(
                  color: widget.backgroundColor,
                  child: _TextContent(
                    text: state.subtitle!.text,
                    textStyle: _textStyle,
                  ),
                ),
              ),
              if (widget.subtitleStyle.hasBorder)
                Center(
                  child: Container(
                    color: widget.backgroundColor,
                    child: _TextContent(
                      text: state.subtitle!.text,
                      textStyle: TextStyle(
                        color: widget.subtitleStyle.textColor,
                        fontSize: widget.subtitleStyle.fontSize,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }

  void _subtitleBlocListener(BuildContext context, SubtitleState state) {
    if (state is SubtitleInitialized) {
      context.read<SubtitleBloc>().add(LoadSubtitle());
    }
  }
}

class _TextContent extends StatelessWidget {
  const _TextContent({
    required this.textStyle,
    required this.text,
  });

  final TextStyle textStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: ViewKeys.subtitleTextContent,
      textAlign: TextAlign.center,
      style: textStyle,
    );
  }
}
