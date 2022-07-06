import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide ScreenType;
import 'package:global_repository/global_repository.dart';
import 'package:path/path.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/chat_controller.dart';
import 'package:speed_share/app/controller/file_controller.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/modules/file/file_page.dart';
import 'package:speed_share/modules/widget/header.dart';
import 'package:speed_share/modules/widget/icon.dart';
import 'package:speed_share/modules/preview/image_preview.dart';
import 'package:speed_share/modules/share_chat_window.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
    this.onMessageWindowTap,
    this.onJoinRoom,
  }) : super(key: key);
  final void Function() onMessageWindowTap;
  final void Function(String address) onJoinRoom;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChatController chatController = Get.put(ChatController());
  FileController fileController = Get.find();
  bool serverOpend = true;
  // ChatController controller = Get.find();
  bool dropping = false;

  @override
  void initState() {
    super.initState();
    request();
    handleSendFile();
  }

  Future<void> request() async {
    if (GetPlatform.isAndroid) {
      PermissionUtil.requestStorage();
    }
  }

  // 处理其他软件过来的分享
  Future<void> handleSendFile() async {
    if (GetPlatform.isAndroid) {
      MethodChannel channel = const MethodChannel('send_channel');
      channel.setMethodCallHandler((call) async {
        if (call.method == 'send_file') {
          // File file = File.fromUri(Uri.parse(call.arguments));
          // print(file.path);
          Log.d('call -> ${call.arguments}');
          String realPath = call.arguments.toString().replaceAll('file://', '');
          realPath = realPath.replaceAll(
            'content://com.miui.home.fileprovider/data_app',
            '/data/app',
          );
          realPath = realPath.replaceAll(
            'content://com.nightmare.appmanager.fileprovider/root',
            '',
          );
          Log.d('send_file response realPath => $realPath');
          ChatController controller = Get.find();
          controller.sendFileFromPath(realPath);
        }
      });
    }
  }

  double size = 100;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: OverlayStyle.dark,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const Header(),
                SizedBox(height: 12.w),
                SizedBox(height: 4.w),
                chatRoom(context),
                SizedBox(height: 10.w),
                recentFile(context),
                SizedBox(height: 10.w),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.w,
                    horizontal: 12.w,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).recentImg,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                        SizedBox(height: 4.w),
                        Container(
                          color: const Color(0xffE0C4C4).withOpacity(0.2),
                          height: 1,
                        ),
                        SizedBox(height: 4.w),
                        GetBuilder<FileController>(builder: (context) {
                          File file = fileController.getRecentImage();

                          if (file == null) {
                            return Center(
                              child: Text(
                                '空',
                                style: TextStyle(
                                  fontSize: 16.w,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }
                          String unique = shortHash(() {});
                          return GestureWithScale(
                            onTap: () {
                              Get.to(
                                () => PreviewImage(
                                  path: file.path,
                                  tag: unique,
                                ),
                              );
                            },
                            child: Center(
                              child: Hero(
                                tag: unique,
                                child: Material(
                                  clipBehavior: Clip.antiAlias,
                                  borderRadius: BorderRadius.circular(12.w),
                                  child: Image.file(
                                    file,
                                    width: double.infinity,
                                    height: 160.w,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.w),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CardWrapper recentFile(BuildContext context) {
    return CardWrapper(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).recentFile,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          SizedBox(height: 4.w),
          Container(
            color: const Color(0xffE0C4C4).withOpacity(0.2),
            height: 1,
          ),
          SizedBox(height: 4.w),
          Expanded(
            child: GetBuilder<FileController>(
              builder: (ctl) {
                List<Widget> children = [];
                for (FileSystemEntity file in ctl.getRecent()) {
                  children.add(
                    SizedBox(
                      width: 60.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getIconByExt(file.path),
                          SizedBox(height: 8.w),
                          SizedBox(
                            height: 20.w,
                            child: Text(
                              basename(file.path),
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 8.w,
                                color: Colors.black,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                  children.add(
                    SizedBox(
                      width: 4.w,
                    ),
                  );
                }
                if (children.isEmpty) {
                  return Center(
                    child: Text(
                      '空',
                      style: TextStyle(
                        fontSize: 16.w,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget chatRoom(BuildContext context) {
    return GestureWithScale(
      onTap: () {
        if (ResponsiveWrapper.of(context).isDesktop) {
          widget.onMessageWindowTap?.call();
          return;
        }
        Get.put(ChatController());
        Get.to(() => const ShareChatV2());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(12.w),
        child: GetBuilder<ChatController>(builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).chatWindow,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              SizedBox(height: 4.w),
              Container(
                color: const Color(0xffE0C4C4).withOpacity(0.2),
                height: 1,
              ),
              SizedBox(height: 4.w),
              Builder(builder: (context) {
                // Log.i(chatController.children..last);
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 240.w,
                  width: double.infinity,
                  child: Builder(builder: (context) {
                    if (chatController.children.isEmpty) {
                      return Center(
                        child: Text(
                          '当前没有任何消息，点击进入到消息列表',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      // controller: chatController.scrollController,
                      itemCount: chatController.children.length,
                      itemBuilder: (c, i) {
                        return chatController.children[i];
                      },
                    );
                  }),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}