import 'dart:convert';

import 'package:http/http.dart' as http;

const kBaseUrl = 'https://usercrud-xi.vercel.app';

class UserDto {
  final int? id;
  final String username;
  final String name;
  final String email;

  UserDto({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
  });

  UserDto.fromJson(Map<String, dynamic> json)
      : id = (json['userid'] as num?)?.toInt(),
        username = json['username'],
        name = json['name'],
        email = json['email'];

  static Future<List<UserDto>> findAll() async {
    var response = await http.get(Uri.parse('$kBaseUrl/user'));
    var body = response.body;
    var json = jsonDecode(body);
    var list = <UserDto>[];
    for (var item in json) {
      list.add(UserDto.fromJson(item));
    }
    return list;
  }

  static Future<int> add(
      String username, String name, String password, String email) async {
    var response = await http.post(
      Uri.parse(
          '$kBaseUrl/user?username=$username&name=$name&password=$password&email=$email'),
    );
    var body = response.body;
    var json = jsonDecode(body);
    return json['userid'];
  }

  static Future<UserDto> login(String username, password) async {
    var response = await http.post(
      Uri.parse('$kBaseUrl/login?username=$username&password=$password'),
    );
    var body = response.body;
    var json = jsonDecode(body);
    if (json['error'] != null) {
      throw json['error'];
    }
    return UserDto.fromJson(json);
  }
}
