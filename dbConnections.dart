import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Estudiante.dart';
import 'dart:convert';

class bdConnections {
  static const SERVER = "http://192.168.100.12/students/sqloperations.php";
  static const _CREATE_TABLE_COMMAND = "CREATE_TABLE";
  static const _SELECT_TABLE_COMMAND = "SELECT_TABLE";
  static const _INSERT_DATA_COMMAND = "INSERT_DATA";
  static const _UPDATE_DATA_COMMAND = "UPDATE_DATA";
  static const _DELETE_DATA_COMMAND = "DELETE_DATA";

  //crear tabla
  static Future<String> createTable() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _CREATE_TABLE_COMMAND;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('Table response: ${response.body}');

      if (200 == response.statusCode) {
        print(response.body.toString());
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error creando tabla o la tabla ya existe");
      print((e.toString()));
      return "error";
    }
  }

  //seleccionar datos
  static Future<List<Estudiante>> selectData() async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _SELECT_TABLE_COMMAND;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('Select response: ${response.body}');

      if (200 == response.statusCode) {
        //mapear lista
        List<Estudiante> list = parseResponse(response.body);
        return list;
      } else {
        return <Estudiante>[];
      }
    } catch (e) {
      print("Error obteniendo datos");
      print((e.toString()));
      return <Estudiante>[];
    }
  }

  static List<Estudiante> parseResponse(String responsebody) {
    final parsedData = json.decode(responsebody).cast<Map<String, dynamic>>();
    return parsedData
        .map<Estudiante>((json) => Estudiante.fromJson(json))
        .toList();
  }

  //Insertar datos
  static Future<String> insertData(String nombre, String apellidoPaterno,
      String apellidoMaterno, String telefono, String correoElectronico) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _INSERT_DATA_COMMAND;
      map['nombre'] = nombre;
      map['apellidoPaterno'] = apellidoPaterno;
      map['apellidoMaterno'] = apellidoMaterno;
      map['telefono'] = telefono;
      map['correoElectronico'] = correoElectronico;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('Insert response: ${response.body}');

      if (200 == response.statusCode) {
        print("Successful insert");
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error añadiendo datos a la tabla");
      print((e.toString()));
      return "error";
    }
  }

  // Método estático para eliminar datos
  static Future<String> deleteData(String id) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _DELETE_DATA_COMMAND;
      map['id'] = id;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('Delete response: ${response.body}');

      if (200 == response.statusCode) {
        return "success";
      } else {
        return "error";
      }
    } catch (e) {
      print("Error eliminando datos de la tabla");
      print(e.toString());
      return "error";
    }
  }

  static Future<String> updateData(String id, String nombre, String apellidoPaterno,
      String apellidoMaterno, String telefono, String correoElectronico) async {
    try {
      var map = Map<String, dynamic>();
      map['action'] = _UPDATE_DATA_COMMAND;
      map['id'] = id;
      map['nombre'] = nombre;
      map['apellidoPaterno'] = apellidoPaterno;
      map['apellidoMaterno'] = apellidoMaterno;
      map['telefono'] = telefono;
      map['correoElectronico'] = correoElectronico;
      final response = await http.post(Uri.parse(SERVER), body: map);
      print('Update response: ${response.body}');

      if (200 == response.statusCode) {
        print("Successful update");
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      print("Error actualizando datos en la tabla");
      print((e.toString()));
      return "error";
    }
  }


}