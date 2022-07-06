import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:global_repository/global_repository.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:speed_share/app/controller/controller.dart';
import 'package:speed_share/config/config.dart';
import 'package:speed_share/generated/l10n.dart';
import 'package:speed_share/themes/theme.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../widget/xliv-switch.dart';
import 'dialog/select_language.dart';

// 设置页面
class SettingPage extends StatefulWidget {
  const SettingPage({Key key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SettingController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    TextStyle title = TextStyle(
      color: Theme.of(context).primaryColor,
      fontSize: 16.w,
    );
    final S s = S.of(context);
    AppBar appBar;
    if (ResponsiveWrapper.of(context).isMobile) {
      appBar = AppBar(
        systemOverlayStyle: OverlayStyle.dark,
        title: const Text('设置'),
      );
    }
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        left: false,
        child: GetBuilder<SettingController>(builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.w),
                  child: Text(
                    s.common,
                    style: title,
                  ),
                ),
                GetBuilder<SettingController>(builder: (_) {
                  return SettingItem(
                    onTap: () async {
                      const confirmButtonText = 'Choose';
                      final path = await getDirectoryPath(
                        confirmButtonText: confirmButtonText,
                      );
                      Log.e('path:$path');
                      if (path != null) {
                        controller.switchDownLoadPath(path);
                      }
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          s.downlaodPath,
                          style: TextStyle(
                            fontSize: 18.w,
                          ),
                        ),
                        Text(
                          controller.savePath,
                          style: TextStyle(
                            fontSize: 16.w,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .color
                                .withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SettingItem(
                  onTap: () {
                    Get.dialog(const SelectLang());
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        s.lang,
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Text(
                        controller.currentLocale.toLanguageTag(),
                        style: TextStyle(
                          fontSize: 16.w,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () {
                    controller.enableAutoChange(!controller.enableAutoDownload);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.autoDownload,
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.enableAutoDownload,
                        onChanged: controller.enableAutoChange,
                      ),
                    ],
                  ),
                ),

                SettingItem(
                  onTap: () {
                    controller.clipChange(!controller.clipboardShare);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.clipboardshare,
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.clipboardShare,
                        onChanged: controller.clipChange,
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () {
                    controller.vibrateChange(!controller.vibrate);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.messageNote,
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      AquaSwitch(
                        value: controller.vibrate,
                        onChanged: controller.vibrateChange,
                      ),
                    ],
                  ),
                ),
                // Text('隐私和安全'),
                // Text('消息和通知'),
                // Text('快捷键'),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.w),
                  child: Text(
                    s.aboutSpeedShare,
                    style: title,
                  ),
                ),
                SettingItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.currenVersion,
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Text(
                        Config.versionName,
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () async {
                    String url =
                        'https://github.com/nightmare-space/speed_share';
                    await canLaunchUrlString(url)
                        ? await launchUrlString(url)
                        : throw 'Could not launch $url';
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.openSource,
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  onTap: () async {
                    String url =
                        'http://nightmare.fun/YanTool/resources/SpeedShare/?C=N;O=A';
                    await canLaunchUrlString(url)
                        ? await launchUrlString(url)
                        : throw 'Could not launch $url';
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            s.otherVersion,
                            style: TextStyle(
                              fontSize: 18.w,
                            ),
                          ),
                          Text(
                            S.of(context).downloadTip,
                            style: TextStyle(
                              fontSize: 14.w,
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .color
                                  .withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.w,
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.developer,
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Text(
                        '梦魇兽',
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                SettingItem(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.ui,
                        style: TextStyle(
                          fontSize: 18.w,
                        ),
                      ),
                      Text(
                        '柚凛',
                        style: TextStyle(
                          fontSize: 18.w,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .color
                              .withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  const SettingItem({
    Key key,
    this.child,
    this.onTap,
  }) : super(key: key);
  final Widget child;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: SizedBox(
          height: 56.w,
          child: Align(
            alignment: Alignment.centerLeft,
            child: child,
          ),
        ),
      ),
    );
  }
}

class AquaSwitch extends StatelessWidget {
  final bool value;

  final ValueChanged<bool> onChanged;

  final Color activeColor;

  final Color unActiveColor;

  final Color thumbColor;

  const AquaSwitch({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.activeColor,
    this.unActiveColor,
    this.thumbColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.78,
      child: XlivSwitch(
        unActiveColor: unActiveColor ?? Theme.of(context).colorScheme.surface4,
        activeColor: Theme.of(context).primaryColor ?? activeColor,
        thumbColor: thumbColor,
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}