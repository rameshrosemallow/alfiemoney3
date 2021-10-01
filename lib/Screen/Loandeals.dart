import 'dart:convert';
import 'dart:math';

import 'package:creditscore/Apiservice/Responce/ApplyloanResponce.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Model/Radiobutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Home.dart';
import 'Landingpage.dart';
import 'Loan_contract.dart';
import 'register/Register.dart';

class Loanprocess extends StatelessWidget {
  Loanprocess(
      {Key key,
        this.loanmax})
      : super(key: key);
  final double loanmax;

  @override
  Widget build(BuildContext context) {
    return NeumorphicTheme(
      theme: NeumorphicThemeData(accentColor: Rmblue,baseColor: Colors.white,depth: 8,
        intensity: 0.65,),

      themeMode: ThemeMode.light,
      child: Material(
        child: NeumorphicBackground(
          child: Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),child:Loandetails(loanmax:loanmax)),
        ),
      ),
    );
  }
}
class Loandetails extends StatefulWidget {
  Loandetails(
      {Key key,
        this.loanmax})
      : super(key: key);
  final double loanmax;

  @override
  _LoandetailsState createState() => _LoandetailsState();
}

class _LoandetailsState extends State<Loandetails> {
  double _loanAmount = 100;
  double _months=2;
  double _interestRate=5;
  double _upperValue = 180;
  ProgressDialog pr;
  var _emiResult="";
  bool redmi=false;
  var totalamount;
  String _persentage="";
  double totalamount1,a,b;
  String _miResult = "";
  String _interestAmount = "";
  String _tcResult = "";
  final TextEditingController _principalAmount = TextEditingController(text: "0");
  final TextEditingController _interestRate1 = TextEditingController(text: "0");
  final TextEditingController _tenure = TextEditingController(text: "0");
  int id = 1;
  String productType = 'Regular';
  List<Radiobuttonlist> nList = [
    Radiobuttonlist(
      index: 1,
      number: "Regular",
    ),
    Radiobuttonlist(
      index: 2,
      number: "Islamic",
    ),

  ];
  Map<String, double> dataMap = {
    "Total": 2.0,
    "Intrest": 3,
  };
  List<Color> colorList = [
    Rmblue,
    Colors.redAccent
  ];

  bool _showCenterText = true;
  double _ringStrokeWidth = 32;

  bool _showLegendsInRow = false;
  bool _showLegends = true;

  bool _showChartValueBackground = true;
  bool _showChartValues = true;
  bool _showChartValuesInPercentage = false;
  bool _showChartValuesOutside = false;


