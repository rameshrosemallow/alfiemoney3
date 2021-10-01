
import 'package:dio/dio.dart';

enum Status { SUCCESS, FORM_DATA_ERROR, DIO_ERROR ,SUCCESSFORGOT}

class BaseApiResponse {

  Status status;
  Map data;
  String reponceData;
  DioError error;
  BaseApiResponse.onSuccess(this.data): status = Status.SUCCESS;
  BaseApiResponse.onSuccessForgot(this.reponceData): status = Status.SUCCESSFORGOT;
  BaseApiResponse.onFormDataError(this.data): status = Status.FORM_DATA_ERROR;
  BaseApiResponse.onDioError(this.error): status = Status.DIO_ERROR;

}

