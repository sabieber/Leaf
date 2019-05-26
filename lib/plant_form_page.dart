import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:plant_calendar/database.dart';
import 'package:plant_calendar/plant.dart';
import 'package:sqflite/sqflite.dart';

class PlantForm extends StatefulWidget {
  PlantForm(this.plant);

  final Plant plant;

  @override
  PlantFormState createState() => new PlantFormState();
}

class PlantFormState extends State<PlantForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  Color color;

  @override
  void initState() {
    super.initState();
    if (widget.plant != null) {
      nameController.text = widget.plant.name;
      color = widget.plant.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[400],
        title: Text(
            widget.plant.id != null ? 'Pflanze bearbeiten' : 'Pflanze anlegen'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              new TextFormField(
                keyboardType: TextInputType.text,
                controller: nameController,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Gebe bitte den Name deiner Pflanze an';
                  }
                },
                decoration: new InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: MaterialPicker(
                  pickerColor: color,
                  enableLabel: true,
                  onColorChanged: (newColor) {
                    color = newColor;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (formKey.currentState.validate()) {
            Database db = await openDb();
            PlantProvider provider = PlantProvider(db);

            if (widget.plant.id != null) {
              Plant plant = widget.plant;
              plant.name = nameController.text;
              plant.color = color;
              await provider.update(plant);
            } else {
              Plant plant = Plant(nameController.text, color);
              await provider.insert(plant);
            }

            Navigator.pop(context);
          }
        },
        label: Text('Speichern'),
        backgroundColor: Colors.green[400],
        icon: Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
