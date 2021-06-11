import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instadownloader/cubits/starteCubit.dart';
import 'package:instadownloader/cubits/urlCubit.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class DownloadService {
  final BuildContext context;
  String path = '/storage/emulated/0/Download/';
  DownloadService(this.context);

  bool validateUrl(String url) {
    return url.startsWith('www.instagram.com') ||
        url.startsWith('https://www.instagram.com');
  }

  void download(data, name) {
    File file = File(path + name + '.mp4');
    file.writeAsBytesSync(data);
  }

  bool checkAlreadyDownloaded(fileName) {
    return File(path + fileName + '.mp4').existsSync();
  }

  void load() async {
    String url = BlocProvider.of<UrlCubit>(context, listen: false).state;
    StateCubit s = BlocProvider.of<StateCubit>(context, listen: false);

    if (!validateUrl(url)) {
      return s.updateState('Enter Correct Url');
    }
    if (url.startsWith("www.instagram.com")) {
      url += "https://";
    }
    List data = url.split("/");
    url = 'https://${data[2]}/${data[3]}/${data[4]}';
    if (checkAlreadyDownloaded(data[4])) {
      return s.updateState([path + data[4] + '.mp4']);
    }
    url += "/?__a=1";
    s.updateState(true);
    var response = await http.get(Uri.parse(url));
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

    String downloadUrl =
        jsonResponse["graphql"]["shortcode_media"]["video_url"];
    var res = await Dio()
        .get(downloadUrl, options: Options(responseType: ResponseType.bytes),
            onReceiveProgress: (int r, int total) {
      double p = ((r / total));
      s.updateState(p);
    });
    download(res.data, data[4]);
    BlocProvider.of<UrlCubit>(context, listen: false).setUrl("");
    s.updateState([path + data[4] + '.mp4']);
    // print(res.data);
  }
}
