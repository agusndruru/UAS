import 'package:dio/dio.dart';

class DioClient {
  late Dio dio;

  DioClient() {
    dio = Dio();
    dio.options.baseUrl = "http://172.27.107.120:5000/";
    dio.options.contentType = "application/json";
  }
}
