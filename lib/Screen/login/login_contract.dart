
import 'dart:convert';
import 'dart:io';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/LoginModel.dart';
import 'package:creditscore/Apiservice/Responce/UserVerification.dart';
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart';
import 'package:creditscore/Apiservice/base/BasePresenter.dart';
import 'package:creditscore/Apiservice/base/BaseView.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:creditscore/Apiservice/base/BaseApiResponse.dart' as api;
import 'package:creditscore/Apiservice/base/BasePresenter.dart';
import 'package:creditscore/Apiservice/base/BaseView.dart';
import 'package:creditscore/Apiservice/DioUtils.dart';
import 'package:creditscore/Apiservice/Responce/RegisterResponce.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../KYCimage.dart';
import '../OtpScreen.dart';

class LoginView extends BaseView {
  void submitBtnDidTapped() {}

  void loginDidSucceed(String kyc,String userid,String token,String name) {}

  void loginDidFailed(String invalidFields) {}

}

class LoginPresenter {
  void doLogin(Map registrationData) {}
  void doFileUpload() {}
}

/////////////////////////////////////////////////////////////////////////////////////////////
class LoginPresenterImpl extends BasePresenter<LoginView>
    implements LoginPresenter {
   LoginPresenterImpl(LoginView view) : super(view);
  ProgressDialog pr;

  String verificationId, smsCode;
  bool codeSent = false;
  @override
  void doLogin(Map registrationData) async {
    mView.onNetworkCallStarted("Loading...");
    print(registrationData["mobile"]);
    print(registrationData);
    await PreferenceManager.sharedInstance.putInt(
        Keys.MOBILE_NUM.toString(), int.parse(registrationData["mobile"]));
    BaseApiResponse response = await DioUtils.reqeust(APIS.login,
        method: RequestMethod.POST, formData: registrationData);
    mView.onNetworkCallEnded();
    switch (response.status) {
      case Status.SUCCESS:
        LoginModel loginResponse =
        LoginModel.fromJson(response.data);
        await PreferenceManager.sharedInstance.putString(
            Keys.ACCESS_TOKEN.toString(), loginResponse.token);
        Map<String, dynamic> decodedToken = JwtDecoder.decode(loginResponse.token);
        print(decodedToken);
        await PreferenceManager.sharedInstance.putString(
            Keys.USER_ID.toString(), decodedToken["userId"]);
        await PreferenceManager.sharedInstance.putString(
            Keys.E_KYC.toString(), decodedToken["docEKYC"]);
        SharedPreferences preferences = await SharedPreferences.getInstance();
         preferences.setString(Constants.firstName,decodedToken["firstName"]);

        mView.loginDidSucceed(decodedToken["docEKYC"],decodedToken["userId"],loginResponse.token,decodedToken["firstName"]);
        break;

      case Status.DIO_ERROR:
        mView.loginDidFailed("Invalid mobile or password");
        super.handleError(response.error);
        break;
    }
  }
   @override
   void doFileUpload() async {
     String userId=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
     String token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
     var response = await DioUtils.fileUpload(userId,token,APIS.fileupload+userId);
     print(response);

   }


}