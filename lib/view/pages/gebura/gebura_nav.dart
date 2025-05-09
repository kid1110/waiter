import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:universal_ui/universal_ui.dart';

import '../../../bloc/gebura/gebura_bloc.dart';
import '../../../bloc/main_bloc.dart';
import '../../../l10n/l10n.dart';
import '../../../model/gebura_model.dart';
import '../../../route.dart';
import '../../layout/overlapping_panels.dart';
import 'gebura_common.dart';

class GeburaNav extends StatelessWidget {
  const GeburaNav({
    super.key,
    required this.function,
    this.selectedItem,
  });

  final GeburaFunctions function;
  final String? selectedItem;

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    return BlocBuilder<MainBloc, MainState>(builder: (_, mainState) {
      return BlocBuilder<GeburaBloc, GeburaState>(
        buildWhen: (previous, current) {
          return previous.libraryListItems != current.libraryListItems;
        },
        builder: (context, state) {
          if (searchController.text == '') {
            searchController.text = state.librarySettings?.filter?.query ?? '';
          }
          return Column(
            children: [
              if (mainState.isNotLocal)
                UniversalListTile(
                  leading: Icon(UniversalIcon(context).shoppingCart),
                  onTap: () {
                    const GeburaStoreRoute().go(context);
                    OverlappingPanels.of(context)?.reveal(RevealSide.main);
                  },
                  title: Text(S.of(context).store),
                  selected: function == GeburaFunctions.store,
                ),
              UniversalListTile(
                leading: Icon(UniversalIcon(context).apps),
                onTap: () {
                  const GeburaLibraryRoute().go(context);
                  OverlappingPanels.of(context)?.reveal(RevealSide.main);
                },
                title: Text(S.of(context).library),
                selected:
                    function == GeburaFunctions.library && selectedItem == null,
              ),
              SpacingHelper.defaultDivider,
              if (UniversalUI.of(context).design == UIDesign.fluent)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.only(bottom: 4),
                  child: fluent.TextBox(
                    controller: searchController,
                    prefix: const UniversalIconButton(
                      icon: Icon(FluentIcons.filter_24_regular),
                    ),
                    suffix: state.librarySettings?.filter?.query?.isNotEmpty ??
                            false
                        ? UniversalIconButton(
                            icon: const Icon(FluentIcons.dismiss_24_regular),
                            onPressed: () {
                              context.read<GeburaBloc>().add(
                                  GeburaApplyLibraryFilterEvent(null,
                                      query: ''));
                              searchController.clear();
                            },
                          )
                        : null,
                    onChanged: (query) {
                      context.read<GeburaBloc>().add(
                          GeburaApplyLibraryFilterEvent(null, query: query));
                    },
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(UniversalIcon(context).filter),
                      suffixIcon:
                          state.librarySettings?.filter?.query?.isNotEmpty ??
                                  false
                              ? UniversalIconButton(
                                  icon: Icon(UniversalIcon(context).clear),
                                  onPressed: () {
                                    context.read<GeburaBloc>().add(
                                        GeburaApplyLibraryFilterEvent(null,
                                            query: ''));
                                    searchController.clear();
                                  },
                                )
                              : null,
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            UniversalUI.of(context).defaultBorderRadius,
                        borderSide: const BorderSide(
                          style: BorderStyle.none,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            UniversalUI.of(context).defaultBorderRadius,
                      ),
                    ),
                    onChanged: (query) {
                      context.read<GeburaBloc>().add(
                          GeburaApplyLibraryFilterEvent(null, query: query));
                    },
                  ),
                ),
              Expanded(
                child: DynMouseScroll(
                  builder: (context, controller, physics) {
                    return ListView(
                        controller: controller,
                        physics: physics,
                        children: [
                          if (state.libraryListItems.isNotEmpty)
                            for (final LibraryListItem item in state
                                .libraryListItems
                                .where((e) => !e.filtered))
                              Material(
                                  child: UniversalListTile(
                                // https://github.com/flutter/flutter/issues/86584
                                selected: item.uuid == selectedItem,
                                onTap: () {
                                  GeburaLibraryDetailRoute(item.uuid)
                                      .go(context);
                                  OverlappingPanels.of(context)
                                      ?.reveal(RevealSide.main);
                                },
                                leading: GeburaAppIconImage(
                                    path: item.iconImagePath),
                                title: AutoSizeText(
                                  item.name.isEmpty ? item.uuid : item.name,
                                  maxLines: 1,
                                  minFontSize: 12,
                                  maxFontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                              ))
                          else
                            (state is GeburaRefreshLibraryState)
                                ? (state.processing)
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : (state.failed)
                                        ? Center(
                                            child: Text(S
                                                .of(context)
                                                .loadFailed(state.msg ?? '')),
                                          )
                                        : Container()
                                : Container(),
                        ]);
                  },
                ),
              ),
              UniversalListTile(
                leading: Icon(UniversalIcon(context).libraryAdd),
                onTap: () {
                  const GeburaLibrarySettingsRoute().go(context);
                  OverlappingPanels.of(context)?.reveal(RevealSide.main);
                },
                title: Text(S.of(context).localLibraryManage),
                selected: function == GeburaFunctions.librarySettings &&
                    selectedItem == null,
              ),
            ],
          );
        },
      );
    });
  }
}
