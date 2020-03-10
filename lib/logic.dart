import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_downloader_example/constants.dart';
import 'package:html/dom.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

typedef DownloadOperations(String id);

class Logic with ChangeNotifier {
  void downloadOperations(String id, DownloadOperations downloadOperations) {
    downloadOperations(id);
  }

  Future<bool> checkPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void pauseDownload(String id) async {
    await FlutterDownloader.pause(taskId: id);
  }

  void resumeDownload(String id) async {
    await FlutterDownloader.resume(taskId: id);
  }

  void cancelDownload(String id) async {
    await FlutterDownloader.cancel(taskId: id);
  }

  void startDownload(String url, String name) async {
    await FlutterDownloader.enqueue(
      savedDir: Constants.path,
      fileName: '$name.mp4',
      url: url,
    );
  }

  void openDownload(String id) async {
    await FlutterDownloader.open(taskId: id);
  }

  void retryDownload(String id) async {
    String newTaskId = await FlutterDownloader.retry(taskId: id);
  }

  Future<String> getVideoDownloadLink(String originalUrl) async {
    var response = await http.get(originalUrl);
    var document = parse(response.body).body;

    var text = document.querySelector('script[type="text/javascript"]').text;
    text = (text.substring(text.indexOf('{'), text.length - 1));
    Map<String, dynamic> decoded = jsonDecode(text);
    Map<String, dynamic> root =
        decoded['entry_data']['PostPage'][0]['graphql']['shortcode_media'];

    if (root.containsKey('video_url')) {
      return (root['video_url']);
    } else {
      return (root['edge_sidecar_to_children']['edges'][0]['node']
          ['video_url']);
    }
  }
  //
}