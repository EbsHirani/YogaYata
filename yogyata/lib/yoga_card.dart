import 'package:flutter/material.dart';

import 'camera_screen.dart';
import 'model_bloc.dart';
import 'model_event.dart';
import './strings.dart' as strings;

class YogaCard extends StatefulWidget {
  final String asana;
  final Color color;

  const YogaCard({this.asana, this.color});

  @override
  _YogaCardState createState() => _YogaCardState();
}

class _YogaCardState extends State<YogaCard> {
  final _bloc = ModelBloc();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: widget.color,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "assets/poses/" + widget.asana + ".jpg",
              fit: BoxFit.contain,
            ),
          ),
          Text(
            widget.asana,
            style: TextStyle(fontSize: 24),
          ),
          Center(
            child: StreamBuilder(
              stream: _bloc.selectedModel,
              initialData: strings.yoga1Prefab,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FlatButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Text(
                      'Show AR',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (builder) => CameraScreen(
                          selectedModel: snapshot.data,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }
}
