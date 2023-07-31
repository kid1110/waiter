import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/gebura.pb.dart';
import 'package:waitress/bloc/api_request/api_request_bloc.dart';
import 'package:waitress/common/api/api_mixins.dart';
import 'package:waitress/view/widgets/rail_tile.dart';

class GeburaLibraryListPage extends StatefulWidget {
  const GeburaLibraryListPage({super.key, required this.selectedAppID});

  final String selectedAppID;

  @override
  State<GeburaLibraryListPage> createState() => _GeburaLibraryListPageState();
}

class _GeburaLibraryListPageState extends State<GeburaLibraryListPage>
    with SingleRequestMixin<GeburaLibraryListPage, GetPurchasedAppsResponse> {
  @override
  void initState() {
    super.initState();
    loadLibrary();
  }

  Widget _buildStatePage() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (isSuccess) {
      return response.getData().apps.isEmpty
          ? const Center(
              child: Text(""),
            )
          : LibraryList(
              data: response.getData(),
              selectedAppID: widget.selectedAppID,
            );
    }
    if (isError) {
      return Center(
        child: Text("加载失败: ${response.error}"),
      );
    }
    return const SizedBox();
  }

  void loadLibrary() {
    doRequest(request: (client, option) {
      return client.getPurchasedApps(
        GetPurchasedAppsRequest(),
        options: option,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApiRequestBloc, ApiRequestState>(
      listener: (context, state) {
        if (state is GeburaRefreshLibrary) {
          loadLibrary();
        }
      },
      builder: (context, state) {
        return _buildStatePage();
      },
    );
  }
}

class LibraryList extends StatelessWidget {
  const LibraryList({
    super.key,
    required this.data,
    required this.selectedAppID,
  });

  final GetPurchasedAppsResponse data;
  final String selectedAppID;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final app in data.apps)
            RailTile(
              selected: app.id.id.toString() == selectedAppID,
              onTap: () {
                GoRouter.of(context).go("/app/Gebura/library?id=${app.id.id}");
              },
              leading: Container(
                decoration: app.iconImageUrl.isEmpty
                    ? BoxDecoration()
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: NetworkImage(
                            app.iconImageUrl,
                          ),
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                height: 24,
                width: 24,
              ),
              title:
                  Text(app.name.isEmpty ? app.id.id.toHexString() : app.name),
            ),
        ],
      ),
    );
  }
}