class Deporte {
  final int id;
  final String nombre;
  final String? icono;

  Deporte({required this.id, required this.nombre, this.icono});

  factory Deporte.fromJson(Map<String, dynamic> json) {
    return Deporte(
      id: json['id'],
      nombre: json['nombre'],
      icono: json['icono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nombre': nombre, 'icono': icono};
  }
}
