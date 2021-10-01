import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Colors.dart';
import 'size_config.dart';

class Constants {
  static final DIRECTION_API_KEY = "AIzaSyCe8YwpuLg15WIsdOBhMo5Q__aMN6qG5iA";
  static var KCURRENCY = "\$";
  static String appName='ACS';
  static String fontName='Multi';
  static String developerBy='@Rosemallow Technologies Pvt Ltd';
  static String developerLogo='assets/images/logo.png';
  static String welcomeBack='Welcome to ACS';
  static String welcomeBack1='Enter your mobile number below';

  static var documentType = "docSign";
  static var KCURRENCY_CODE = "USD";

  static var kKeyLanguage = "language";
  static double multiply(double a, double b) => a  * b;

  static var loanFees = 500;

  static String password="password";
  static String firstName="firstName";
  static String lastName="lastName" ;
  static String icNumbe="icNumber" ;
  static String dob="Dob" ;
  static String address1="address1" ;
  static String address2="address2" ;
  static String cityName="cityName" ;
  static String zipCode="zipCode";
  static String emailId="emailId" ;
  static String facebookId="faceBookId";
  static String doc ="document";
  static String docSign ="docSign";
  static String docEYC="docEYC";
  static String docBank="docBankStatements";
////////internet
  static String interNetconnection="Check Your Internet Connection !!";
  static String loadingPage="Loading...";
  static String errorMsg="Server Error";
  static String messageData="Try again";
  static String messageExit="Are you sure?";
  static String messageExit1="Do you want to exit an App";
  static String phoneNumber;
  static String countryCode;
  static String docSignfile;
  static String docKycfile;
  //////////////////
  static String loanId="loanId";
  static String productType="productType";
  static String tenureMonth="tenureMonth";
  static String loanFeess="loanFeess";
  static String loanAmount="loanAmount";
  static String interestRate="interestRate";
  static String loanStatus="loanStatus";
  static String loanstatus1="Loan approval pending";
  static String loanstatus2="Awaiting Loan approval";
  static String loanstatus3="Loan Approved Awaiting Disbursement";


  static String formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss:a').format(dateTime);
  }

}

const Color kPrimaryColor = Color(0xFF1E1F36);
const Color kAccentColor = Color(0xFF7101E3);
const Color kInactiveColor = Color(0xFF9098B1);
const Color kNavigationDrawerBackgroundColor = Color(0xFF001D24);
const Color kAppBarBackgroundColor = Color(0xFF001D24);
const Color kWidgetAccentColor = Color(0xFF7101E3);
const Color kActiveBackgroundColor = Color(0xFF0D8F11);
const Color kPendingBackgroundColor = Color(0xFFF1BB26);
const Color kClosedBackgroundColor = Color(0xFF001D24);
const Color kRegularTextColor = Color(0xFF6A6A6A);
const Color kSecondaryTextColor = Color(0xFF8D8D8D);
const Color kLightTextColor = Color(0xFFBBBEC3);
const Color kRedTextColor = Color(0xFFFF2C5D);
const Color kGreenTextColor = Color(0xFF0D8F11);
const Color kDividerColor = Color(0xFFE6E6E6);
const Color kDivider2Color = Color(0x80B2B2B2);
const Color kPremiumUserBackgroundColor = Color(0xFF908D6B);
const Color kCancelledBackgroundColor = Color(0xFF95989A);
const Color kApprovedStatusColor = Color(0xFF19BF3F);
const Color kDeclinedStatusColor = Color(0xFFFF0600);
const Color kPendingStatusColor = Color(0xFFF1BB26);
const Color kCommonBackgroundColor = Color(0xFFF9FAFB);
const Color kWhiteColor = Color(0xFFFFFFFF);

const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const TextStyle kBodyText =
TextStyle(fontSize: 15, color: Color(0xff2b83ba), height: 1.5);

const TextStyle kBodyText1 =
TextStyle(fontSize: 15, color: Colors.white, height: 1.5);

const Color kWhite = Colors.white;
const Color kBlue = Color(0xff5663ff);
const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kRegExpEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
const String kRegExpPhone = "(\\+[0-9]+[\\- \\.]*)?(\\([0-9]+\\)[\\- \\.]*)?" +
    "([0-9][0-9\\- \\.]+[0-9])";

const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";

final otpInputDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
void showErrorDialog(BuildContext context, String message) {
  // set up the AlertDialog
  final CupertinoAlertDialog alert = CupertinoAlertDialog(
    title: const Text('Error'),
    content: Text('\n$message'),
    actions: <Widget>[
      CupertinoDialogAction(
        isDefaultAction: true,
        child: const Text('Yes'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      )
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );


}
