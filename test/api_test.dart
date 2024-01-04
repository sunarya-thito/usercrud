import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

const kBaseUrl = 'http://localhost:3000';
main() {
  test('API Add user test', () async {
    var username = 'admin';
    var password = 'admin';
    var name = 'Administrator';
    var email = 'admin@gmail.com';
    var response = await http.post(
      Uri.parse('$kBaseUrl/users'),
      body: {
        'username': username,
        'password': password,
        'name': name,
        'email': email,
      },
    );

    // Pastikan response status code 200
    expect(response.statusCode, 200);

    // Pastikan mengembalikan {userId: <id user>}
    var body = response.body;
    expect(body, isNotEmpty);
    var json = jsonDecode(body);
    var userId = json['userId'];
    expect(userId, isNotNull);
  });

  test('API Get all users', () async {
    var response = await http.get(Uri.parse('$kBaseUrl/users'));

    // Pastikan response status code 200
    expect(response.statusCode, 200);

    // Pastikan mengembalikan array
    var body = response.body;
    expect(body, isNotEmpty);
    var json = jsonDecode(body);
    expect(json, isList);

    // Pastikan semua item array adalah Map<String, dynamic>
    for (var item in json) {
      expect(item, isMap);

      // Pastikan semua item memiliki key 'userid', 'username', 'name', 'password', dan 'email'
      expect(item['userid'], isNotNull);
      expect(item['username'], isNotNull);
      expect(item['name'], isNotNull);
      expect(item['password'], isNotNull);
      expect(item['email'], isNotNull);
    }
  });

  test('API Login test', () async {
    var username = 'admin';
    var password = 'admin';
    var response = await http.post(
      Uri.parse('$kBaseUrl/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    // Pastikan response status code 200
    expect(response.statusCode, 200);
    var body = response.body;
    expect(body, isNotEmpty);
    var json = jsonDecode(body);
    // Pastikan mengembalikan {username, name, email}
    expect(json['username'], isNotNull);
    expect(json['name'], isNotNull);
    expect(json['email'], isNotNull);
  });
}
