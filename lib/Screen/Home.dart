
import 'dart:convert';
import 'dart:io';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Apiservice/Responce/UserdetailsResponce.dart';
import 'package:creditscore/Screen/userprofile/Userprofile.dart';
import 'package:http/http.dart' as http;
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Common/balance_card.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/title_text.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoanDetails.dart';
import 'History.dart';
import 'Landingpage.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'MonthlyStatement.dart';
import 'Notificationlist_view.dart';
import 'Profilepage.dart';
import 'register/Register.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  int _selectedDestination = 0;
  PageController _pageController;
  int _currentIndex1 = 0;
  int mobileNumber = 0;
  String emailId = "";
  String address1 = "";
  String cityName = "";
  String userId = "";
  String dob = "";
  String firstName = "";
  String lastName = "";
  ProgressDialog pr;
  final List<Widget> _children = [
    Homescreen(),
   Container(child: Center(child: Text("Dashboard"),),),
    Container(child: Center(child: Text("Notification"),),),
  ];
/*
  final List<Widget> _children = [
    Homescreen(),
    LoanDetails(),
    NotificationScreen(),
  ];*/
  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }

  Widget createDrawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,

        child: Stack(children: <Widget>[
          GestureDetector(
              child: CircleAvatar(
                radius: 30,
                backgroundColor:
                Color(0xFF550161),
                foregroundColor:
                Color(0xFF550161),

              ),
              onTap: () {

              }),
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Ramesh",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    //Getuserdata();
    getUserdata();
    _loadProfileDataFromSF();

    super.initState();
    _pageController = PageController();
  }


  Future<void> getDetails() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = await PreferenceManager.sharedInstance.getString(
        Keys.USER_ID.toString());
    String token = await PreferenceManager.sharedInstance.getString(
        Keys.ACCESS_TOKEN.toString());
    print(token);
    var response = await http.get(Uri.parse(APIS.getuser + userId), headers: {
      "Authorization": token,
    },);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);


        Profiledetails registrationResponse = Profiledetails.fromJson(
            decodedData);
        print("getuserdetails" + registrationResponse.email);
        return decodedData;
      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }
  }

  /*Getuserdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    mobileNumber =
    await PreferenceManager.sharedInstance.getInt(Keys.MOBILE_NUM.toString());
    setState(() {
      firstName = preferences.getString(Constants.firstName);
    });
    emailId = preferences.getString(Constants.emailId);
    address1 = preferences.getString(Constants.address1);

    cityName = cityName = preferences.getString(Constants.cityName);
    userId =
    await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    dob = preferences.getString(Constants.dob);
    firstName = preferences.getString(Constants.firstName);

    lastName = preferences.getString(Constants.lastName);
  }*/
  void _loadProfileDataFromSF() async {
    Map<String, dynamic> map = await PreferenceManager.sharedInstance
        .getMap(Keys.PROFILE_MAP.toString());
    setState(() {
      firstName=map[ProfileKeys.FIRSTNAME_.toString()];
     /* _userlastNameController.text=map[ProfileKeys.LASTNAME_.toString()];
      _icnumber.text=map[ProfileKeys.ICNUM_.toString()];
      _addressController.text=map[ProfileKeys.ADDRESS1_.toString()];
      _addressController1.text=map[ProfileKeys.ADDRESS2_.toString()];
      _dateofbirthController.text=formatter.format(DateTime.parse(map[ProfileKeys.DOB_.toString()]));
      _cityname.text=map[ProfileKeys.CITY_.toString()];
      _zipcode.text=map[ProfileKeys.ZIPCODE_.toString()];
      _emailController.text=map[ProfileKeys.EMAIL_.toString()];
      _fbid.text=map[ProfileKeys.FACEBOOK_.toString()];*/
    });

    //_mobilenumber.text="${map[ProfileKeys.MOBILE_.toString()]}";

  }
  Future getUserdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userId = await PreferenceManager.sharedInstance.getString(
        Keys.USER_ID.toString());
    String token = await PreferenceManager.sharedInstance.getString(
        Keys.ACCESS_TOKEN.toString());
    print(token);

    var response = await http.get(Uri.parse(APIS.getuser + userId), headers: {
      "Authorization": token,
    },);
    try {
      if (response.statusCode == 200) {
        String data = response.body;

         print("strttttttttt");
          var decodedData = jsonDecode(data);
          Profiledetails registrationResponse = Profiledetails.fromJson(decodedData);
          preferences.setString(Constants.firstName,decodedData["firstName"]);
          preferences.setString(Constants.lastName,decodedData["lastName"]);
          preferences.setString(Constants.icNumbe,decodedData["icNumber"]);
          preferences.setString(Constants.address1,decodedData["address1"]);
          preferences.setString(Constants.emailId,decodedData["email"]);
          preferences.setString(Constants.docSign,decodedData["docSign"]);


          Map<String, dynamic> map = Map();
          map[ProfileKeys.FIRSTNAME_.toString()] = registrationResponse.firstName;
          map[ProfileKeys.LASTNAME_.toString()] = registrationResponse.lastName;
          map[ProfileKeys.ICNUM_.toString()] = registrationResponse.icNumber;
          map[ProfileKeys.ZIPCODE_.toString()] = registrationResponse.zipCode;
          map[ProfileKeys.MOBILE_.toString()] = registrationResponse.mobile;
          map[ProfileKeys.EMAIL_.toString()] = registrationResponse.email;
          map[ProfileKeys.DOB_.toString()] = registrationResponse.dob;
          map[ProfileKeys.ADDRESS1_.toString()] = registrationResponse.address1;
          map[ProfileKeys.ADDRESS2_.toString()] = registrationResponse.address2;
          map[ProfileKeys.FACEBOOK_.toString()] = registrationResponse.facebookId;



        await PreferenceManager.sharedInstance
            .putMap(Keys.PROFILE_MAP.toString(), map);
        print(data);

        print("endttttttttt");
       /* pr.hide();*/
      }
    } catch (e) {
      getUserdata();
    }
    /*try {
       else {
        pr.hide();
        print("failad");
        return 'failed';
      }
    } catch (e) {
      pr.hide();
      return 'failed';
    }*/

  }


  void onTabTapped(int index) {
    setState(() {
      _currentIndex1 = index;
    });
  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => exit(0),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
      key: _scaffoldKey,

      appBar: AppBar(
          //title: Text("Alternate Credit Score", style: TextStyle(color: Colors.white),),
          backgroundColor: Rmlightblue,actions: [
        Center(
          child: Neumorphic(
              padding: EdgeInsets.all(1),
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.circle(),
                depth: NeumorphicTheme.embossDepth(context),
              ),
              child: CircleAvatar(
                radius: 20.0,
                backgroundImage: AssetImage('assets/images/user.png'),
                backgroundColor: Colors.white,
              )
          ),
        ),
          SizedBox(width: 10,),
        ],),
          floatingActionButton: new FloatingActionButton(
              elevation: 0.0,
              child: new Icon(Icons.exit_to_app),
              backgroundColor: Colors.red,
              onPressed: (){
                setState(() {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                });
              }
          ),
      drawer:Drawer(
        child: Column(

          children: <Widget>[

            DrawerHeader(
              decoration: BoxDecoration(
                color: Rmlightblue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Rmyellow,
                      radius: 45,
                      child: CircleAvatar(
                        backgroundColor: Colors.greenAccent[100],
                        radius: 40,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/user.png'),

                          radius: 100,

                        ), //CircleAvatar
                      ), //CircleAvatar
                    ), //CircleAvatar
                  ),
                 Center(child: Text(firstName??"",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),)
                 // Text('Rameshrp16@gmail.com',style: TextStyle(color: Colors.white)),
                ],
              ),
            ),

            ListTile(
              title: Row(children: [Icon(Icons.home_outlined),SizedBox(width: 10,),Text('Home'),],),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
            ListTile(
              title: Row(children: [Icon(Icons.person_sharp),SizedBox(width: 10,),Text('Profile'),],),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => UserProfile()));
              },
            ),
            /*ListTile(
              title: Row(children: [Icon(Icons.stacked_bar_chart),SizedBox(width: 10,),Text('Monthly Statement'),],),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Monthlystatement()));
              },
            ),*/

            Spacer(),
            Container(
              height: size.height * 0.08,
              width: size.width * 0.5,

              alignment: Alignment.center,

              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                padding: EdgeInsets.all(0.0),
                color: Rmpick,
                splashColor: Rmpick,
                elevation: 10,
                child: Ink(
                  decoration: BoxDecoration(
                    // color: Color(0xff0066ff),
                      gradient: LinearGradient(
                        colors: [
                          Rmlightblue,
                          Rmlightblue,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Container(
                          width: 50.0,
                          height: 150.0,
                          decoration: new BoxDecoration(

                            /* gradient: LinearGradient(
                            colors: [
                              Rmlightblue,
                              Rmpick,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),*/
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),

                            ),
                            border: new Border.all(color: Rmlightblue, width: 2.0),
                            // borderRadius: new BorderRadius.circular(10.0),
                          ),
                          child: new Center(child: new Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          "Logout",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                          ),
                        ),
                        Spacer(),

                      ],
                    ),
                  ),
                ),
              ),
            ),


            SizedBox(height: 10,)
          ],
        ),
      ),

      body: _children[_currentIndex1], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,

        selectedItemColor: Rmlightblue,//
        backgroundColor: Colors.white,// new
        currentIndex: _currentIndex1, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),

            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Dashboard'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_sharp),
              title: Text('Notification')
          )
        ],
      ),)
    );
  }
}
