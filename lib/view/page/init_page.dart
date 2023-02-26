import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waitress/bloc/app_setting/app_setting_bloc.dart';
import 'package:waitress/core/const/color.dart';
import 'package:waitress/view/page/frame_page.dart';
import 'package:waitress/view/widget/title_bar.dart';

class InitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppSettingBloc, AppSettingState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is UserLoginDone) {
          return FramePage();
        }
        return Scaffold(
          body: Column(children: [
            const TitleBar(),
            Expanded(
              child: Scaffold(
                body: Center(
                  child: Container(
                    width: 540,
                    height: 320,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppBackgroudColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: state is ServerConnectDone
                        ? LoginWidget()
                        : ConnectWidget(),
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}

class ConnectWidget extends StatefulWidget {
  @override
  State<ConnectWidget> createState() => _ConnectWidgetState();
}

class _ConnectWidgetState extends State<ConnectWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool submitUrl() {
    RegExp exp = RegExp(
      r'[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
    );
    final match = exp.hasMatch(_controller.text);
    if (!match) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppBackgroudColor,
          content: Text(
            "链接格式错误, 请修改后重试",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      context.read<AppSettingBloc>().add(
            ConnectToServerEvent(_controller.text),
          );
    }
    return match;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppSettingBloc, AppSettingState>(
      listener: (context, state) {
        if (state is ServerConnectFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppBackgroudColor,
              content: Text(
                "无法连接到服务器,${state.message}",
                style: const TextStyle(color: Colors.white),
              ),
              action: SnackBarAction(
                label: "重试",
                onPressed: () {
                  submitUrl();
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "🎉欢迎!",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: '服务器链接地址',
                hintText: 'http:// | https://',
              ),
              controller: _controller,
              onSubmitted: (value) {
                submitUrl();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                submitUrl();
              },
              style: const ButtonStyle(
                fixedSize: MaterialStatePropertyAll(
                  Size(476, 48),
                ),
                elevation: MaterialStatePropertyAll(0),
                backgroundColor:
                    MaterialStatePropertyAll(AppDefaultAccentColor),
              ),
              child: state is ServerConnectLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      "连接服务器",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class LoginWidget extends StatefulWidget {
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submitUrl() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppBackgroudColor,
          content: Text(
            "用户名或密码为空, 请修改后重试",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else {
      context.read<AppSettingBloc>().add(
            UserLoginEvent(username, password),
          );
    }
  }

  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppSettingBloc, AppSettingState>(
      listener: (context, state) {
        if (state is UserLoginFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppBackgroudColor,
              content: Text(
                "登录失败,${state.message}",
                style: const TextStyle(color: Colors.white),
              ),
              action: SnackBarAction(
                label: "重试",
                onPressed: () {
                  submitUrl();
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  "🎉欢迎!",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: '用户名',
              ),
              controller: _usernameController,
              onSubmitted: (value) {
                submitUrl();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              obscureText: hidePassword,
              decoration: InputDecoration(
                labelText: '密码',
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: hidePassword
                      ? const Icon(Icons.visibility)
                      : const Icon(Icons.visibility_off),
                ),
              ),
              controller: _passwordController,
              onSubmitted: (value) {
                submitUrl();
              },
              obscuringCharacter: "*",
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                submitUrl();
              },
              style: const ButtonStyle(
                fixedSize: MaterialStatePropertyAll(
                  Size(476, 48),
                ),
                elevation: MaterialStatePropertyAll(0),
                backgroundColor:
                    MaterialStatePropertyAll(AppDefaultAccentColor),
              ),
              child: state is UserLoginLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      "登录",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
