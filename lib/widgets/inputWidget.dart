import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instadownloader/cubits/starteCubit.dart';
import 'package:instadownloader/cubits/urlCubit.dart';
import 'package:instadownloader/services/downloadService.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class Input extends StatefulWidget {
  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  final _key = GlobalKey<FormState>();
  late StreamSubscription _intentDataStreamSubscription;
  final _textController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _intentDataStreamSubscription =
        ReceiveSharingIntent.getTextStream().listen((String value) {
      if (value == null) {
        return;
      }
      _textController.text = value;
      context.read<UrlCubit>().setUrl(value);
      DownloadService(context).load();
    }, onError: (err) {
      print("getLinkStream error: $err");
    });

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialText().then((value) {
      if (value == null) {
        return;
      }
      _textController.text = value.toString();
      context.read<UrlCubit>().setUrl(value.toString());
      DownloadService(context).load();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _intentDataStreamSubscription.cancel();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrlCubit, String>(builder: (context, state) {
      _textController.text = state;
      return Form(
        key: _key,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Paste the URL',
                ),
                validator: (url) {
                  if (url == null || url.isEmpty) {
                    return 'Enter Url';
                  }
                },
                onChanged: (url) {
                  context.read<UrlCubit>().setUrl(url);
                },
                style: TextStyle(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                bool isValid = _key.currentState!.validate();
                if (isValid) {
                  DownloadService(context).load();
                }
              },
              child: Text('Download...'),
            )
          ],
        ),
      );
    });
  }
}
