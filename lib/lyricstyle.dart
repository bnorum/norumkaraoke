import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/lyric_ui.dart';


class norumLyricUI extends LyricUI {
  double defaultSize;
  double defaultExtSize;
  double otherMainSize;
  double bias;
  double lineGap;
  double inlineGap;
  LyricAlign lyricAlign;
  LyricBaseLine lyricBaseLine;
  bool highlight;
  HighlightDirection highlightDirection;

  norumLyricUI(
      { this.defaultSize = 20,
      this.defaultExtSize = 20,
      this.otherMainSize = 20,
      this.bias = 0.8,
      this.lineGap = 25,
      this.inlineGap = 25,
      this.lyricAlign = LyricAlign.CENTER,
      this.lyricBaseLine = LyricBaseLine.CENTER,
      this.highlight = true,
      this.highlightDirection = HighlightDirection.LTR});

  @override
  TextStyle getPlayingExtTextStyle() =>
      TextStyle(color: Colors.grey[300], fontSize: defaultExtSize, fontFamily: 'consolas');

  @override
  TextStyle getOtherExtTextStyle() => TextStyle(
        color: Colors.grey[300],
        fontSize: defaultExtSize, fontFamily: 'consolas'
      );

  @override
  TextStyle getOtherMainTextStyle() =>
      TextStyle(color: Colors.grey[200], fontSize: otherMainSize, fontFamily: 'consolas');

  @override
  TextStyle getPlayingMainTextStyle() => TextStyle(
        color: Colors.white,
        fontSize: defaultSize,
        fontFamily: 'consolas'
      );

  @override
  double getInlineSpace() => inlineGap;

  @override
  double getLineSpace() => lineGap;

  @override
  double getPlayingLineBias() => bias;

  @override
  LyricAlign getLyricHorizontalAlign() => lyricAlign;

  @override
  LyricBaseLine getBiasBaseLine() => lyricBaseLine;

  @override
  bool enableHighlight() => highlight;

  @override
  HighlightDirection getHighlightDirection() => highlightDirection;
}

