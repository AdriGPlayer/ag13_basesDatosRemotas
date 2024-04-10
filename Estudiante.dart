class Estudiante {
  String id;
  String nombre;
  String apellidoPaterno;
  String apellidoMaterno;
  String telefono;
  String correoElectronico;

  Estudiante(
      {required this.id,
        required this.nombre,
        required this.apellidoPaterno,
        required this.apellidoMaterno,
        required this.telefono,
        required this.correoElectronico});

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    return Estudiante(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellidoPaterno: json['apellidoPaterno'] as String,
      apellidoMaterno: json['apellidoMaterno'] as String,
      telefono: json['telefono'] as String,
      correoElectronico: json['correoElectronico'] as String,
    );
  }
}