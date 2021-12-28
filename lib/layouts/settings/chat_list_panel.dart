import 'package:bluebubbles/helpers/constants.dart';
import 'package:bluebubbles/helpers/navigator.dart';
import 'package:bluebubbles/helpers/themes.dart';
import 'package:bluebubbles/helpers/utils.dart';
import 'package:bluebubbles/layouts/settings/settings_widgets.dart';
import 'package:bluebubbles/managers/settings_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iosSubtitle =
        Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.grey, fontWeight: FontWeight.w300);
    final materialSubtitle = Theme.of(context)
        .textTheme
        .subtitle1
        ?.copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold);
    Color headerColor;
    Color tileColor;
    if ((Theme.of(context).colorScheme.secondary.computeLuminance() < Theme.of(context).backgroundColor.computeLuminance() ||
        SettingsManager().settings.skin.value == Skins.Material) && (SettingsManager().settings.skin.value != Skins.Samsung || isEqual(Theme.of(context), whiteLightTheme))) {
      headerColor = Theme.of(context).colorScheme.secondary;
      tileColor = Theme.of(context).backgroundColor;
    } else {
      headerColor = Theme.of(context).backgroundColor;
      tileColor = Theme.of(context).colorScheme.secondary;
    }
    if (SettingsManager().settings.skin.value == Skins.iOS && isEqual(Theme.of(context), oledDarkTheme)) {
      tileColor = headerColor;
    }

    return SettingsScaffold(
      title: "Chat List",
      initialHeader: "Indicators",
      iosSubtitle: iosSubtitle,
      materialSubtitle: materialSubtitle,
      tileColor: tileColor,
      headerColor: headerColor,
      bodySlivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              SettingsSection(
                backgroundColor: tileColor,
                children: [
                  Obx(() => SettingsSwitch(
                    onChanged: (bool val) {
                      SettingsManager().settings.showConnectionIndicator.value = val;
                      saveSettings();
                    },
                    initialVal: SettingsManager().settings.showConnectionIndicator.value,
                    title: "Show Connection Indicator",
                    subtitle: "Enables a connection status indicator at the top left",
                    backgroundColor: tileColor,
                  )),
                  Container(
                    color: tileColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65.0),
                      child: SettingsDivider(color: headerColor),
                    ),
                  ),
                  Obx(() => SettingsSwitch(
                    onChanged: (bool val) {
                      SettingsManager().settings.showSyncIndicator.value = val;
                      saveSettings();
                    },
                    initialVal: SettingsManager().settings.showSyncIndicator.value,
                    title: "Show Sync Indicator in Chat List",
                    subtitle: "Enables a small indicator at the top left to show when the app is syncing messages",
                    backgroundColor: tileColor,
                  )),
                  Container(
                    color: tileColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65.0),
                      child: SettingsDivider(color: headerColor),
                    ),
                  ),
                  Obx(() => SettingsSwitch(
                    onChanged: (bool val) {
                      SettingsManager().settings.colorblindMode.value = val;
                      saveSettings();
                    },
                    initialVal: SettingsManager().settings.colorblindMode.value,
                    title: "Colorblind Mode",
                    subtitle: "Replaces the colored connection indicator with icons to aid accessibility",
                    backgroundColor: tileColor,
                  )),
                ],
              ),
              SettingsHeader(
                  headerColor: headerColor,
                  tileColor: tileColor,
                  iosSubtitle: iosSubtitle,
                  materialSubtitle: materialSubtitle,
                  text: "Filtering"),
              SettingsSection(
                backgroundColor: tileColor,
                children: [
                  Obx(() => SettingsSwitch(
                    onChanged: (bool val) {
                      SettingsManager().settings.filteredChatList.value = val;
                      saveSettings();
                    },
                    initialVal: SettingsManager().settings.filteredChatList.value,
                    title: "Filtered Chat List",
                    subtitle:
                    "Filters the chat list based on parameters set in iMessage (usually this removes old, inactive chats)",
                    backgroundColor: tileColor,
                  )),
                  Container(
                    color: tileColor,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 65.0),
                      child: SettingsDivider(color: headerColor),
                    ),
                  ),
                  Obx(() => SettingsSwitch(
                    onChanged: (bool val) {
                      SettingsManager().settings.filterUnknownSenders.value = val;
                      saveSettings();
                    },
                    initialVal: SettingsManager().settings.filterUnknownSenders.value,
                    title: "Filter Unknown Senders",
                    subtitle:
                    "Turn off notifications for senders who aren't in your contacts and sort them into a separate chat list",
                    backgroundColor: tileColor,
                  )),
                ],
              ),
              SettingsHeader(
                  headerColor: headerColor,
                  tileColor: tileColor,
                  iosSubtitle: iosSubtitle,
                  materialSubtitle: materialSubtitle,
                  text: "Appearance"),
              SettingsSection(
                backgroundColor: tileColor,
                children: [
                  Obx(() {
                    if (SettingsManager().settings.skin.value != Skins.Samsung) {
                      return SettingsSwitch(
                        onChanged: (bool val) {
                          SettingsManager().settings.hideDividers.value = val;
                          saveSettings();
                        },
                        initialVal: SettingsManager().settings.hideDividers.value,
                        title: "Hide Dividers",
                        backgroundColor: tileColor,
                        subtitle: "Hides dividers between tiles",
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  Obx(() {
                    if (SettingsManager().settings.skin.value != Skins.Samsung) {
                      return Container(
                        color: tileColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 65.0),
                          child: SettingsDivider(color: headerColor),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  Obx(() => SettingsSwitch(
                    onChanged: (bool val) {
                      SettingsManager().settings.denseChatTiles.value = val;
                      saveSettings();
                    },
                    initialVal: SettingsManager().settings.denseChatTiles.value,
                    title: "Dense Conversation Tiles",
                    backgroundColor: tileColor,
                    subtitle: "Compresses chat tile size on the conversation list page",
                  )),
                  Obx(() {
                    if (SettingsManager().settings.skin.value == Skins.iOS) {
                      return Container(
                        color: tileColor,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 65.0),
                          child: SettingsDivider(color: headerColor),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  Obx(() {
                    if (SettingsManager().settings.skin.value == Skins.iOS) {
                      return SettingsSwitch(
                        onChanged: (bool val) {
                          SettingsManager().settings.reducedForehead.value = val;
                          saveSettings();
                        },
                        initialVal: SettingsManager().settings.reducedForehead.value,
                        title: "Reduced Forehead",
                        backgroundColor: tileColor,
                        subtitle: "Reduces the appbar size on conversation pages",
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  Obx(() {
                    if (SettingsManager().settings.skin.value == Skins.iOS) {
                      return SettingsTile(
                        title: "Max Pin Rows",
                        subtitle:
                        "The maximum row count of pins displayed when using the app in the portrait orientation",
                        backgroundColor: tileColor,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  Obx(() {
                    if (SettingsManager().settings.skin.value == Skins.iOS) {
                      return SettingsSlider(
                        min: 2,
                        max: 4,
                        divisions: 3,
                        update: (double val) {
                          SettingsManager().settings.pinRowsPortrait.value = val.toInt();
                          saveSettings();
                        },
                        startingVal: SettingsManager().settings.pinRowsPortrait.value.toDouble(),
                        text: "Maximum Pin Rows",
                        backgroundColor: tileColor,
                        formatValue: (val) =>
                        SettingsManager().settings.pinRowsPortrait.toString() +
                            " rows of " +
                            SettingsManager().settings.pinColumnsPortrait.toString(),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                  if (!kIsWeb)
                    Container(
                      color: tileColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 65.0),
                        child: SettingsDivider(color: headerColor),
                      ),
                    ),
                  // if (!kIsWeb)
                  //   SettingsTile(
                  //     title: "Pinned Order",
                  //     subtitle: "Set the order for your pinned chats",
                  //     backgroundColor: tileColor,
                  //     onTap: () {
                  //       CustomNavigator.pushSettings(
                  //         context,
                  //         PinnedOrderPanel(),
                  //       );
                  //     },
                  //     trailing: Icon(
                  //       SettingsManager().settings.skin.value == Skins.iOS ? CupertinoIcons.chevron_right : Icons.arrow_forward,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                ],
              ),
              if (!kIsWeb && !kIsDesktop)
                SettingsHeader(
                    headerColor: headerColor,
                    tileColor: tileColor,
                    iosSubtitle: iosSubtitle,
                    materialSubtitle: materialSubtitle,
                    text: "Swipe Actions"),
              if (!kIsWeb && !kIsDesktop)
                SettingsSection(
                  backgroundColor: tileColor,
                  children: [
                    Obx(() {
                      if (SettingsManager().settings.skin.value == Skins.Samsung ||
                          SettingsManager().settings.skin.value == Skins.Material) {
                        return SettingsSwitch(
                          onChanged: (bool val) {
                            SettingsManager().settings.swipableConversationTiles.value = val;
                            saveSettings();
                          },
                          initialVal: SettingsManager().settings.swipableConversationTiles.value,
                          title: "Swipe Actions for Conversation Tiles",
                          subtitle: "Enables swipe actions for conversation tiles when using Material theme",
                          backgroundColor: tileColor,
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                    if (SettingsManager().settings.skin.value == Skins.iOS)
                      SettingsTile(
                        backgroundColor: tileColor,
                        title: "Customize Swipe Actions",
                        subtitle: "Enable or disable specific swipe actions",
                      ),
                    Obx(() {
                      if (SettingsManager().settings.skin.value == Skins.iOS) {
                        return Container(
                          color: tileColor,
                          constraints: BoxConstraints(maxWidth: CustomNavigator.width(context)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Row(
                              children: [
                                Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text("Swipe Right"),
                                  ),
                                  Opacity(
                                    opacity: SettingsManager().settings.iosShowPin.value ? 1 : 0.7,
                                    child: Container(
                                      height: 60,
                                      width: CustomNavigator.width(context) / 5 - 8,
                                      color: Colors.yellow[800],
                                      child: IconButton(
                                        icon: Icon(CupertinoIcons.pin, color: Colors.white),
                                        onPressed: () async {
                                          SettingsManager().settings.iosShowPin.value =
                                          !SettingsManager().settings.iosShowPin.value;
                                          saveSettings();
                                        },
                                      ),
                                    ),
                                  ),
                                  CupertinoButton(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: SettingsManager().settings.iosShowPin.value
                                                ? Theme.of(context).primaryColor
                                                : tileColor,
                                            border: Border.all(
                                                color: SettingsManager().settings.iosShowPin.value
                                                    ? Theme.of(context).primaryColor
                                                    : CupertinoColors.systemGrey,
                                                style: BorderStyle.solid,
                                                width: 1),
                                            borderRadius: BorderRadius.all(Radius.circular(25))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Icon(CupertinoIcons.check_mark,
                                              size: 18,
                                              color: SettingsManager().settings.iosShowPin.value
                                                  ? CupertinoColors.white
                                                  : CupertinoColors.systemGrey),
                                        ),
                                      ),
                                      onPressed: () {
                                        SettingsManager().settings.iosShowPin.value =
                                        !SettingsManager().settings.iosShowPin.value;
                                        saveSettings();
                                      }),
                                ]),
                                Spacer(),
                                Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text("Swipe Left"),
                                  ),
                                  Row(children: [
                                    Column(
                                      children: [
                                        Opacity(
                                          opacity: SettingsManager().settings.iosShowAlert.value ? 1 : 0.7,
                                          child: Container(
                                            height: 60,
                                            color: Colors.purple[700],
                                            width: CustomNavigator.width(context) / 5 - 8,
                                            child: IconButton(
                                              icon: Icon(CupertinoIcons.bell_slash, color: Colors.white),
                                              onPressed: () async {
                                                SettingsManager().settings.iosShowAlert.value =
                                                !SettingsManager().settings.iosShowAlert.value;
                                                saveSettings();
                                              },
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: SettingsManager().settings.iosShowAlert.value
                                                      ? Theme.of(context).primaryColor
                                                      : tileColor,
                                                  border: Border.all(
                                                      color: SettingsManager().settings.iosShowAlert.value
                                                          ? Theme.of(context).primaryColor
                                                          : CupertinoColors.systemGrey,
                                                      style: BorderStyle.solid,
                                                      width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(25))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Icon(CupertinoIcons.check_mark,
                                                    size: 18,
                                                    color: SettingsManager().settings.iosShowAlert.value
                                                        ? CupertinoColors.white
                                                        : CupertinoColors.systemGrey),
                                              ),
                                            ),
                                            onPressed: () {
                                              SettingsManager().settings.iosShowAlert.value =
                                              !SettingsManager().settings.iosShowAlert.value;
                                              saveSettings();
                                            }),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Opacity(
                                          opacity: SettingsManager().settings.iosShowDelete.value ? 1 : 0.7,
                                          child: Container(
                                            height: 60,
                                            color: Colors.red,
                                            width: CustomNavigator.width(context) / 5 - 8,
                                            child: IconButton(
                                              icon: Icon(CupertinoIcons.trash, color: Colors.white),
                                              onPressed: () async {
                                                SettingsManager().settings.iosShowDelete.value =
                                                !SettingsManager().settings.iosShowDelete.value;
                                                saveSettings();
                                              },
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: SettingsManager().settings.iosShowDelete.value
                                                      ? Theme.of(context).primaryColor
                                                      : tileColor,
                                                  border: Border.all(
                                                      color: SettingsManager().settings.iosShowDelete.value
                                                          ? Theme.of(context).primaryColor
                                                          : CupertinoColors.systemGrey,
                                                      style: BorderStyle.solid,
                                                      width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(25))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Icon(CupertinoIcons.check_mark,
                                                    size: 18,
                                                    color: SettingsManager().settings.iosShowDelete.value
                                                        ? CupertinoColors.white
                                                        : CupertinoColors.systemGrey),
                                              ),
                                            ),
                                            onPressed: () {
                                              SettingsManager().settings.iosShowDelete.value =
                                              !SettingsManager().settings.iosShowDelete.value;
                                              saveSettings();
                                            }),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Opacity(
                                          opacity: SettingsManager().settings.iosShowMarkRead.value ? 1 : 0.7,
                                          child: Container(
                                            height: 60,
                                            color: Colors.blue,
                                            width: CustomNavigator.width(context) / 5 - 8,
                                            child: IconButton(
                                              icon: Icon(CupertinoIcons.person_crop_circle_badge_exclam, color: Colors.white),
                                              onPressed: () {
                                                SettingsManager().settings.iosShowMarkRead.value =
                                                !SettingsManager().settings.iosShowMarkRead.value;
                                                saveSettings();
                                                saveSettings();
                                              },
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: SettingsManager().settings.iosShowMarkRead.value
                                                      ? Theme.of(context).primaryColor
                                                      : tileColor,
                                                  border: Border.all(
                                                      color: SettingsManager().settings.iosShowMarkRead.value
                                                          ? Theme.of(context).primaryColor
                                                          : CupertinoColors.systemGrey,
                                                      style: BorderStyle.solid,
                                                      width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(25))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Icon(CupertinoIcons.check_mark,
                                                    size: 18,
                                                    color: SettingsManager().settings.iosShowMarkRead.value
                                                        ? CupertinoColors.white
                                                        : CupertinoColors.systemGrey),
                                              ),
                                            ),
                                            onPressed: () {
                                              SettingsManager().settings.iosShowMarkRead.value =
                                              !SettingsManager().settings.iosShowMarkRead.value;
                                              saveSettings();
                                            }),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Opacity(
                                          opacity: SettingsManager().settings.iosShowArchive.value ? 1 : 0.7,
                                          child: Container(
                                            height: 60,
                                            color: Colors.red,
                                            width: CustomNavigator.width(context) / 5 - 8,
                                            child: IconButton(
                                              icon: Icon(CupertinoIcons.tray_arrow_down, color: Colors.white),
                                              onPressed: () {
                                                SettingsManager().settings.iosShowArchive.value =
                                                !SettingsManager().settings.iosShowArchive.value;
                                                saveSettings();
                                              },
                                            ),
                                          ),
                                        ),
                                        CupertinoButton(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: SettingsManager().settings.iosShowArchive.value
                                                      ? Theme.of(context).primaryColor
                                                      : tileColor,
                                                  border: Border.all(
                                                      color: SettingsManager().settings.iosShowArchive.value
                                                          ? Theme.of(context).primaryColor
                                                          : CupertinoColors.systemGrey,
                                                      style: BorderStyle.solid,
                                                      width: 1),
                                                  borderRadius: BorderRadius.all(Radius.circular(25))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Icon(CupertinoIcons.check_mark,
                                                    size: 18,
                                                    color: SettingsManager().settings.iosShowArchive.value
                                                        ? CupertinoColors.white
                                                        : CupertinoColors.systemGrey),
                                              ),
                                            ),
                                            onPressed: () {
                                              SettingsManager().settings.iosShowArchive.value =
                                              !SettingsManager().settings.iosShowArchive.value;
                                              saveSettings();
                                            }),
                                      ],
                                    ),
                                  ]),
                                ]),
                              ],
                            ),
                          ),
                        );
                      } else if (SettingsManager().settings.swipableConversationTiles.value) {
                        return Container(
                          color: tileColor,
                          child: Column(
                            children: [
                              SettingsOptions<MaterialSwipeAction>(
                                initial: SettingsManager().settings.materialRightAction.value,
                                onChanged: (val) {
                                  if (val != null) {
                                    SettingsManager().settings.materialRightAction.value = val;
                                    saveSettings();
                                  }
                                },
                                options: MaterialSwipeAction.values,
                                textProcessing: (val) =>
                                val.toString().split(".")[1].replaceAll("_", " ").capitalizeFirst!,
                                title: "Swipe Right Action",
                                backgroundColor: tileColor,
                                secondaryColor: headerColor,
                              ),
                              SettingsOptions<MaterialSwipeAction>(
                                initial: SettingsManager().settings.materialLeftAction.value,
                                onChanged: (val) {
                                  if (val != null) {
                                    SettingsManager().settings.materialLeftAction.value = val;
                                    saveSettings();
                                  }
                                },
                                options: MaterialSwipeAction.values,
                                textProcessing: (val) =>
                                val.toString().split(".")[1].replaceAll("_", " ").capitalizeFirst!,
                                title: "Swipe Left Action",
                                backgroundColor: tileColor,
                                secondaryColor: headerColor,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                  ],
                ),
              SettingsHeader(
                  headerColor: headerColor,
                  tileColor: tileColor,
                  iosSubtitle: iosSubtitle,
                  materialSubtitle: materialSubtitle,
                  text: "Misc"),
              SettingsSection(
                backgroundColor: tileColor,
                children: [
                  Obx(() => SettingsSwitch(
                    onChanged: (bool val) {
                      SettingsManager().settings.moveChatCreatorToHeader.value = val;
                      saveSettings();
                    },
                    initialVal: SettingsManager().settings.moveChatCreatorToHeader.value,
                    title: "Move Chat Creator Button to Header",
                    subtitle: "Replaces the floating button at the bottom to a fixed button at the top",
                    backgroundColor: tileColor,
                  )),
                  if (!kIsWeb && !kIsDesktop)
                    Container(
                      color: tileColor,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 65.0),
                        child: SettingsDivider(color: headerColor),
                      ),
                    ),
                  if (!kIsWeb && !kIsDesktop)
                    Obx(() => SettingsSwitch(
                      onChanged: (bool val) {
                        SettingsManager().settings.cameraFAB.value = val;
                        saveSettings();
                      },
                      initialVal: SettingsManager().settings.cameraFAB.value,
                      title: SettingsManager().settings.skin.value == Skins.Material
                          ? "Long Press for Camera" : "Add Camera Button",
                      subtitle: SettingsManager().settings.skin.value == Skins.Material
                          ? "Long press the start chat button to easily send a picture to a chat"
                          : "Adds a dedicated camera button near the new chat creator button to easily send pictures",
                      backgroundColor: tileColor,
                    )),
                ],
              ),
            ],
          ),
        ),
      ]
    );
  }

  void saveSettings() {
    SettingsManager().saveSettings(SettingsManager().settings);
  }
}
