import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instadownloader/cubits/starteCubit.dart';
import 'package:instadownloader/cubits/urlCubit.dart';
import 'package:instadownloader/widgets/inputWidget.dart';
import 'package:instadownloader/widgets/progressWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => UrlCubit()),
          BlocProvider(create: (_) => StateCubit())
        ],
        child: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Instagram Posts Downloader'),
        ),
        body: Column(
          children: [Input(), Flexible(child: Center(child: Progress()))],
        ));
  }
}
