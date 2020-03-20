import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/loading.dart';
import 'package:flutter_downloader_example/myButton.dart';
import 'package:flutter_downloader_example/post.dart';
import 'package:flutter_downloader_example/screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'logic.dart';

class Download extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Logic logic = Provider.of(context, listen: false);
    var size = MediaQuery.of(context).size;
    logic.screen = Screen(size: size);
    var screen = logic.screen;
    var height = screen.height;
    var width = screen.width;
    var aspectRatio = screen.aspectRatio;

    return Consumer<Logic>(
      builder: (BuildContext context, Logic logic, Widget child) =>
          ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: ListView(
                padding: EdgeInsets.only(
                    bottom: screen.convert(50, height),
                    top: screen.convert(30, height)),
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screen.convert(20, width)),
                        child: SlideTransition(
                          position: logic.errorTextFieldAnim,
                          child: Form(
                            key: logic.textFieldKey,
                            child: Stack(
                              children: <Widget>[
                                TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                  controller: logic.controller,
                                  validator: (text) =>
                                      logic.textFieldValidator(context, text),
                                  decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal:
                                            screen.convert(20, screen.width),
                                      ),
                                      hintStyle: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          color: Colors.black.withOpacity(0.2)),
                                      helperText: '',
                                      hintText: 'instagram.com/dummy/dummy',
                                      errorStyle: TextStyle(
                                          fontWeight: FontWeight.w700),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: screen.convert(1, width),
                                          color: Colors.red,
                                        ),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.link,
                                        color: Colors.purple,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                          width: screen.convert(1.8, width),
                                          color: Colors.purple,
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.purple,
                                            width: screen.convert(1, width)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        borderSide: BorderSide(
                                            color: Colors.purple,
                                            width: screen.convert(1, width)),
                                      ),
                                      labelStyle: GoogleFonts.cairo(
                                          color: Colors.green),
                                      labelText: 'الصق الرابط هنا'),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment(-0.95, -0.43),
                                    child: InkWell(
                                      onTap: () {
                                        print('!!');
                                        logic.clear();
                                      },
                                      child: Container(
                                        child: Center(
                                          child: Icon(
                                            Icons.clear,
                                            size:
                                                screen.convert(15, aspectRatio),
                                          ),
                                        ),
                                        width: screen.convert(25, width),
                                        height: screen.convert(25, width),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(bottom: screen.convert(50, height)),
                        child: ButtonTheme(
                          height: screen.convert(60, height),
                          minWidth: screen.convert(150, width),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              MyButton('تأكيد', Colors.green, () {
                                logic.confirm(context);
                              }),
                              MyButton('لصق', Colors.purple, () {
                                logic.pasteUrl(context);
                              }),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        height: screen.convert(10, height),
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ],
                  ),
                  for (int i = 0; i < logic.posts.length; i++)
                    if (logic.posts[i].infoStatus == InfoStatus.loading)
                      Loading(i)
                    else if (logic.posts[i].infoStatus == InfoStatus.success)
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: screen.convert(20, height),
                                top: screen.convert(10, height),
                                right: screen.convert(10, width),
                                left: screen.convert(10, width)),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  textDirection: TextDirection.ltr,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        placeholder: (context, text) {
                                          return SizedBox(
                                              height:
                                                  screen.convert(65, height),
                                              width: screen.convert(65, width),
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator()));
                                        },
                                        width: screen.convert(65, width),
                                        height: screen.convert(65, height),
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            logic.posts[i].owner.profilePic,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: screen.convert(10, width))),
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            logic.posts[i].owner.userName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: screen.convert(
                                                    20, aspectRatio)),
                                          ),
                                          Text(
                                            logic.posts[i].date.toString(),
                                            style: GoogleFonts.cairo(
                                                fontSize: screen.convert(
                                                    12, aspectRatio)),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        var post = logic.posts[i];
                                        var status =
                                            post.downloadCallbackModel?.status;
                                        if (status ==
                                            DownloadTaskStatus.running) {
                                          logic.cancelDownload(post.taskId);
                                        } else {
                                          logic.posts.removeAt(i);
                                          logic.notifyListeners();
                                        }
                                      },
                                      child: SizedBox(
                                        height: screen.convert(30, height),
                                        width: screen.convert(30, width),
                                        child: Material(
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                          color: Colors.red,
                                          type: MaterialType.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screen.convert(20, height)),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '${logic.posts[i].getTitle}',
                                        style: TextStyle(
                                            fontSize:
                                                screen.convert(15, aspectRatio),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      logic.posts[i].title.length > 40
                                          ? InkWell(
                                              onTap: () {
                                                logic.showMore(i);
                                              },
                                              child: Text(
                                                  logic.posts[i].fullTitle
                                                      ? 'عرض اقل'
                                                      : 'عرض المزيد',
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          : SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    placeholder: (context, text) {
                                      return SizedBox(
                                          height: screen.convert(400, height),
                                          width: screen.convert(330, width),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()));
                                    },
                                    imageUrl: logic.posts[i].thumbnail,
                                    height: screen.convert(400, height),
                                    fit: BoxFit.cover,
                                    width: screen.convert(330, width),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: screen.convert(20, height))),
                                LinearProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.green),
                                  value: logic.posts[i].downloadCallbackModel
                                                  ?.progress
                                                  ?.toDouble() ==
                                              null ||
                                          logic.posts[i].downloadCallbackModel
                                                  .status ==
                                              DownloadTaskStatus.canceled
                                      ? 0
                                      : logic.posts[i].downloadCallbackModel
                                              .progress
                                              .toDouble() /
                                          100,
                                  backgroundColor:
                                      Colors.purple.withOpacity(0.1),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screen.convert(20, height)),
                                  child: ButtonTheme(
                                      minWidth: width,
                                      height: screen.convert(60, height),
                                      child: FlatButton.icon(
                                          colorBrightness: Brightness.dark,
                                          color: Colors.green,
                                          onPressed: logic.buttonState(i).locked
                                              ? null
                                              : () {
                                                  var buttonState =
                                                      logic.buttonState(i);
                                                  if (buttonState.text ==
                                                      'اكتمل التحميل افتح الآن') {
                                                    logic.openDownload(
                                                        logic.posts[i].taskId);
                                                  } else {
                                                    logic.startDownload(
                                                        context, i);
                                                  }
                                                },
                                          icon: Icon(
                                            FontAwesomeIcons.download,
                                            size:
                                                screen.convert(24, aspectRatio),
                                          ),
                                          label: Text(
                                            logic.buttonState(i).text,
                                            style: TextStyle(
                                                fontSize: screen.convert(
                                                    16, aspectRatio),
                                                fontWeight: FontWeight.w700),
                                          ))),
                                ),
                                ButtonTheme(
                                  height: screen.convert(60, height),
                                  minWidth: screen.convert(150, width),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      FlatButton.icon(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          colorBrightness: Brightness.dark,
                                          color: Colors.purple,
                                          onPressed: () {
                                            logic.copy(context,
                                                logic.posts[i].hashtags);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.hashtag,
                                            color: Colors.amber,
                                          ),
                                          label: Text(
                                            'نسخ الهاشتاق',
                                            style: TextStyle(
                                                fontSize: screen.convert(
                                                    16, aspectRatio),
                                                fontWeight: FontWeight.w700),
                                          )),
                                      FlatButton.icon(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          colorBrightness: Brightness.dark,
                                          color: Colors.purple,
                                          onPressed: () {
                                            logic.copy(
                                                context, logic.posts[i].title);
                                          },
                                          icon: Icon(
                                            FontAwesomeIcons.copy,
                                            color: Colors.amber,
                                          ),
                                          label: Text(
                                            'نسخ المحتوى',
                                            style: TextStyle(
                                                fontSize: screen.convert(
                                                    16, aspectRatio),
                                                fontWeight: FontWeight.w700),
                                          )),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider()
                        ],
                      )
                    else if (logic.posts[i].infoStatus == null)
                      SizedBox.shrink()
                    else
                      Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.all(10),
                                  height: screen.convert(300, height),
                                  color: Colors.grey.withOpacity(0.2),
                                  child: Center(
                                      child: Material(
                                    type: MaterialType.circle,
                                    color: Colors.green,
                                    child: InkWell(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      onTap: () async {
                                        var url = logic.posts[i].url;
                                        logic.posts[i] = Post(
                                          infoStatus: InfoStatus.loading,
                                        );
                                        logic.notifyListeners();

                                        logic.posts[i] = await logic
                                            .getVideoInfo(context, url);
                                        logic.notifyListeners();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Icon(
                                          Icons.replay,
                                          color: Colors.white,
                                          size: screen.convert(70, aspectRatio),
                                        ),
                                      ),
                                    ),
                                  ))),
                              Positioned.fill(
                                child: Align(
                                  alignment: Alignment(0.88, -0.85),
                                  child: InkWell(
                                    onTap: () {
                                      print('!');
                                      logic.posts.removeAt(i);
                                      logic.notifyListeners();
                                    },
                                    child: SizedBox(
                                      height: screen.convert(30, height),
                                      width: screen.convert(30, width),
                                      child: Material(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        color: Colors.red,
                                        type: MaterialType.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider()
                        ],
                      ),
                ],
              )),
    );
  }
}