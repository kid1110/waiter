import 'package:flutter/material.dart';

final class SpacingHelper {
  static BorderRadius defaultBorderRadius = BorderRadius.circular(8);
  static Widget defaultDivider = _DefaultDivider();

  static List<Widget> listSpacing({
    required Iterable<Widget> children,
    double height = 0,
    double width = 0,
  }) =>
      children
          .expand((item) sync* {
            yield SizedBox(height: height, width: width);
            yield item;
          })
          .skip(1)
          .toList();
}

class _DefaultDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 10,
      indent: 20,
      endIndent: 20,
      thickness: 2,
      color: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.outline
          : Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
