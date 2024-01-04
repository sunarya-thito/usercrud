import 'package:flutter/material.dart';

import 'data_widget.dart';

class StandardPage extends StatefulWidget {
  final bool scrollable;
  final Widget Function(BuildContext context) builder;
  const StandardPage({Key? key, required this.builder, this.scrollable = true})
      : super(key: key);

  @override
  _StandardPageState createState() => _StandardPageState();
}

class _StandardPageState extends State<StandardPage> {
  static List<double> containerBreakPoints = [
    540,
    720,
    960,
    1140,
    1320,
  ];
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var dataWidget = DataWidget(
      value: _scrollController,
      child: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        double maxWidth = width;
        for (int i = 0; i < containerBreakPoints.length - 1; i++) {
          if (width >= containerBreakPoints[i + 1]) {
            maxWidth = containerBreakPoints[i];
          }
        }
        return Material(
          child: Center(
            child: SizedBox(width: maxWidth, child: widget.builder(context)),
          ),
        );
      }),
    );
    if (!widget.scrollable) {
      return dataWidget;
    }
    return Scrollbar(
      thickness: 10,
      trackVisibility: true,
      thumbVisibility: true,
      controller: _scrollController,
      child: dataWidget,
    );
  }
}
