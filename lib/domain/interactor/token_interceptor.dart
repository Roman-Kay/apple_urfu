import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';

class TokenInterceptor extends Interceptor {
    @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SharedPreferenceData.getInstance().getToken();

    if (token != "") {
      options.headers['token'] = token;
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    //debugPrint('');
    super.onResponse(response, handler);
  }


  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async{

    debugPrint("IN ON ERROR INTERCEPTOR");
    debugPrint(err.message);
    debugPrint(err.error.toString());

    if(err.error.toString() == "HandshakeException: Handshake error in client (OS Error: errno = 0)" ||
        err.message == "The connection errored: Connection reset by peer This indicates an error which most likely cannot be solved by the library." ||
        err.message == "The request connection took longer than"
    ){
      try{

        debugPrint("HANDSHAKE UPDATE RELLOAD");
        // if(err.response != null){
        //   debugPrint("UPDATE 2");
        //   handler.resolve(err.response!);
        // }


        // Retry the request
        handler.resolve(await Dio(
          BaseOptions(contentType: 'application/json; charset=UTF-8',
              headers: {
                'Accept': 'application/json',
                'authorization': 'Basic ' + base64Encode(utf8.encode('gadget:fbKwDiwkEGQhX6gp'))
              }),
        ).fetch(err.requestOptions));

      } on DioException catch (e) {
        handler.next(e);
      }
    }
    else{
      super.onError(err, handler);
    }
  }
}
