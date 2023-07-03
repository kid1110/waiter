import 'package:flutter/material.dart';
import 'package:tuihub_protos/librarian/sephirah/v1/tiphereth.pb.dart';
import 'package:waitress/common/base/base_rest_mixins.dart';

class MyAccountsCard extends StatefulWidget {
  const MyAccountsCard({super.key});

  @override
  State<StatefulWidget> createState() => _MyAccountsCardState();
}

class _MyAccountsCardState extends State<MyAccountsCard>
    with SingleRequestMixin<MyAccountsCard, ListLinkAccountsResponse> {
  @override
  void initState() {
    super.initState();
    loadMyProfile();
  }

  Widget _buildStatePage() {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (isSuccess) {
      return MyProfile(data: response.getData());
    }
    if (isError) {
      return Center(
        child: Text("加载失败: ${response.error}"),
      );
    }
    return const SizedBox();
  }

  void loadMyProfile() {
    doRequest(request: (client, option) {
      return client.listLinkAccounts(
        ListLinkAccountsRequest(),
        options: option,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: _buildStatePage(),
      ),
    );
  }
}

class MyProfile extends StatelessWidget {
  const MyProfile({
    super.key,
    required this.data,
  });

  final ListLinkAccountsResponse data;
  final accountPlatformCount = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final account in data.accounts)
            SizedBox(
              child: Material(
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                image: NetworkImage(
                                  account.avatarUrl,
                                ),
                                fit: BoxFit.cover),
                          ),
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account.id.id.toHexString(),
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 10,
                                    color: Theme.of(context).disabledColor),
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                account.name,
                                style: const TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                account.platform.toString(),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 10,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (data.accounts.length < accountPlatformCount)
            SizedBox(
              child: Material(
                borderRadius: BorderRadius.circular(8),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: TextButton(
                        onPressed: () {  },
                        child: const Text("添加绑定"),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}