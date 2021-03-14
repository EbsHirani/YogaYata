import 'package:flutter/material.dart';

class NewTask extends StatefulWidget {
  final Function addNewTask;

  NewTask(this.addNewTask);
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  var nameController = "Plank";

  final timeController = TextEditingController();

  void submitData() {
    if (timeController.text.isEmpty) {
      return;
    }
    final enteredName = nameController;
    final enteredTime = timeController.text;

    if (enteredName.isEmpty || int.parse(enteredTime) <= 0) {
      return;
    }
    widget.addNewTask("", enteredName, enteredTime);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                height: 60,
                width: double.infinity,
                child: DropdownButton<String>(
                  value: nameController,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      nameController = newValue;
                    });
                  },
                  items: <String>[
                    'Plank',
                    'Goddess',
                    'Warrior 2',
                    'Down Dog',
                    'Tree'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(fontSize: 17),
                      ),
                    );
                  }).toList(),
                ),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Time (secs)'),
                controller: timeController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                // onChanged: (val) {
                //   amountInput = val;
                // },
              ),
              RaisedButton(
                onPressed: submitData,
                child: Text('Add Asana'),
                textColor: Theme.of(context).textTheme.button.color,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
