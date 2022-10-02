import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_project/widget/global.dart';
import '../constants.dart';

class DioHelper{
  static Dio dio;
  static init(){
    dio=Dio(
      BaseOptions(
          baseUrl: Constants.defaultUrl,
          receiveDataWhenStatusError:true,
          headers: {
            'Content-Type':'application/json'
          }
      ),
    );
  }

  static Future<Response> getData({
    @required String url,
    Map<String,dynamic> query,
  })async{
    dio.options.headers = {
      'Authorization': 'Bearer ${Global.token ?? ''}',
    };
    return await dio.get(url,queryParameters: query);
  }

  static Future<Response> postData({
    @required String url,
    Map<String ,dynamic> query,
    @required  data,
  }) async{
    dio.options.headers = {
      'Authorization': 'Bearer ${Global.token ?? ''}',
    };
    return await dio.post(
      url,
      queryParameters: query,
      data: data,
      options: Options(followRedirects: false,)
    );
  }


  static Future<Response> putData({
    @required String url,
    Map<String ,dynamic> query,
    @required Map<String ,dynamic>data,
  }) async{
    dio.options.headers={
      'Authorization':Global.token??'',
      'Content-Type':'application/json'
    };
    return await dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }



}