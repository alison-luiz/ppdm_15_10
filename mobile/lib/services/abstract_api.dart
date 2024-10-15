import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AbstractApi<T> {
  final _baseUrl = 'http://localhost:3000';

  String _resource;

  AbstractApi(this._resource);

  Future<String> getAll() async {
    var response = await http.get(Uri.parse('$_baseUrl/$_resource'));
    return response.body;
  }

  Future<String> getOne(String id) async {
    var response = await http.get(Uri.parse('$_baseUrl/$_resource/$id'));
    return response.body;
  }

  Future<String> create(Object body) async {
    var response = await http.post(
      Uri.parse("$_baseUrl/$_resource"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    return response.body;
  }

  Future<String> update(String id, Object body) async {
    var response = await http.put(
      Uri.parse("$_baseUrl/$_resource/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    return response.body;
  }

  Future<String> delete(String id) async {
    var response = await http.delete(Uri.parse("$_baseUrl/$_resource/$id"));
    return response.body;
  }
}
