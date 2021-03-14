import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart';

import 'dart:math' as math;

import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

typedef void Callback(bool list, int h, int w);

class Camera extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String customModel;
  final Interpreter interpreter;
  final ImageProcessor imageProcessor;
  final String exercise;

  const Camera({this.cameras, this.setRecognitions, this.customModel, this.interpreter, this.imageProcessor, this.exercise});

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  CameraController controller;
  bool isDetecting = false;

  static const platform = const MethodChannel('ondeviceML');

  @override
  void initState() {
    super.initState();

    if (widget.cameras == null || widget.cameras.length < 1) {
      print('No camera is found');
    } else {
      controller = new CameraController(
        // widget.camera[0] for back camera
        // widget.camera[1] for front camera
        widget.cameras[1],
        ResolutionPreset.high,
      );
      

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) async{
          if (!isDetecting) {
            isDetecting = true;
            print("\n\n\n");
            print(img.planes);
            // img = copyResize(img, width:224, height:224);
            // int startTime = new DateTime.now().millisecondsSinceEpoch;

            List byteList = img.planes.map((plane) {
                return plane.bytes;
              }).toList();
            await Future.delayed(Duration(seconds: 1));
            print("\n\n\n\nlist loaded\n\n");
            // ImageProcessor imageProcessor =
            // new ImageProcessor.Builder()
            //     .add(new ResizeWithCropOrPadOp(cropSize, cropSize))
            //     .add(new ResizeOp(imageSizeX, imageSizeY, ResizeMethod.BILINEAR))
            //     .add(new Rot90Op(numRoration)
            //     .build();
            Tflite.runModelOnFrame(
              bytesList: byteList,
              imageHeight: img.height,
              imageWidth: img.width,
              numResults: 6,
              // rotation: -90,
              threshold: 0.8,              
            ).then((recognitions) { 
              // int endTime = new DateTime.now().millisecondsSinceEpoch;
              // print("Detection took ${endTime - startTime}");
              print(recognitions);
              bool val;
              try{
                print(widget.exercise);
                val = recognitions[0]["label"] == widget.exercise;
              }
              catch(e){
                val = false;
                // print(recognitions[0]);
              }
              widget.setRecognitions(val, img.height, img.width);

              isDetecting = false;
            });
          }
        });
      });
    }
  }
  void getPred() async{
    
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Container();
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
  }
}
