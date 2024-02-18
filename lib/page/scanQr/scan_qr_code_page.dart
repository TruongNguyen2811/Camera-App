import 'package:app_camera/page/scanQr/scan_qr_code_cubit.dart';
import 'package:app_camera/page/scanQr/scan_qr_code_state.dart';
import 'package:app_camera/page/scanQr/widget/submit_session.dart';
import 'package:app_camera/res/R.dart';
import 'package:app_camera/utils/custom_theme.dart';
import 'package:app_camera/utils/enum.dart';
import 'package:app_camera/utils/utils.dart';
import 'package:app_camera/widget/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late ScanQRCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = ScanQRCubit();
    _getCameraPermission();
  }

  Future<PermissionStatus> _getCameraPermission() async {
    var status = await Permission.camera.status;
    print('check status ${status}');
    if (!status.isGranted) {
      final resultPermission = await Permission.camera.request();
      return resultPermission;
    } else {
      return status;
    }
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   controller!.resumeCamera();
  // }

  @override
  Widget build(BuildContext context) {
    print('check create qr code');
    return Scaffold(
      backgroundColor: R.color.newPrimary,
      body: BlocConsumer<ScanQRCubit, ScanQRState>(
        bloc: cubit,
        listener: (context, state) async {
          if (state is ScanQRSucess) {
            showDialog(
                context: context,
                builder: (_) {
                  return SubmitSession(
                    sessionId: cubit.result?.code,
                  );
                }).then(
              (value) async {
                await cubit.controllerQr?.resumeCamera();
              },
            );
          }
        },
        builder: (context, state) {
          return buildPage(context, state);
        },
      ),
    );
  }

  Widget buildPage(BuildContext context, ScanQRState state) {
    return Stack(
      children: <Widget>[
        _buildQrView(context),
        Positioned(
          // alignment: Alignment.topLeft,
          left: 16,
          top: MediaQuery.of(context).size.height * 0.065,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(8.r),
              // margin:
              //     EdgeInsets.only(left: 0),
              // width: MediaQuery.of(context)
              //         .size
              //         .width *
              //     0.32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black26,
              ),
              child: Center(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.15,
          left: MediaQuery.of(context).size.width * 0.5 - 100.w,
          child: Center(
            child: ButtonWidget(
                backgroundColor: R.color.blueTextLight,
                height: 40.w,
                width: 200.w,
                title: 'Enter session Id',
                textStyle: Theme.of(context)
                    .textTheme
                    .text16
                    .copyWith(color: R.color.white),
                onPressed: () {
                  cubit.controllerQr?.pauseCamera();
                  showDialog(
                      context: context,
                      builder: (_) {
                        return SubmitSession();
                      }).then((value) => cubit.controllerQr?.resumeCamera());
                }),
          ),
        )

        // Expanded(
        //   flex: 1,
        //   child: Container(),
        //   //   child: FittedBox(
        //   //     fit: BoxFit.contain,
        //   //     child: Column(
        //   //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   //       children: <Widget>[
        //   //         if (result != null)
        //   //           Text(
        //   //               'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
        //   //         else
        //   //           const Text('Scan a code'),
        //   //         Row(
        //   //           mainAxisAlignment: MainAxisAlignment.center,
        //   //           crossAxisAlignment: CrossAxisAlignment.center,
        //   //           children: <Widget>[
        //   //             Container(
        //   //               margin: const EdgeInsets.all(8),
        //   //               child: ElevatedButton(
        //   //                   onPressed: () async {
        //   //                     await controller?.toggleFlash();
        //   //                     setState(() {});
        //   //                   },
        //   //                   child: FutureBuilder(
        //   //                     future: controller?.getFlashStatus(),
        //   //                     builder: (context, snapshot) {
        //   //                       return Text('Flash: ${snapshot.data}');
        //   //                     },
        //   //                   )),
        //   //             ),
        //   //             Container(
        //   //               margin: const EdgeInsets.all(8),
        //   //               child: ElevatedButton(
        //   //                   onPressed: () async {
        //   //                     await controller?.flipCamera();
        //   //                     setState(() {});
        //   //                   },
        //   //                   child: FutureBuilder(
        //   //                     future: controller?.getCameraInfo(),
        //   //                     builder: (context, snapshot) {
        //   //                       if (snapshot.data != null) {
        //   //                         return Text(
        //   //                             'Camera facing ${describeEnum(snapshot.data!)}');
        //   //                       } else {
        //   //                         return const Text('loading');
        //   //                       }
        //   //                     },
        //   //                   )),
        //   //             )
        //   //           ],
        //   //         ),
        //   //         Row(
        //   //           mainAxisAlignment: MainAxisAlignment.center,
        //   //           crossAxisAlignment: CrossAxisAlignment.center,
        //   //           children: <Widget>[
        //   //             Container(
        //   //               margin: const EdgeInsets.all(8),
        //   //               child: ElevatedButton(
        //   //                 onPressed: () async {
        //   //                   await controller?.pauseCamera();
        //   //                 },
        //   //                 child: const Text('pause',
        //   //                     style: TextStyle(fontSize: 20)),
        //   //               ),
        //   //             ),
        //   //             Container(
        //   //               margin: const EdgeInsets.all(8),
        //   //               child: ElevatedButton(
        //   //                 onPressed: () async {
        //   //                   await controller?.resumeCamera();
        //   //                 },
        //   //                 child: const Text('resume',
        //   //                     style: TextStyle(fontSize: 20)),
        //   //               ),
        //   //             )
        //   //           ],
        //   //         ),
        //   //       ],
        //   //     ),
        //   //   ),
        // )
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: cubit.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: R.color.white,
          borderRadius: 12.r,
          borderLength: 40.w,
          borderWidth: 8.w,
          cutOutSize: 280.w),
      onPermissionSet: (controller, p) =>
          _onPermissionSet(context, controller, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    print('check abc ${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('no Permission')),
      // );
      // Utils.showToast(context, 'You have not granted access to the camera',
      //     type: ToastType.ERROR);
    }
  }

  @override
  void dispose() {
    cubit.controllerQr?.dispose();
    super.dispose();
  }
}
