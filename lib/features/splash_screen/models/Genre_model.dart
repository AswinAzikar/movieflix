class Genre {
  final int id;
  final String name;
  Genre(this.id, this.name);

  
   factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(json['id'], json['name']);
  }


//to json is needed in this api 

  // Map<String, dynamic> toJson() {
  //   return {
  //     'id': id,
  //     'name': name,
  //   };
  
}
