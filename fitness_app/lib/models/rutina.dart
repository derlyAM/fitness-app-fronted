class Rutina {
  final int id;
  final String nombre;
  final String? descripcion;
  final int deporteId;
  final int usuarioId;

  Rutina({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.deporteId,
    required this.usuarioId,
  });

  factory Rutina.fromJson(Map<String, dynamic> json) {
    return Rutina(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      deporteId: json['deporte_id'],
      usuarioId: json['usuario_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'deporte_id': deporteId,
      'usuario_id': usuarioId,
    };
  }
}
