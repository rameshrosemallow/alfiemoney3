
import 'dart:io';

import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/Sharedprefrance_data.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http_parser/http_parser.dart';
import 'ApiserviceProvider.dart';
import 'Responce/ForgotPaswordResponce.dart';
import 'base/BaseApiResponse.dart';
import 'base/ConnectivityUtils.dart';
import 'package:http/http.dart' as http;

enum RequestMethod { GET, POST, PUT }

class DioUtils {
  static Dio _dio = Dio();
  static Future forgot(String url, {Map formData}) async {
    try {
      var responseJSON;
      String msg;
      var response = (await http.post(APIS.forgot, headers: {
        "Content-Type": "application/json",
      }, body: json.encode(formData)));
      print(response.body);
      print(response.statusCode);
      if(response.statusCode==200){
        responseJSON = json.decode(response.body);
        ForgotPasswordResponce forgotResponse = ForgotPasswordResponce.fromJson(responseJSON);
        print(forgotResponse.result);
        msg= forgotResponse.result;
      }else if(response.statusCode==403){
         responseJSON = json.decode(response.body);
          responseJSON = forgotPasswordFromJson(response.body);
         msg= responseJSON.errors[0].msg;
         print(responseJSON.errors[0].msg);
      }
      return BaseApiResponse.onSuccessForgot(msg);
    } on DioError catch (error) {
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 422) {
        return BaseApiResponse.onFormDataError(error.response.data);
      } else {
        return BaseApiResponse.onDioError(error);
      }
    }
  }


  static Future register(String url, {Map formData}) async {
    try {
      var responseJSON;
      String msg;
      var response = (await http.post(APIS.forgot, headers: {
        "Content-Type": "application/json",
      }, body: json.encode(formData)));
      print(response.body);
      print(response.statusCode);
      if(response.statusCode==200){
        responseJSON = json.decode(response.body);
        ForgotPasswordResponce forgotResponse = ForgotPasswordResponce.fromJson(responseJSON);
        print(forgotResponse.result);
        msg= forgotResponse.result;
      }else if(response.statusCode==403){
        responseJSON = json.decode(response.body);
        responseJSON = forgotPasswordFromJson(response.body);
        msg= responseJSON.errors[0].msg;
        print(responseJSON.errors[0].msg);
      }
      return BaseApiResponse.onSuccessForgot(msg);
    } on DioError catch (error) {
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 422) {
        return BaseApiResponse.onFormDataError(error.response.data);
      } else {
        return BaseApiResponse.onDioError(error);
      }
    }
  }



  static Future fileUpload(String userid,String token,String url) async {
    try {
      var responseJSON;
      String msg;
      var postUri = Uri.parse(APIS.fileupload+"${userid}");
      var request = http.MultipartRequest("POST",postUri);
      //add text fields
      Map<String, String> headers = {
        "Authorization":token,
      };
      request.headers.addAll(headers);
      request.fields["key"] =Constants.documentType;
      String file=await PreferenceManager.sharedInstance.getString(Keys.SIGN1.toString());
      print(file);
      var pic = await http.MultipartFile.fromPath("document",File(file).path,  contentType: MediaType('image','jpg'),);
      print(pic.filename);
      request.files.add(pic);
      var response = await request.send();
      print(response.statusCode);
      print(response.statusCode);
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      if(response.statusCode==200){
        print(responseString);
        await PreferenceManager.sharedInstance.putBoolean(Keys.SIGN_STATUS.toString(),false);
      }
    } on DioError catch (error) {
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 422) {
        return BaseApiResponse.onFormDataError(error.response.data);
      } else {
        return BaseApiResponse.onDioError(error);
      }
    }
  }


  static Future<BaseApiResponse> reqeust(String url,
      {method: RequestMethod.GET, Map formData}) async {
    Response<Map> response;
    try {

      switch (method) {
        case RequestMethod.GET:
          response = await _getDio().get(url);
          break;
        case RequestMethod.POST:
          response = formData != null
              ? await _getDio().post(url, data: json.encode(formData))
              : await _getDio().post(url);
          break;
        case RequestMethod.PUT:
          print(method);
          response = formData != null
              ? await _getDio().put(url, data: json.encode(formData))
              : await _getDio().put(url);
          break;
      }
      return BaseApiResponse.onSuccess(response.data);
    } on DioError catch (error) {
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 422) {
        return BaseApiResponse.onFormDataError(error.response.data);
      } else {
        return BaseApiResponse.onDioError(error);
      }
    }
  }

  static Future<BaseApiResponse> uploadRequest(String url,
      {method: RequestMethod.POST, FormData formData}) async {
    try {
      Response<Map> response;
      response = await _getDio().post(url, data:formData);
      return BaseApiResponse.onSuccess(response.data);
    } on DioError catch (error) {
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 422) {
        return BaseApiResponse.onFormDataError(error.response.data);
      } else {
        return BaseApiResponse.onDioError(error);
      }
    }
  }

  static Dio _getDio() {
    if (_dio == null) {
      _dio = Dio();
    }
    _addInterceptor();
    return _dio;
  }

  static _addInterceptor() {
    final int maxCharactersPerLine = 200;
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) async {
      if (!await ConnectivityUtils.sharedInstance.isConnectionAvailable()) {
        throw NoConnectivityException;
      } else {
        // Dio Configuration >>>>>>
        options.baseUrl = APIS.baseurl; // It can be empty....
        options.connectTimeout = 10000; //5s
        options.receiveTimeout = 10000; //5s

        // Attaching Access token with request from Shared Preference >>>>>>
        _dio.interceptors.requestLock.lock();

        print(options.path);
        if (APIS.NoAuths.contains(options.path.toString())) {

          options.headers = {
            'Content-type': 'application/json',
            'Accept': 'application/json'
          };
        } else {
          String token = await PreferenceManager.sharedInstance
              .getString(Keys.ACCESS_TOKEN.toString());

          options.headers = {
            'Authorization':token,
            'Content-type': 'application/json',
            'Accept': 'application/json',
          };
          // options.headers["Authorization"] = "Bearer $token";
        }
        print(options.headers);
        _dio.interceptors.requestLock.unlock();

        // Printing Log before Sending Request >>>>>>>
        print("--> ${options.method} ${options.baseUrl}${options.path}");
        print("Content type: ${options.contentType}");
        print("<-- END HTTP");
        return options;
      }
    }, onResponse: (Response response) {
      print(
          "<-- ${response.statusCode} ${response.request.method} ${response
              .request.path}");
      String responseAsString = response.data.toString();
      if (responseAsString.length > maxCharactersPerLine) {
        int iterations =
        (responseAsString.length / maxCharactersPerLine).floor();
        for (int i = 0; i <= iterations; i++) {
          int endingIndex = i * maxCharactersPerLine + maxCharactersPerLine;
          if (endingIndex > responseAsString.length) {
            endingIndex = responseAsString.length;
          }
          print(responseAsString.substring(
              i * maxCharactersPerLine, endingIndex));
        }
      } else {
        print(response.data);
      }
      print("<-- END HTTP");
      return response;
    }, onError: (DioError error) {
      return error;
    }));
  }
}
