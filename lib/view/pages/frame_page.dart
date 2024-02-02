import 'package:flutter/material.dart';

import '../../consts.dart';
import '../../route.dart';
import '../layout/bootstrap_breakpoints.dart';
import '../layout/overlapping_panels.dart';
import '../specialized/nav_rail.dart';
import 'server_select_overlay.dart';

class FramePage extends StatefulWidget {
  const FramePage({
    super.key,
    required this.selectedNav,
    required this.leftPart,
    this.leftPartWidth,
    this.middlePart,
    this.rightPart,
    this.rightPartWidth,
    this.gestureRight = true,
  });

  final ModuleName selectedNav;
  final Widget leftPart;
  final double? leftPartWidth;
  final Widget? middlePart;
  final Widget? rightPart;
  final double? rightPartWidth;
  final bool gestureRight;

  static FramePageState? of(BuildContext context) {
    return context.findAncestorStateOfType<FramePageState>();
  }

  @override
  State<StatefulWidget> createState() => FramePageState();
}

class FramePageState extends State<FramePage> {
  void openDrawer() {
    _frameScaffold.currentState?.openEndDrawer();
  }

  final GlobalKey<ScaffoldState> _frameScaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const double restWidth = 40;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.biggest.width;

        Widget content = widget.middlePart != null
            ? Row(
                children: [
                  _Nav(selectedNav: widget.selectedNav),
                  SizedBox(
                    width: widget.leftPartWidth != null
                        ? widget.leftPartWidth! - 64
                        : 256,
                    child: widget.leftPart,
                  ),
                  Expanded(child: widget.middlePart!),
                ],
              )
            : Row(
                children: [
                  _Nav(selectedNav: widget.selectedNav),
                  Expanded(child: widget.leftPart),
                ],
              );

        if (width <= BootstrapBreakpoints.md) {
          content = widget.middlePart != null
              ? OverlappingPanels(
                  restWidth: restWidth,
                  gestureRight: widget.gestureRight,
                  left: Row(
                    children: [
                      _Nav(selectedNav: widget.selectedNav),
                      SizedBox(
                        width: width - 64 - restWidth,
                        child: widget.leftPart,
                      ),
                    ],
                  ),
                  main: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: widget.middlePart,
                  ),
                  right: widget.rightPart != null
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: width - 8 - restWidth,
                            child: widget.rightPart,
                          ),
                        )
                      : null,
                )
              : OverlappingPanels(
                  gestureRight: widget.gestureRight,
                  main: Row(
                    children: [
                      _Nav(selectedNav: widget.selectedNav),
                      SizedBox(
                        width: width - 64,
                        child: widget.leftPart,
                      ),
                    ],
                  ),
                  right: widget.rightPart != null
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: width - 8 - restWidth,
                            child: widget.rightPart,
                          ),
                        )
                      : null,
                );
        }

        return Scaffold(
          key: _frameScaffold,
          body: content,
          endDrawer: width > BootstrapBreakpoints.md && widget.rightPart != null
              ? Drawer(
                  width: widget.rightPartWidth ?? 512,
                  child: SafeArea(
                    maintainBottomViewPadding: true,
                    child: widget.rightPart!,
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _Nav extends StatelessWidget {
  const _Nav({required this.selectedNav});

  final ModuleName selectedNav;

  @override
  Widget build(BuildContext context) {
    return NavRail(
      leading: [
        IconMenuItem(
          icon: Icons.account_circle_sharp,
          selected: ModuleName.tiphereth == selectedNav,
          onPressed: () {
            ServerSelectOverlay.of(context)?.minimize();
            AppRoutes.tiphereth.go(context);
          },
        ),
      ],
      body: [
        for (final module in moduleList)
          IconMenuItem(
            icon: module.icon,
            selected: module.name == selectedNav,
            onPressed: () {
              ServerSelectOverlay.of(context)?.hide();
              AppRoutes.module(module.name).go(context);
            },
          ),
      ],
      trailing: [
        IconMenuItem(
          icon: Icons.settings,
          selected: ModuleName.settings == selectedNav,
          onPressed: () {
            ServerSelectOverlay.of(context)?.hide();
            AppRoutes.settings.go(context);
          },
        ),
      ],
    );
  }
}
