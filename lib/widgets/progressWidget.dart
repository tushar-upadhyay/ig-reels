import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instadownloader/cubits/starteCubit.dart';
import 'package:share_plus/share_plus.dart';

class Progress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 48.0, left: 16.0, right: 16.0),
      child: BlocBuilder<StateCubit, dynamic>(builder: (context, state) {
        print(state.runtimeType);
        List<String> s = [];
        if (state.runtimeType == String) {
          return Text(
            state,
            style: TextStyle(fontSize: 18),
          );
        } else if (state.runtimeType == s.runtimeType) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Downloaded',
                style: TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                  onPressed: () {
                    Share.shareFiles(state);
                  },
                  child: Text(
                    'Share!',
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          );
        } else if (state.runtimeType == bool) {
          if (!state) {
            return Container();
          }
          return LinearProgressIndicator();
        } else {
          return LinearProgressIndicator(
            value: state,
          );
        }
      }),
    );
  }
}
