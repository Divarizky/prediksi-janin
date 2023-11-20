class UserModel{
  final String? id;
  final String nama;
  final String email;
  final String password;
  final String no;
  final String? image;

  UserModel({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    required this.no,
    this.image,
  });

  toJson(){
    return {
      "namaController" : nama,
      "emailController" : email,
      "passwordController" : password,
      "noController" : no,
      "image":image,
    };
  }
}