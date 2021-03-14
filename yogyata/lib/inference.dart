import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:yogyata/bndbox.dart';
import 'package:yogyata/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class InferencePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  final String model;
  final String customModel;
  final int time;

  const InferencePage({this.cameras, this.title, this.model, this.customModel, this.time});

  @override
  _InferencePageState createState() => _InferencePageState();
}

class _InferencePageState extends State<InferencePage> {
  int time = 10;
  List<Map> map = [
    {
      "exercise" : "downdog",
      "duration" : 5,
    },
    {
      "exercise" : "plank",
      "duration" : 5,
    },
    
  ];
  String exercise = "downdog";
  bool _recognitions = false;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int count, len;
  Interpreter interpreter;
  ImageProcessor imageProcessor;
  @override
  void initState() {
    super.initState();
    var res = loadModel();
    print("loaded");
    // interpreter = loadCustom();
    print('Model Response: ' + res.toString());
    len = map.length;
    count = 0;
    time = map[count]["duration"];
    exercise = map[count]["exercise"];
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    // imageProcessor = ImageProcessorBuilder()
    //         .add(ResizeOp(224, 224, ResizeMethod.NEAREST_NEIGHBOUR))
    //         .build();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title:Text("Yoga Pose"),
      ),
      body: Stack(
        children: <Widget>[
          
          Camera(
            cameras: widget.cameras,
            setRecognitions: _setRecognitions,
            interpreter: interpreter,
            imageProcessor: imageProcessor,
            exercise: exercise,
          ),
          Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.fromLTRB(32.0, 0, 32.0, 16.0),
          child: Text(
            count == len? "Done!!" : exercise,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
            ),
          count == len?
          Container()
          :BndBox(
            results: _recognitions,
            // previewH: max(_imageHeight, _imageWidth),
            // previewW: min(_imageHeight, _imageWidth),
            // screenH: screen.height,
            // screenW: screen.width,
            // customModel: widget.customModel,
          ),
        ],
      ),
    );
  }

  _setRecognitions(recognitions, imageHeight, imageWidth) {
    // if (!mounted) {
    //   return;
    // }
    if (recognitions){

      setState(() {
        _recognitions = recognitions;
        time -= 1;
        print(time);
        // _imageHeight = imageHeight;
        // _imageWidth = imageWidth;
      });
      if(time == 0){
        setState(() {
          
          count ++;
        });
        if (count < len){

          setState(() {
            time = map[count]["duration"];
            exercise = map[count]["exercise"];
          });
        }
      }
    }
    else {
      setState(() {
        _recognitions = recognitions;
        // time -= 1;
        // print(time);
        // _imageHeight = imageHeight;
        // _imageWidth = imageWidth;
      });
    }
    

    
  }

  loadModel() async {
    print("loading\n\n\n\n");
    return await Tflite.loadModel(
      model: widget.customModel,
      labels: "assets/models/labels.txt",
    );
  }
  // loadCustom() async {
  //   Interpreter interpreter =
  //       await Interpreter.fromAsset("model_mn.tflite");  
  //   return interpreter;
  // }
}
