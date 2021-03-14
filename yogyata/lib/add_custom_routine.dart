import 'package:flutter/material.dart';

import 'new_task.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AddCustomRoutine extends StatefulWidget {
  @override
  _AddCustomRoutineState createState() => _AddCustomRoutineState();
}

class Task {
  String id;
  String name;
  String time;

  Task(this.id, this.name, this.time);
}

class _AddCustomRoutineState extends State<AddCustomRoutine> {
  List<Task> tasks = [];

  void deleteTx(String id) {
    setState(() {
      tasks.removeWhere((tx) {
        print(tx.id);
        print(id);
        return tx.id == id;
      });
    });
    print("Called");
    print(tasks);
  }

  void addNewTask(String id, String name, String time) {
    final newTx = Task(
      DateTime.now().toString(),
      name,
      time,
    );

    setState(() {
      tasks.add(newTx);
    });
  }

  void startNewTask(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTask(addNewTask),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      /// both default to 16
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.add,
      activeIcon: Icons.remove,
      buttonSize: 56.0,
      visible: true,

      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      children: [
        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
          label: 'Add',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => startNewTask(context),
        ),
        SpeedDialChild(
          child: Icon(Icons.check),
          backgroundColor: Colors.blue,
          label: 'Start Routine',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => print('SECOND CHILD'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Your Custom Routine'),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        'No Asanas added yet!',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'assets/images/waiting.png',
                        fit: BoxFit.cover,
                      )),
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text('${tasks[index].time}s'),
                        ),
                      ),
                    ),
                    title: Text(
                      tasks[index].name,
                    ),
                    trailing: MediaQuery.of(context).size.width > 360
                        ? FlatButton.icon(
                            icon: Icon(Icons.delete),
                            label: Text('Delete'),
                            textColor: Theme.of(context).errorColor,
                            onPressed: () {
                              deleteTx(tasks[index].id);
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () {
                              deleteTx(tasks[index].id);
                            },
                          ),
                  ),
                );
              },
              itemCount: tasks.length,
            ),

      floatingActionButton: buildSpeedDial(),

      // FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () => startNewTask(context),
      // ),
    );
  }
}
