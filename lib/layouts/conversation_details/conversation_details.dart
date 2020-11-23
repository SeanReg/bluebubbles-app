import 'dart:ui';

import 'package:bluebubbles/blocs/message_bloc.dart';
import 'package:bluebubbles/helpers/message_helper.dart';
import 'package:bluebubbles/layouts/conversation_details/attachment_details_card.dart';
import 'package:bluebubbles/layouts/conversation_details/contact_tile.dart';
import 'package:bluebubbles/layouts/conversation_view/conversation_view.dart';
import 'package:bluebubbles/layouts/conversation_view/new_chat_creator/adding_participant_popup.dart';
import 'package:bluebubbles/layouts/conversation_view/conversation_view_mixin.dart';
import 'package:bluebubbles/layouts/widgets/scroll_physics/custom_bouncing_scroll_physics.dart';
import 'package:bluebubbles/repository/models/attachment.dart';
import 'package:bluebubbles/repository/models/chat.dart';
import 'package:bluebubbles/socket_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationDetails extends StatefulWidget {
  final Chat chat;
  final MessageBloc messageBloc;

  ConversationDetails({Key key, this.chat, this.messageBloc}) : super(key: key);

  @override
  _ConversationDetailsState createState() => _ConversationDetailsState();
}

class _ConversationDetailsState extends State<ConversationDetails> {
  TextEditingController controller;
  bool readOnly = true;
  Chat chat;
  List<Attachment> attachmentsForChat = <Attachment>[];

