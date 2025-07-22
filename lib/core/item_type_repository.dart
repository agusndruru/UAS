import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pos/core/dio_client.dart';
import 'package:flutter_pos/data/create_response.dart';
import 'package:flutter_pos/data/edit_response.dart';
import 'package:flutter_pos/data/index_response.dart';

class ItemTypeRepository extends DioClient {
  Future<CreateResponse> create(Map<String, dynamic> params) async {
    var response = await dio.post("item_type", data: params);
    return CreateResponse.fromJson(response.data);
  }

  Future<IndexResponse> index() async {
    var response = await dio.get("item_type");
    return IndexResponse.fromJson(response.data);
  }

  Future<EditResponse> update(int id, Map<String, dynamic> data) async {
    final response = await dio.put("item_type/$id", data: data);
    return EditResponse(message: response.data, status: true);
  }

  Future<void> deleteItem(String id) async {
    try {
      await dio.delete("item_type/$id"); 
    } catch (e) {
      throw Exception('Gagal menghapus item: $e');
    }
  }
}
