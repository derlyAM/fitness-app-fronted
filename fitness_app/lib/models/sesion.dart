class Sesion {
  final int id;
  final DateTime fecha;
  final int? duracion;
  final String? notas;
  final int usuarioId;
  final int rutinaId;
  final String? nombreDeporte;

  Sesion({
    required this.id,
    required this.fecha,
    this.duracion,
    this.notas,
    required this.usuarioId,
    required this.rutinaId,
    this.nombreDeporte,
  });

  factory Sesion.fromJson(Map<String, dynamic> json) {
    return Sesion(
      id: json['id'],
      fecha: DateTime.parse(json['fecha']),
      duracion: json['duracion'],
      notas: json['notas'],
      usuarioId: json['usuario_id'],
      rutinaId: json['rutina_id'],
      nombreDeporte: json['nombre_deporte'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha.toIso8601String(),
      'duracion': duracion,
      'notas': notas,
      'usuario_id': usuarioId,
      'rutina_id': rutinaId,
      'nombre_deporte': nombreDeporte,
    };
  }
}
