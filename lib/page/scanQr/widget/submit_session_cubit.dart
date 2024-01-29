import 'package:app_camera/page/scanQr/widget/subit_session_state.dart';
import 'package:app_camera/service/app_preferences/app_preferences.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitSessionCubit extends Cubit<SubmitSessionState> {
  SubmitSessionCubit() : super(SubmitSessionInitial());
  TextEditingController controller = TextEditingController();

  final sharedPref = AppPreferences();

  voidSubmitSessionId() {
    emit(SubmitSessionLoading());
    if (Utils.isEmpty(controller.text)) {
      emit(SubmitSessionFailure("You need to enter session Id"));
      return;
    }
    sharedPref.saveSessionId(controller.text);
    emit(SubmitSessionSucess("You are in session Id ${controller.text}"));
  }
}
