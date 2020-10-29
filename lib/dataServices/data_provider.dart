import 'dart:convert';
import 'package:http/http.dart';
import 'package:codable/codable.dart';

class DataProvider {
  Future<T> fetchFromUrl<T extends Coding>(String url, T model) async {
    Response res = await get(url);
    final readingJson = json.decode(res.body);
    final archive = KeyedArchive.unarchive(readingJson);
    model.decode(archive);
    return model;
  }
}