  @override
  void initState() {
    super.initState();
    chat = widget.chat;
    controller = new TextEditingController(text: chat.displayName);
    Chat.getAttachments(chat).then((value) {
      attachmentsForChat = value;
      if (this.mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    readOnly = !((await chat.getParticipants()).participants.length > 1);
    debugPrint("updated readonly $readOnly");
    if (this.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        //   onWillPop: () async {
        //     if (chat.displayName != controller.text &&
        //         (await chat.getParticipants()).participants.length > 1) {
        //       Map<String, dynamic> params = new Map();
        //       params["identifier"] = chat.guid;
        //       params["newName"] = controller.text;
        //       SocketManager().sendMessage("rename-group", params, (data) async {
        //         if (data["status"] == 200) {
        //           Chat updatedChat = Chat.fromMap(data["data"]);
        //           await updatedChat.save();
        //           await ChatBloc().updateChatPosition(updatedChat);
        //         }
        //         debugPrint("renamed group chat " + data.toString());
        //       });
        //     }
        //     return true;
        //   },
        //   child:
        Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).accentColor.withAlpha(125),
        actionsForegroundColor: Theme.of(context).primaryColor,
        middle: Text(
          "Details",
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(
          parent: CustomBouncingScrollPhysics(),
        ),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              height: 100,
            ),
          ),
          SliverToBoxAdapter(
            child: readOnly
                ? Container()
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      cursorColor: Theme.of(context).primaryColor,
                      readOnly: true,
                      controller: controller,
                      style: Theme.of(context).textTheme.bodyText1,
                      autofocus: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: "NAME",
                        labelStyle:
                            TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ContactTile(
                  address: chat.participants[index].address,
                  handle: chat.participants[index],
                  chat: chat,
                  updateChat: (Chat newChat) {
                    chat = newChat;
                    if (this.mounted) setState(() {});
                  },
                  canBeRemoved: chat.participants.length > 1,
                );
              },
              childCount: chat.participants.length,
            ),
          ),
          SliverToBoxAdapter(
            child: chat.participants.length > 1
                ? InkWell(
                    onTap: () async {
                      Chat result = await Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => ConversationView(
                            isCreator: true,
                            type: ChatSelectorTypes.ONLY_CONTACTS,
                            onSelect: (List<UniqueContact> items) {
                              Navigator.of(context).pop();
                              if (items.length == 0) return;

                              for (UniqueContact contact in items) {
                                if (contact.isChat) return;
                              }
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AddingParticipantPopup(
                                  contacts: items,
                                  chat: chat,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                      if (result != null && this.mounted) {
                        chat = result;
                        setState(() {});
                      }
                    },
                    child: ListTile(
                      title: Text(
                        "Add Contact",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      leading: Icon(
                        Icons.add,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  )
                : Container(),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: 20),
          ),
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () async {
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) {
                //       return AlertDialog(
                //           backgroundColor: Theme.of(context).accentColor,
                //           title: new Text("Resync Chat",
                //               style: Theme.of(context).textTheme.headline1),
                //           content: new Text(
                //               "Are you sure you want to resync this chat? All messages/attachments will be removed and the last 25 messages will be pre-loaded.",
                //               style: Theme.of(context).textTheme.bodyText1),
                //           actions: <Widget>[
                //             new FlatButton(
                //               child: new Text("Cancel",
                //                   style: TextStyle(
                //                       color: Theme.of(context)
                //                           .textTheme
                //                           .subtitle1
                //                           .color)),
                //               onPressed: () {
                //                 Navigator.of(context).pop();
                //               },
                //             ),
                //             new FlatButton(
                //               child: new Text("Yes, I'm sure!",
                //                   style: TextStyle(
                //                       color: Theme.of(context)
                //                           .textTheme
                //                           .bodyText1
                //                           .color)),
                //               onPressed: () async {
                //                 // Remove the OG alert dialog
                //                 Navigator.of(context).pop();
                //                 // Show the next dialog
                //                 showDialog(
                //                   context: context,
                //                   barrierDismissible: false,
                //                   builder: (BuildContext context) {
                //                     // Resync the chat, then return to the first page
                //                     ActionHandler.resyncChat(
                //                             chat, widget.messageBloc)
                //                         .then((value) {
                //                       Navigator.popUntil(context, (route) => route.isFirst);
                //                     });

                //                     // Show a loading dialog
                //                     return AlertDialog(
                //                       backgroundColor:
                //                           Theme.of(context).accentColor,
                //                       title: new Text("Resyncing Chat...",
                //                           style: Theme.of(context)
                //                               .textTheme
                //                               .bodyText1),
                //                       content: Container(
                //                         alignment: Alignment.center,
                //                         height: 100,
                //                         width: 100,
                //                         child: new Container(
                //                           child: CircularProgressIndicator(
                //                               valueColor:
                //                                   new AlwaysStoppedAnimation<
                //                                           Color>(
                //                                       Theme.of(context)
                //                                           .textTheme
                //                                           .bodyText1
                //                                           .color)),
                //                         ),
                //                       ),
                //                     );
                //                   },
                //                 );
                //               },
                //             ),
                //           ]);
                //     });
                showDialog(
                  context: context,
                  builder: (context) => SyncDialog(
                    chat: chat,
                  ),
                );
              },
              child: ListTile(
                title: Text(
                  "Sync last 25 messages",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                leading: Icon(
                  Icons.replay,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).accentColor, width: 3),
                  ),
                  child: AttachmentDetailsCard(
                    attachment: attachmentsForChat[index],
                    allAttachments: attachmentsForChat.reversed.toList(),
                  ),
                );
              },
              childCount: attachmentsForChat.length,
            ),
          )
        ],
      ),
      // ),
    );
  }
}

class SyncDialog extends StatefulWidget {
  SyncDialog({Key key, this.chat}) : super(key: key);
  final Chat chat;

  @override
  _SyncDialogState createState() => _SyncDialogState();
}

class _SyncDialogState extends State<SyncDialog> {
  String errorCode;
  bool finished = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> params = Map();
    params["identifier"] = widget.chat.guid;
    params["withBlurhash"] = false;
    params["limit"] = 25;
    params["where"] = [
      {"statement": "message.service = 'iMessage'", "args": null}
    ];

    SocketManager().sendMessage("get-chat-messages", params, (data) async {
      if (data['status'] != 200) {
        onFinish(false);
        errorCode = data['error']['message'];
        return;
      }
      List messages = data["data"];
      await MessageHelper.bulkAddMessages(
          widget.chat, messages.reversed.toList(),
          notifyForNewMessage: false);
      onFinish();
    });
  }

  void onFinish([bool success = true]) {
    if (!this.mounted) return;
    if (success) Navigator.of(context).pop();
    if (!success) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(errorCode != null ? "Error!" : "Syncing messages..."),
      content: errorCode != null
          ? Text(errorCode)
          : Container(
              height: 5,
              child: Center(
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                ),
              ),
            ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "Ok",
            style: Theme.of(context).textTheme.bodyText1.apply(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        )
      ],
    );
  }
}