  int key = 0;
  bool offerpage=true;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    dataMap = {
      "Total": _loanAmount,
      "Intrest": _interestRate,
    };
    _handleCalculation();
  }





  void _handleCalculation11() {
    double A = 0.0;
    int P = _loanAmount.toInt().round();
    double r = _interestRate.toInt().round() / 12 / 100;
    int n = _months.toInt().round();
    A = (P * r * pow((1+r), n) / ( pow((1+r),n) -1));
    _persentage = ((r / P) * 100).toString();
    double total = (P + (P * n * r) / 100);
    _emiResult = total.toStringAsFixed(2);
    setState(() {
print(_persentage);
    });
  }
  void _handleCalculation2() {
    double A = 0.0;
    var P = _loanAmount.toInt();
    double r = _interestRate.toInt() / 12 / 100;
    int n = _months.toInt();

    A = (P * r * pow((1+r), n) / ( pow((1+r),n) -1));

    _emiResult = A.toStringAsFixed(2);

    setState(() {
      totalamount=A+P;
     /* a = double.parse(A.toString());
      b = double.parse(n.toString());
      totalamount1=Constants.multiply(a,b);*/
    });
  }
  void _handleCalculation() {
    double A = 0.0;
    double I = 0.0;
    double T = 0.0;
    double P = double.parse(_loanAmount.toString());
    double r = double.parse(_interestRate.toString()) / 12 / 100;
    int n = _months.toInt();

    A = (P * r * pow((1 + r), n) / (pow((1 + r), n) - 1));
    T = (A * n);
    I = (T - P);

    NumberFormat format = NumberFormat('#,###,###.00');
    setState(() {
      _miResult = format.format(A);
      _interestAmount = format.format(I);
      _tcResult = format.format(T);
    });
  }
  String calculate(){
    double principle = double.parse(_loanAmount.toString());
    double amount = double.parse(_interestRate.toString());
    double rate = double.parse(_months.toString());
    double total = (principle + (principle * rate * amount) / 100);
    String result = '$total ';
    return result;
  }
  Future bankDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();


     pr = new ProgressDialog(
       context,
       type: ProgressDialogType.Normal,
       isDismissible: true,
       showLogs: true,
     );
     pr.style(
         message: 'Loading...',
         borderRadius: 10.0,
         backgroundColor: Color(0xffE5E5E5),
         progressWidget: CircularProgressIndicator(),
         elevation: 10.0,
         insetAnimCurve: Curves.bounceInOut,
         progress: 1.0,
         maxProgress: 100.0,
         progressTextStyle: TextStyle(
             color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
         messageTextStyle: TextStyle(
             color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
     pr.show();

     var body = jsonEncode({
       'loanAmount': _loanAmount,
       'interestRate': double.parse(_interestAmount),
       'loanFees': Constants.loanFees,
       'tenure':_months.toString(),
       'productType': productType
     });

     print(body);
    String token = await PreferenceManager.sharedInstance
        .getString(Keys.ACCESS_TOKEN.toString());

     print(token);
     var response = await http.post(
         APIS.applyloan, headers: {
       "Authorization":token,
       "Content-Type":"application/json"
     }, body: body);

     if (response.statusCode == 200) {
       print('ramesh' + response.body);
       setState(() {
         pr.hide();
         var responseJSON = json.decode(response.body);
         ApplyloanResponce registerusers_responce = ApplyloanResponce
             .fromJson(responseJSON);
         print(responseJSON);

         String loanId = registerusers_responce.id;
         String Status = registerusers_responce.loanStatus;
         preferences.setString(Constants.loanStatus, registerusers_responce.loanStatus);
         preferences.setString(Constants.loanId, registerusers_responce.id);
         preferences.setString(Constants.productType, registerusers_responce.productType);
         preferences.setString(Constants.tenureMonth, registerusers_responce.tenure);
         preferences.setInt(Constants.loanFeess, registerusers_responce.loanFees);
         preferences.setInt(Constants.loanAmount, registerusers_responce.loanAmount);
         preferences.setDouble(Constants.interestRate, registerusers_responce.interestRate);

        /* Fluttertoast.showToast(
             msg: loanId,
             timeInSecForIosWeb: 1,
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             backgroundColor: Rmlightblue,
             textColor: Colors.white,
             fontSize: 16.0);*/
         Navigator.push(
             context, MaterialPageRoute(builder: (context) => Loancontract(loainId: loanId,)));


       });
     }
     if (response.statusCode == 401) {
       print('ramesh' + response.body);
       setState(() {
         var responseJSON = json.decode(response.body);
         //var rest = responseJSON["errors"] as List;
         String message = responseJSON["msg"];
         pr.hide();
         Fluttertoast.showToast(
             msg: message,
             timeInSecForIosWeb: 1,
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             backgroundColor: Colors.red,
             textColor: Colors.white,
             fontSize: 16.0);
       });
     }
    if (response.statusCode == 500) {
      print('ramesh' + response.body);
      setState(() {
        var responseJSON = json.decode(response.body);

        var rest = responseJSON["errors"] as List;
        String message = rest[0]["msg"];
        pr.hide();
        Fluttertoast.showToast(
            msg: message,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.height > 765) {
      redmi = true;

    } else {
      redmi = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
      child: offerpage?new SingleChildScrollView(child:Column(children: [
        SizedBox(height: 10,),
        Align(
            alignment: Alignment.topLeft,
            child:Row(children: [
              IconButton(icon:NeumorphicIcon(
                Icons.arrow_back_ios_outlined,
                style: NeumorphicStyle(color: Rmlightblue,shape: NeumorphicShape.concave, boxShape:
                NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),),
                size: 30,

              ) ,onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },),
              FadeAnimation(1.6,
                  Text("Product Selection", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
              ),

            ],)),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 1.0,
            ),
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height:100,
            ),
          ),
        ),
        Center(child:Text('Selection a Product',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)),
          SizedBox(height: 20,),
         Container(
              height: 200,
              alignment: Alignment.topCenter,
              child:Card(
                elevation: 5,
                margin: EdgeInsets.fromLTRB(20.0, 45.0, 20.0, 0.0),
                child: Column(
                children:
                nList.map((data) => RadioListTile(
                  title: Text("${data.number}"),
                  groupValue: id,
                  value: data.index,
                  onChanged: (val) {

                    setState(() {
                      productType = data.number ;
                      id = data.index;
                      print(productType);
                    });
                  },
                )).toList(),
              ),)
            ),

        SizedBox(height: 20,),
        Container(
          height: 65,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          width: MediaQuery.of(context).size.width,
          child: NeumorphicButton(
              padding: const EdgeInsets.all(18.0),
              onPressed: () {
                setState(() {
                  offerpage=false;
                });

              },
              style: NeumorphicStyle(
                color: Rmlightblue,
                shape: NeumorphicShape.concave,
                boxShape:
                NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
              ),
              child: Center(child:redmi?Text('Next',style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)):Text('Next',style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)) ,)
          ),
        ),
      ],)):SingleChildScrollView(child: Container(
        height: MediaQuery.of(context).size.height,
        child:Column(
        children: [
          SizedBox(height: 10,),
          Align(
              alignment: Alignment.topLeft,
              child:Row(children: [
                IconButton(icon:NeumorphicIcon(
                  Icons.arrow_back_ios_outlined,
                  style: NeumorphicStyle(color: Rmlightblue,shape: NeumorphicShape.concave, boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),),
                  size: 30,

                ) ,onPressed: (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },),

                FadeAnimation(1.6,
                    Text("Apply for Loan", style: TextStyle(color: Rmlightblue, fontSize: 18, fontWeight: FontWeight.bold),)
                ),
              ],)),

          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 1.0,
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 100,
                height:100,
              ),
            ),
          ),
          // SizedBox(height: 10,),
          FadeAnimation(1.6,
              redmi? Text("How much do you want to borrow \nand for how long?", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),):Text("How much do you want to borrow \nand for how long?", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),)
          ),
          SizedBox(height: 10,),
          Container(
            // width: 100,
              height: 50,
              padding: EdgeInsets.all(5),
              child:  FlutterSlider(
                values: [_loanAmount],
                max: widget.loanmax,
                min: 0,

                trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 5,
                  activeTrackBar: BoxDecoration(color: Rmlightblue),
                ),

                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [new BoxShadow(
                          color: Colors.black,
                          blurRadius: 1.0,
                        ),],
                        borderRadius: BorderRadius.circular(25)),
                    padding: EdgeInsets.all(10),
                    child:   new Image.asset(
                      'assets/images/money.png',

                    ),
                  ),
                ),

                rightHandler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    padding: EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                disabled: false,

                onDragging:
                    (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    _loanAmount = lowerValue;


                    _handleCalculation();
                  });
                },
                onDragCompleted:
                    (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    _loanAmount = lowerValue;


                    _handleCalculation();
                  });
                },)

          ),
          SizedBox(height: 10,),
          /*FadeAnimation(1.6,
              Text("Amount"+" : "+"N$_lowerValue", style: TextStyle(color: Colors.grey),)
          ),*/
          FadeAnimation(1.6,
              Text("Amount"+" : "+"N${_loanAmount}", style: TextStyle(color: Colors.grey),)
          ),
          SizedBox(height: 10,),
          Container(
            // width: 100,
              height: 50,
              padding: EdgeInsets.all(5),
              child:  FlutterSlider(
                values: [_months],
                max: 12,
                min: 0,
                trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 5,
                  activeTrackBar: BoxDecoration(color: Rmlightblue),
                ),

                handler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [new BoxShadow(
                          color: Colors.black,
                          blurRadius: 1.0,
                        ),],
                        borderRadius: BorderRadius.circular(25)),
                    padding: EdgeInsets.all(10),
                    child:   new Image.asset(
                      'assets/images/paydate.png',color: Colors.black,

                    ),
                  ),
                ),
                rightHandler: FlutterSliderHandler(
                  decoration: BoxDecoration(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    padding: EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                disabled: false,

                onDragging:
                    (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    _months = lowerValue;


                    _handleCalculation();
                  });
                },
                onDragCompleted:
                    (handlerIndex, lowerValue, upperValue) {
                  setState(() {

                    _months = lowerValue;
                    _handleCalculation();
                  });
                },)

          ),
          SizedBox(height: 10,),
          FadeAnimation(1.6,
              Text("Months"+" : "+"$_months", style: TextStyle(color: Colors.grey),)
          ),

          SizedBox(height: 20,),
          FadeAnimation(1.6,
              redmi?  Text("Equated Monthly Installments(EMI)\n${_miResult}", style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold),textAlign: TextAlign.center,):Text("Equated Monthly Installments(EMI)\n${_miResult}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
          ),
          SizedBox(height: 20,),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child:Neumorphic(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
              style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape:
                NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeAnimation(1.6,
                          Text("INTEREST", style: TextStyle(color: Rmlightblue, fontSize: 15, fontWeight: FontWeight.bold),)
                      ),
                      SizedBox(height: 10,),
                      FadeAnimation(1.6,
                          Text("N${_interestAmount}"+"(5%)", style: TextStyle(color: Colors.grey),)
                      ),
                    ],),

                  Spacer(),
                  Container(
                    height: 40,
                    width: 1,
                    color: Colors.black,
                  ),
                  Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FadeAnimation(1.6,
                          Text("TOTAL DUE", style: TextStyle(color: Rmlightblue, fontSize: 15, fontWeight: FontWeight.bold),)
                      ),
                      SizedBox(height: 10,),
                      FadeAnimation(1.6,
                          Text("N${_tcResult}", style: TextStyle(color: Colors.grey),)
                      ),
                    ],)

                ],
              ),
            ) ,),

          Container(
            height: 65,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            width: MediaQuery.of(context).size.width,
            child: NeumorphicButton(
                padding: const EdgeInsets.all(18.0),

                onPressed: () {

                  setState(() {
                    // offerpage=true;
                    bankDetails();

                  });
                  /* Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Loancontract()));*/
                },
                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  color: Rmlightblue,
                  boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                ),
                child: Center(child:redmi?Text('Get my offer',style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)):Text('Get my offer',style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)) ,)
            ),
          ),
        ],
      ) ,),),)
    ,
      floatingActionButton: new FloatingActionButton(
          elevation: 5.0,
          child: new Icon(Icons.exit_to_app),
          backgroundColor: Colors.red,
          onPressed: (){
            setState(() {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RegistrationPage()));
            });
          }
      ),
    );
  }
}
