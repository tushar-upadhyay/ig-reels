import 'package:flutter_bloc/flutter_bloc.dart';

class UrlCubit extends Cubit<String> {
  UrlCubit() : super('Enter the url');
  void setUrl(String url) => emit(url == null ? 'Enter the URL' : url);
}
