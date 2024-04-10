import 'HomePage.dart';
import 'package:flutter/material.dart';
import 'dbConnections.dart';
import 'Estudiante.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();

  final Estudiante estudiante;

  UpdateScreen({required this.estudiante});

}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _apellidoPaternoController;
  late TextEditingController _apellidoMaternoController;
  late TextEditingController _telefonoController;
  late TextEditingController _correoElectronicoController;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.estudiante.nombre);
    _apellidoPaternoController = TextEditingController(text: widget.estudiante.apellidoPaterno);
    _apellidoMaternoController = TextEditingController(text: widget.estudiante.apellidoMaterno);
    _telefonoController = TextEditingController(text: widget.estudiante.telefono);
    _correoElectronicoController = TextEditingController(text: widget.estudiante.correoElectronico);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actualizar Registro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _apellidoPaternoController,
              decoration: InputDecoration(labelText: 'Apellido Paterno'),
            ),
            TextFormField(
              controller: _apellidoMaternoController,
              decoration: InputDecoration(labelText: 'Apellido Materno'),
            ),
            TextFormField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: _correoElectronicoController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _updateData(context),
              child: Text('Guardar Cambios'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateData(BuildContext context) {
    final id = widget.estudiante.id.toString();
    final nombre = _nombreController.text;
    final apellidoPaterno = _apellidoPaternoController.text;
    final apellidoMaterno = _apellidoMaternoController.text;
    final telefono = _telefonoController.text;
    final correoElectronico = _correoElectronicoController.text;

    bdConnections.updateData(id, nombre, apellidoPaterno, apellidoMaterno, telefono, correoElectronico)
        .then((response) {
      if (response == "success") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('¡Registro actualizado!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar el registro')));
      }
    });
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoPaternoController.dispose();
    _apellidoMaternoController.dispose();
    _telefonoController.dispose();
    _correoElectronicoController.dispose();
    super.dispose();
  }
}