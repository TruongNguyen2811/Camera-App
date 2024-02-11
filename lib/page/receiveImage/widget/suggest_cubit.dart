import 'package:app_camera/page/receiveImage/widget/suggets_state.dart';
import 'package:app_camera/service/app_preferences/app_preferences.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestTextCubit extends Cubit<SuggestTextState> {
  SuggestTextCubit() : super(SuggestTextInitial());
  TextEditingController controller = TextEditingController();

  final sharedPref = AppPreferences();
  String textChoose = '';
  List<dynamic> listText = [];
}
