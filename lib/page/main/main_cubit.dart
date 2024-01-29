import 'package:app_camera/page/main/main_state.dart';
import 'package:app_camera/service/app_preferences/app_preferences.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());
  TextEditingController controller = TextEditingController();

  final sharedPref = AppPreferences();
}
