import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class AbstractApi<T> {
  final _baseUrl = 'http://localhost:3000';

  String _resource;

  AbstractApi(this._resource);

  Future<String> getAll() async {
    var response = await http.get(Uri.parse('$_baseUrl/$_resource'));
    return utf8.decode(response.bodyBytes);
  }

  Future<String> getOne(String id) async {
    var response = await http.get(Uri.parse('$_baseUrl/$_resource/$id'));
    return utf8.decode(response.bodyBytes);
  }

  Future<String> create(Object body) async {
    var response = await http.post(
      Uri.parse("$_baseUrl/$_resource"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    return utf8.decode(response.bodyBytes);
  }

  Future<String> update(String id, Object body) async {
    var response = await http.put(
      Uri.parse("$_baseUrl/$_resource/$id"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );
    return utf8.decode(response.bodyBytes);
  }

  Future<String> delete(String id) async {
    var response = await http.delete(Uri.parse("$_baseUrl/$_resource/$id"));
    return utf8.decode(response.bodyBytes);
  }
}
