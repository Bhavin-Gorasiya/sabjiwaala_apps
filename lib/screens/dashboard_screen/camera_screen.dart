import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:open_app_settings/open_app_settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../helper/navigations.dart';
import '../../view model/CustomViewModel.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key, required this.cameras}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;

  String imagePath = '';
  XFile? image;
  bool isFlash = false;
  bool cameraChange = false;
  bool? camPermission;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 0),
      () async {
        setState(() async {
          camPermission = await permission();
        });
      },
    );
    initCamera(widget.cameras.first);
  }

  Future<bool> permission() async {
    if (await Permission.camera.isDenied) {
      await Permission.camera.request().then((value) {
        if (value.isGranted) {
          log("==>> ==== permission ${value.name}");
          return true;
        } else if (value.isDenied) {
          log("==>> ==== permission ${value.name}");
          return false;
        } else {
          log("==>> ==== permission ${value.name}");
          return false;
        }
      });
      return Permission.camera.isGranted;
    } else {
      return true;
    }
  }

  Future takePicture() async {
    if (!_cameraController.value.isInitialized) {
      return null;
    }
    if (_cameraController.value.isTakingPicture) {
      return null;
    }
    try {
      // await _cameraController.setFlashMode(FlashMode.torch);
      final picture = await _cameraController.takePicture();
      setState(() {
        imagePath = picture.path;
        image = picture;
      });
      log(picture.path);
    } on CameraException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 5.0),
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
              title: const Text(
                "Camera Permission Denied",
                textAlign: TextAlign.center,
              ),
              content: const Text(
                "Permission required to capture image from your camera. "
                "You can provide the required permissions from settings.",
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    pop(context);
                    await OpenAppSettings.openAppSettings();
                  },
                  child: Text(
                    "Take me to settings",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          });
      log('Error occurred while taking picture: $e');
      return null;
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(cameraDescription, ResolutionPreset.high);
    try {
      await _cameraController.initialize().then((_) {
        if (!mounted) return;
        setState(() {
          camPermission = true;
        });
      });
    } on CameraException catch (e) {
      setState(() {
        camPermission = false;
      });
      log('camera error ${e.description}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: camPermission == null
            ? Center(child: CircularProgressIndicator())
            : camPermission!
                ? Stack(
                    children: [
                      if (imagePath != '')
                        Image.file(
                          height: size.height - (size.height * 0.15),
                          width: size.width,
                          fit: BoxFit.cover,
                          File(imagePath),
                        )
                      else
                        _cameraController.value.isInitialized
                            ? CameraPreview(_cameraController)
                            : Container(
                                color: Colors.black,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          alignment: Alignment.topLeft,
                          height: 60,
                          width: size.width,
                          color: Colors.black,
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                            bottom: 10,
                            left: size.width * 0.04,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (isFlash) {
                                isFlash = false;
                                setState(() {
                                  _cameraController.setFlashMode(FlashMode.off);
                                });
                              } else {
                                isFlash = true;
                                setState(() {
                                  _cameraController.setFlashMode(FlashMode.torch);
                                });
                              }
                            },
                            child: Icon(
                              Icons.flash_on,
                              color: Colors.white,
                              size: size.width * 0.06,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: EdgeInsets.all(imagePath == '' ? 10 : 30),
                          alignment: Alignment.center,
                          height: size.height * 0.15,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            color: Colors.black,
                          ),
                          child: imagePath != ''
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          imagePath = '';
                                        });
                                      },
                                      child: Text(
                                        'Retake',
                                        style: TextStyle(
                                          fontSize: size.width * 0.04,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        pop(context);
                                        CustomViewModel customViewModel =
                                            Provider.of<CustomViewModel>(context, listen: false);
                                        customViewModel.changeCamImg(imagePath);
                                      },
                                      child: Text(
                                        'Use Photo',
                                        style: TextStyle(
                                          fontSize: size.width * 0.04,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        pop(context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 30),
                                        color: Colors.transparent,
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(fontSize: size.width * 0.045, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'PHOTO',
                                          style: TextStyle(
                                            fontSize: size.width * 0.035,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Container(
                                          alignment: Alignment.center,
                                          width: size.width * 0.13,
                                          height: size.width * 0.13,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: GestureDetector(
                                            onTap: takePicture,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: size.width * 0.055,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.only(top: 30, left: 30, right: 5),
                                      icon: Icon(
                                        Icons.flip_camera_ios_outlined,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        if (cameraChange) {
                                          setState(() {
                                            cameraChange = false;
                                          });
                                          initCamera(widget.cameras.first);
                                        } else {
                                          setState(() {
                                            cameraChange = true;
                                          });
                                          initCamera(widget.cameras.last);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Camera Permission is not Granted",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () async {
                              if (await Permission.camera.shouldShowRequestRationale) {
                                initCamera(widget.cameras.first);
                              } else {
                                openAppSettings();
                              }
                              log("===>>> ${await Permission.camera.shouldShowRequestRationale}");
                            },
                            child: Text("Give Permission")),
                      ],
                    ),
                  ),
      ),
    );
  }
}
