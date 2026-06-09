class Ejercicio {
  final int id;
  final String nombre;
  final String? grupoMuscular;
  final String? descripcion;
  final int deporteId;

  Ejercicio({
    required this.id,
    required this.nombre,
    this.grupoMuscular,
    this.descripcion,
    required this.deporteId,
  });

  factory Ejercicio.fromJson(Map<String, dynamic> json) {
    return Ejercicio(
      id: json['id'],
      nombre: json['nombre'],
      grupoMuscular: json['grupo_muscular'],
      descripcion: json['descripcion'],
      deporteId: json['deporte_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'grupo_muscular': grupoMuscular,
      'descripcion': descripcion,
      'deporte_id': deporteId,
    };
  }
}
