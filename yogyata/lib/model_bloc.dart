import 'dart:async';

import './model_event.dart';
import './strings.dart' as strings;

class ModelBloc {
  String _prefab = strings.yoga1Prefab;

  final _modelStateController = StreamController<String>();
  StreamSink<String> get _inModel => _modelStateController.sink;
  Stream<String> get selectedModel => _modelStateController.stream;

  final _modelEventController = StreamController<ModelEvent>();
  StreamSink<ModelEvent> get modelSink => _modelEventController.sink;

  ModelBloc() {
    void _mapEventToState(ModelEvent event) {
      if (event is Yoga1ModelSelectEvent) {
        _prefab = strings.yoga1Prefab;
      }

      _inModel.add(_prefab);
    }

    _modelEventController.stream.listen(_mapEventToState);
  }

  void dispose() {
    _modelStateController.close();
    _modelEventController.close();
  }
}
