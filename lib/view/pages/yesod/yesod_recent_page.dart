import 'dart:async';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:smooth_scroll_multiplatform/smooth_scroll_multiplatform.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/yesod.pb.dart';
import 'package:tuihub_protos/librarian/v1/common.pb.dart';

import '../../../common/api/api_helper.dart';
import '../../../repo/yesod/yesod_repo.dart';
import '../../widgets/bootstrap/layout.dart';
import 'yesod_detail_page.dart';
import 'yesod_preview_card.dart';

class YesodRecentPage extends StatefulWidget {
  const YesodRecentPage({super.key});

  @override
  State<StatefulWidget> createState() => _YesodRecentPageState();
}

class _YesodRecentPageState extends State<YesodRecentPage> {
  FeedItem? selectedItem;

  Future<void> setSelectedItem(InternalID id) async {
    final result = await GetIt.I<YesodRepo>().getFeedItem(id);
    setState(() {
      selectedItem = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YesodRecentList(
        selectCallback: setSelectedItem,
      ),
    );
  }
}

class YesodRecentList extends StatefulWidget {
  const YesodRecentList({super.key, required this.selectCallback});

  final Future<void> Function(InternalID) selectCallback;

  @override
  State<YesodRecentList> createState() => _YesodRecentListState();
}

class _YesodRecentListState extends State<YesodRecentList> {
  Map<int, List<FeedItemDigest>> items = {};
  List<FeedItemDigest> flattenedItems = [];
  int lastPageNum = 0;
  bool pageEnd = false;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    unawaited(loadData(lastPageNum));
  }

  Future<void> loadData(int pageNum) async {
    try {
      final response = await GetIt.I<ApiHelper>().doRequest(
        (client, option) {
          return client.listFeedItems(
            ListFeedItemsRequest(
              paging: PagingRequest(
                pageSize: pageSize,
                pageNum: pageNum + 1,
              ),
            ),
            options: option,
          );
        },
      );
      items[pageNum] = response.getData().items;
      debugPrint(items[pageNum]!.length.toString());
      List<FeedItemDigest> newItemList = [];
      for (var i = 0; i <= pageNum; i++) {
        if (items[i] != null) {
          newItemList += items[i]!;
        }
      }
      debugPrint(newItemList.length.toString());
      setState(() {
        flattenedItems = newItemList;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (lastPageNum >= 0) {
      return BootstrapContainer(
        children: [
          const BootstrapColumn(xs: 1, xl: 2, child: SizedBox()),
          Expanded(
            child: BootstrapColumn(
              xs: 10,
              xl: 8,
              child: DynMouseScroll(
                builder: (context, controller, physics) {
                  controller.addListener(() {
                    if (controller.position.pixels ==
                        controller.position.maxScrollExtent) {
                      if (items[lastPageNum] != null &&
                          items[lastPageNum]!.isNotEmpty) {
                        setState(() {
                          lastPageNum++;
                        });
                      }
                      if (items[lastPageNum] == null) {
                        unawaited(loadData(lastPageNum));
                      } else {
                        setState(() {
                          pageEnd = true;
                        });
                      }
                    }
                  });

                  return ListView.builder(
                    controller: controller,
                    physics: physics,
                    itemCount: flattenedItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index < flattenedItems.length) {
                        final item = flattenedItems[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: OpenContainer(
                            openBuilder: (context, closedContainer) {
                              return Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: YesodDetailPage(
                                  itemId: item.itemId,
                                  controller: ScrollController(),
                                ),
                              );
                            },
                            openColor: theme.colorScheme.primary,
                            closedShape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            closedElevation: 0,
                            closedColor: theme.cardColor,
                            closedBuilder: (context, openContainer) {
                              return YesodPreviewCard(
                                name:
                                    '${item.feedConfigName} ${item.publishedParsedTime.toDateTime().toIso8601String()}',
                                title: item.title,
                                callback: openContainer,
                                iconUrl: item.feedAvatarUrl,
                                images: item.imageUrls,
                                description: item.shortDescription,
                              );
                            },
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: Text('加载中'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
          const BootstrapColumn(xs: 1, xl: 2, child: SizedBox()),
        ],
      );
    }
    return const SizedBox();
  }
}