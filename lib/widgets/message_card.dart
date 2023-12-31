// ignore_for_file: unused_element, use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/message.dart';

// for showing single message details
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _rightMessage() : _leftMessage());
  }

  // sender or another user message
  Widget _leftMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .02
                : mq.width * .02),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              border: Border.all(color: Colors.blueAccent),
              //making borders curved
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CupertinoActivityIndicator(radius: 20),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                          CupertinoIcons.photo_fill_on_rectangle_fill,
                          size: 70),
                    ),
                  ),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .02),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _rightMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: mq.width * .04),

            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(CupertinoIcons.checkmark_alt_circle_fill,
                  color: Colors.green, size: 15),

            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .02
                : mq.width * .02),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .02, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent,
              border: Border.all(color: Colors.deepPurpleAccent),
              //making borders curved
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: widget.message.type == Type.text
                ?
                //show text
                Text(
                    widget.message.msg,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium, //const TextStyle(fontSize: 15, color: Colors.black87),
                  )
                :
                //show image
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CachedNetworkImage(
                      imageUrl: widget.message.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CupertinoActivityIndicator(radius: 20),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                          CupertinoIcons.photo_fill_on_rectangle_fill,
                          size: 70),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ), // Adjust the blur intensity as needed
                child: Container(
                  color: Colors
                      .transparent, // You can set a background color here if needed
                ),
              ),
            ),
            CupertinoActionSheet(
              actions: [
                if (widget.message.type == Type.text)
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: widget.message.msg),
                      );
                      Navigator.pop(context);
                      Dialogs.showSnackbar(context, 'Text Copied!');
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.square_fill_on_square_fill,
                          color: Colors.blue,
                          size: 26,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Copy Text',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                if (widget.message.type != Type.text)
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      try {
                        log('Image Url: ${widget.message.msg}');
                        bool? success = await GallerySaver.saveImage(
                          widget.message.msg,
                          albumName: 'Messager',
                        );
                        Navigator.pop(context);
                        if (success != null && success) {
                          Dialogs.showSnackbar(
                              context, 'Image Successfully Saved!');
                        } else {
                          Dialogs.showSnackbar(context, 'Image Save Failed!');
                        }
                      } catch (e) {
                        log('ErrorWhileSavingImg: $e');
                      }
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.arrow_down_circle_fill,
                          color: Colors.blue,
                          size: 26,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Save Image',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                if (isMe)
                  CupertinoActionSheetAction(
                    onPressed: () {
                      Navigator.pop(context);
                      _showMessageUpdateDialog();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.pencil_circle_fill,
                          color: Colors.blue,
                          size: 26,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Edit Message',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ],
                    ),
                  ),
                if (isMe)
                  CupertinoActionSheetAction(
                    onPressed: () async {
                      await APIs.deleteMessage(widget.message);
                      Navigator.pop(context);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.delete_solid,
                          color: Colors.red,
                          size: 26,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Delete Message',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child:
                    const Text('Cancel', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        );
      },
    );
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text(
          "Edit Message",
          style: TextStyle(color: Colors.blueAccent),
        ),
        content: Column(
          children: [
            CupertinoTextField(
              controller: TextEditingController(text: updatedMsg),
              maxLines: null,
              onChanged: (value) => updatedMsg = value,
              decoration: BoxDecoration(
                border: Border.all(color: CupertinoColors.systemGrey),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ],
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: CupertinoColors.systemRed, fontSize: 16),
            ),
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
              APIs.updateMessage(widget.message, updatedMsg);
            },
            child: const Text(
              'Update',
              style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}
