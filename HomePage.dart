import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Estudiante.dart';
import 'dart:convert';
import 'dbConnections.dart';
import 'UpdateScreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Estudiante? _estudianteSeleccionado;
  late GlobalKey<FormState> _formKey;
  late List<Estudiante> _estudiantes;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  late TextEditingController _nombreController;
  late TextEditingController _apellidoPaternoController;
  late TextEditingController _apellidoMaternoController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoElectronicoController;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _estudiantes = [];
    _scaffoldKey = GlobalKey();
    _nombreController = TextEditingController();
    _apellidoPaternoController = TextEditingController();
    _apellidoMaternoController = TextEditingController();
    _telefonoController = TextEditingController();
    _correoElectronicoController = TextEditingController();
    _selectData();
  }

  // Función de validación para el correo electrónico
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa un correo electrónico.';
    }
    // Utiliza una expresión regular para verificar la estructura del correo electrónico
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Por favor ingresa un correo electrónico válido.';
    }
    return null;
  }

  // Función de validación para números de teléfono
  String? _validateNumeric(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío.';
    }
    // Utiliza una expresión regular para verificar que solo contenga números
    RegExp numericRegExp = RegExp(r'^[0-9]+$');
    if (!numericRegExp.hasMatch(value)) {
      return 'Por favor ingresa solo números.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "AG13_Bases de datos remotas con MySQL y Xampp",
          style: TextStyle(
            color: Colors.white60,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: Text('Guardar', style: TextStyle(color: Colors.purple)),
              onTap: () {
                Navigator.pop(context);
                _showInsertForm();
              },
            ),
            ListTile(
              title: Text('Actualizar', style: TextStyle(color: Colors.purple)),
              onTap: () {
                Navigator.pop(context);
                _showUpdateScreen(_estudianteSeleccionado!);
              },
            ),
            ListTile(
              title: Text('Eliminar', style: TextStyle(color: Colors.purple)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmationDialog(_estudianteSeleccionado!);
              },
            ),
            ListTile(
              title: Text('Refrescar Tabla', style: TextStyle(color: Colors.purple)),
              onTap: () {
                Navigator.pop(context);
                _selectData();
              },
            ),
          ],
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20),
          Text(
            'Tabla Estudiantes:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: _dataTable(),
          ),
        ],
      ),
    );
  }

  Widget _dataTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text("ID", style: TextStyle(color: Colors.deepPurple))),
        DataColumn(label: Text("Nombre", style: TextStyle(color: Colors.deepPurple))),
        DataColumn(label: Text("Apellido Paterno", style: TextStyle(color: Colors.deepPurple))),
        DataColumn(label: Text("Apellido Materno", style: TextStyle(color: Colors.deepPurple))),
        DataColumn(label: Text("Telefono", style: TextStyle(color: Colors.deepPurple))),
        DataColumn(label: Text("Correo Electronico", style: TextStyle(color: Colors.deepPurple))),
      ],
      rows: _estudiantes
          .map((estudiante) => DataRow(
        cells: [
          DataCell(Text(estudiante.id.toString(), style: TextStyle(color: Colors.green))),
          DataCell(Text(estudiante.nombre, style: TextStyle(color: Colors.green))),
          DataCell(Text(estudiante.apellidoPaterno, style: TextStyle(color: Colors.green))),
          DataCell(Text(estudiante.apellidoMaterno, style: TextStyle(color: Colors.green))),
          DataCell(Text(estudiante.telefono, style: TextStyle(color: Colors.green))),
          DataCell(Text(estudiante.correoElectronico, style: TextStyle(color: Colors.green))),
        ],
        onSelectChanged: (_) {
          _selectEstudiante(estudiante);
        },
      ))
          .toList(),
    );
  }

  void _selectEstudiante(Estudiante estudiante) {
    setState(() {
      _estudianteSeleccionado = estudiante;
    });
  }

  void _showUpdateScreen(Estudiante estudiante) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateScreen(estudiante: estudiante),
      ),
    );
  }

  void _insertData() {
    if (_formKey.currentState?.validate() ?? false) {
      bdConnections.createTable();
      bdConnections
          .insertData(
        _nombreController.text.toUpperCase(),
        _apellidoPaternoController.text.toUpperCase(),
        _apellidoMaternoController.text.toUpperCase(),
        _telefonoController.text.toUpperCase(),
        _correoElectronicoController.text.toUpperCase(),
      )
          .then((result) {
        if ('success' == result) {
          _showSnackBar(context, result);
          _nombreController.text = "";
          _apellidoPaternoController.text = "";
          _apellidoMaternoController.text = "";
          _telefonoController.text = "";
          _correoElectronicoController.text = "";
          _selectData();
        }
      });
    }
  }

  void _showDeleteConfirmationDialog(Estudiante estudiante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación'),
          content: Text('¿Está seguro de que desea eliminar este registro?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                String id = estudiante.id;
                bdConnections.deleteData(id).then((response) {
                  if (response == "success") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('¡Registro eliminado!')));
                    _selectData(); // Actualiza la lista después de eliminar el estudiante
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar el registro')));
                  }
                });
                Navigator.of(context).pop(); // Cierra el diálogo después de eliminar
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _selectData() {
    bdConnections.selectData().then((estudiantes) {
      setState(() {
        _estudiantes = estudiantes;
      });
      _showSnackBar(context, "Data acquired");
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showInsertForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Estudiante'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: InputDecoration(labelText: 'Nombre'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un nombre.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _apellidoPaternoController,
                    decoration: InputDecoration(labelText: 'Apellido Paterno'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el apellido paterno.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _apellidoMaternoController,
                    decoration: InputDecoration(labelText: 'Apellido Materno'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el apellido paterno.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: InputDecoration(labelText: 'Telefono'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa un número telefónico.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      controller: _correoElectronicoController,
                      decoration: InputDecoration(labelText: 'Correo Electronico'),
                      validator: _validateEmail),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: _insertData,
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
