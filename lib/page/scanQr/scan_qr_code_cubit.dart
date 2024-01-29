import 'package:app_camera/page/scanQr/scan_qr_code_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanQRCubit extends Cubit<ScanQRState> {
  ScanQRCubit() : super(ScanQRInitial());

  Barcode? result;
  QRViewController? controllerQr;

  void onQRViewCreated(QRViewController controller) {
    emit(ScanQRStart());
    this.controllerQr = controller;
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      controllerQr?.pauseCamera();
      emit(ScanQRSucess());
      print('check result code ${scanData.code}');
    });
  }
}
