class Pokemon{
  String nombre="";
  String url ="";
  int id;

 Pokemon({required this.nombre, required this.id,});

  Map<String, dynamic> toMap() {
    return {'name': nombre, 'id': id};
  }
}