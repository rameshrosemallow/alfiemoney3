
import 'dart:convert';
import 'dart:io';

import 'package:creditscore/Apiservice/Responce/ProfiledetailsResponce.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'package:creditscore/Screen/profile/profile_contract.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;

import '../Home.dart';


class Profiledata extends StatefulWidget {
  const Profiledata({Key key,this.token,this.userId}) : super(key: key);
  final String token;
  final String userId;
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends BaseState<Profiledata> implements ProfileView{
  File _image;

  ProfilePresenterImpl _mPresenter;
  String datee_time;
  String datee_time1;
  TextEditingController _userNameController=TextEditingController();
  TextEditingController _userlastNameController=TextEditingController();
  TextEditingController _dateofbirthController = new TextEditingController();
  TextEditingController _icnumber = new TextEditingController();
  TextEditingController _addressController=TextEditingController();
  TextEditingController _addressController1=TextEditingController();
  TextEditingController _cityname=TextEditingController();
  TextEditingController _zipcode=TextEditingController();
  TextEditingController _mobilenumber = new TextEditingController();
  TextEditingController _emailController=TextEditingController();
  TextEditingController  _passwordController=TextEditingController();
  TextEditingController _confirmPasswordController=TextEditingController();
  final formGlobalKey = GlobalKey < FormState > ();
  TextEditingController _facebookController=TextEditingController();
  DateTime selectedDate=DateTime.now().subtract(Duration(days: 1));
  bool isLoading = false;
  bool checkValue = false;
  ProgressDialog pr;
  final SignatureController _controller =
  SignatureController(penStrokeWidth: 2, penColor: Colors.white);
  bool _isHidePassword = true;

  @override
  void dispose() {
    _userNameController.dispose();
    _userlastNameController.dispose();
    _dateofbirthController.dispose();
    _icnumber.dispose();
    _addressController.dispose();
    _addressController1.dispose();
    _cityname.dispose();
    _zipcode.dispose();
    _mobilenumber.dispose();
    _emailController.dispose();
    _passwordController.dispose();


    super.dispose();
  }

  @override
  void initState() {
    //getPermission();
     _mPresenter=ProfilePresenterImpl(this);
    selectedDate=DateTime.now();
    super.initState();
  }
  void _togglePasswordVisibility() {
    setState(() {
      _isHidePassword = !_isHidePassword;
    });
  }


  Future<void> profileRegister() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    String  token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    print(token);
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
    //DateTime input = _dateofbirthController.text as DateTime;

    final body = {
      'firstName':_userNameController.text.toString().trim(),
      'lastName':_userlastNameController.text.toString().trim(),
      'icNumber':_icnumber.text,
      'dob':  _dateofbirthController.text,
      'address1':_addressController.text.toString().trim(),
      'address2':_addressController1.text.toString().trim(),
      'city':_cityname.text.toString().trim(),
      'zipCode':_zipcode.text,
      'email':_emailController.text.toString().trim(),
      'facebookId':_facebookController.text.toString().trim()};
    //final json = '{"firstName":${_userNameController.text.toString().trim()}, "lastName": ${_userlastNameController.text.toString().trim()}}';
    print(json.encode(body));



    var response = await http.put(Uri.parse(APIS.profiledata+widget.userId), headers: {
    "Content-type": "application/json",
    "Authorization": widget.token}, body: json.encode(body));
    print(response.headers);
    try {
      if (response.statusCode == 200) {
        pr.hide();
        var responseJSON = json.decode(response.body);
        Profiledetails  registerusers_responce = Profiledetails.fromJson(responseJSON);
        print(responseJSON);
        int mobile = registerusers_responce.mobile;

       /* await PreferenceManager.sharedInstance.putInt(
            Keys.MOBILE_NUM.toString(),registerusers_responce.mobile);*/
       /* preferences.setString(Constants.firstName,_userNameController.text);
        preferences.setString(Constants.lastName,_userlastNameController.text);
        preferences.setInt(Constants.icNumbe,int.parse(_icnumber.text));
        preferences.setString(Constants.dob,_dateofbirthController.text);
        preferences.setString(Constants.address1,_addressController.text);
        preferences.setString(Constants.emailId,_emailController.text);*/

        String message = registerusers_responce.id;
        Fluttertoast.showToast(
            msg:"Welcome "+_userNameController.text ,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Rmlightblue,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
        return responseJSON;
      }else if (response.statusCode == 401) {
        print('ramesh' + response.body);
        setState(()  {

          var responseJSON = json.decode(response.body);
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
      }else{
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }

  }


  void getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.phone,
      Permission.sensors,
      Permission.storage,
      Permission.microphone,
      Permission.contacts,
      Permission.sms,

    ].request();
  }
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1600, 8),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.black,
                surface: Colors.white,
                onSecondary:Colors.white ,
                onSurface: Colors.black,
                background: Colors.black

              ),
              //dialogBackgroundColor: Color(0xfffe1705),
              dialogBackgroundColor: Rmlightblue,
            ),
            child: child,
          );
        });

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        datee_time=DateFormat('MM-dd-yyyy').format(picked);
        _dateofbirthController.text = datee_time;
        datee_time1=DateFormat('yyMMdd').format(picked);
        print("DATEEEE" + datee_time);
        _icnumber.text= datee_time1;
      });
  }
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Rmblue,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                    leading: new Icon(Icons.photo_camera, color: Colors.white),
                    title: new Text('Camera',
                        style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      title: new Text(
                        'Photo Library',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),

                ],
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: kCommonBackgroundColor,
          systemNavigationBarIconBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.dark,
        ),
        child: Container(
            color: Rmlightblue,
            child: SafeArea(child:Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                brightness: Brightness.light,
                leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: Text(
                  "Profile Details",
                  style: TextStyle(
                    color: Rmlightblue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),

              ),
              body:Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  SafeArea(
                    child: isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : SingleChildScrollView(
                        child: Form(
                          key: formGlobalKey,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 1.0,
                                  ),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 50,
                                    height:50,
                                  ),
                                ),
                              ),
                              /* Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
        child:Text(" Profile Details:",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),),*/

                              Container(
                                height: MediaQuery.of(context).size.height/1.5,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(children: [
                                      buildTextFormField(
                                        controller: _userNameController,
                                        hint:"First name",
                                        focus: true,
                                        inputType: TextInputType.text,
                                        validation:"Enter First name",
                                        icon: Icon(
                                          Icons.account_circle,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),
                                      buildTextFormField(
                                        controller: _userlastNameController,
                                        hint:"Last name",
                                        validation:"Enter Last name",
                                        inputType: TextInputType.text,
                                        icon: Icon(
                                          Icons.account_circle,
                                          color: Colors.indigo,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                        child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),child:TextFormField(
                                          textAlign: TextAlign.left,
                                          textInputAction: TextInputAction.next,
                                          onTap: (){
                                            setState(() {
                                              _selectDate1(context);
                                            });
                                          },
                                          controller: _dateofbirthController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Select your DOB";
                                            }

                                            return null;
                                          },
                                          style: TextStyle(
                                            color: kSecondaryTextColor,
                                            fontSize: 14.0,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w400,
                                          ),

                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 16.0,
                                            ),


                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: IconButton(
                                                icon: Icon(Icons.date_range,color:Colors.purple ,),
                                                onPressed: (){

                                                },
                                              ), // icon is 48px widget.
                                            ),
                                            hintText: 'DOB e.g dd-mm-yyyy',
                                            hintStyle: TextStyle(fontSize: 14.0,color: Colors.grey),

                                          ),
                                        ),),),),
                                      /* buildTextFormField(
                      controller: _dateofbirthController,
                      hint: "Date of birth",
                      inputType: TextInputType.text,
                      icon: Icon(
                        Icons.date_range,
                        color: Colors.purple,
                      ),
                    ),*/
                                      buildTextFormField(
                                        controller: _icnumber,
                                        hint:"IC Number",
                                        inputType: TextInputType.text,
                                        validation:"Enter IC number",
                                        icon: Icon(
                                          Icons.confirmation_num,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),
                                      // Padding(padding: EdgeInsets.symmetric(vertical: 10,horizontal: 40),child: _buildRadios(),),
                                      buildTextFormField(
                                        controller: _addressController,
                                        hint:"Address",
                                        inputType: TextInputType.text,
                                        validation:"Enter Address1",
                                        icon: Icon(
                                          Icons.location_on,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),


                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                        child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),child:TextFormField(
                                          textAlign: TextAlign.left,
                                          textInputAction: TextInputAction.next,

                                          controller: _addressController1,

                                          style: TextStyle(
                                            color: kSecondaryTextColor,
                                            fontSize: 14.0,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w400,
                                          ),

                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 16.0,
                                            ),


                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: IconButton(
                                                icon: Icon(Icons.location_on,color:Colors.green ,),
                                                onPressed: (){

                                                },
                                              ), // icon is 48px widget.
                                            ),
                                            hintText: 'Address 2',
                                            hintStyle: TextStyle(fontSize: 14.0,color: Colors.grey),

                                          ),
                                        ),),),),

                                      /*buildTextFormField(
                                        controller: _addressController1,
                                        hint:"Address 2",
                                        validation:"Enter Address2",
                                        inputType: TextInputType.text,
                                        icon: Icon(
                                          Icons.add_location_rounded,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),*/
                                      buildTextFormField(
                                        controller: _cityname,
                                        hint:"City Name",
                                        inputType: TextInputType.text,
                                        validation:"Enter City Name",
                                        icon: Icon(
                                          Icons.location_city,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),
                                      buildTextFormField(
                                        controller: _zipcode,
                                        hint:"Zip code",
                                        maxLength: 5,
                                        validation:"Enter Zip code",
                                        inputType: TextInputType.text,
                                        icon: Icon(
                                          Icons.location_city,
                                          color: Color(0xFFFEB71E),
                                        ),
                                      ),
                                      /*buildTextFormField(
                        controller: _mobilenumber,
                        hint:"Mobile number",
                        validation:"Enter Mobile number",
                        maxLength:10,
                        inputType: TextInputType.number,
                        icon: Icon(
                          Icons.phone_android,
                          color: Color(0xFFFEB71E),
                        ),
                      ),*/
                                      buildTextFormField(
                                        controller: _emailController,
                                        hint: "Email Id",
                                        validation:"Enter Email Id",
                                        inputType: TextInputType.emailAddress,
                                        icon: Icon(
                                          Icons.email,
                                          color: Rmblue,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                                        child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0,
                                        ),child:TextFormField(
                                          textAlign: TextAlign.left,
                                          textInputAction: TextInputAction.next,

                                          controller: _facebookController,

                                          style: TextStyle(
                                            color: kSecondaryTextColor,
                                            fontSize: 14.0,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.w400,
                                          ),

                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                              top: 16.0,
                                            ),


                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            suffixIcon: Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: IconButton(
                                                icon: Icon(FontAwesomeIcons.facebook,color:Rmblue ,),
                                                onPressed: (){

                                                },
                                              ), // icon is 48px widget.
                                            ),
                                            hintText: 'Facebook Id',
                                            hintStyle: TextStyle(fontSize: 14.0,color: Colors.grey),

                                          ),
                                        ),),),),
                                      /*buildTextFormField(
                                        controller: _facebookController,
                                        hint:"Facebook Id",
                                        validation:"Enter Facebook Id",
                                        inputType: TextInputType.text,
                                        icon: Icon(
                                          FontAwesomeIcons.facebook,
                                          color: Rmblue,
                                        ),
                                      ),*/

                                    ],)),),

                              /*  Padding(
            padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 0.0),
            child: FormField<bool>(

              builder: (state) {
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Checkbox(
                            value: checkValue,
                            onChanged: (value) {
                              setState(() {
//save checkbox value to variable that store terms and notify form that state changed
                                checkValue = value;
                                state.didChange(value);
                              });
                            }),
                        GestureDetector(child:Text('Accept T & C'),onTap: (){
setState(() {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => Termsandcondition()));

});
                        },), SizedBox(width: 20,),
                        GestureDetector(child: Text("Click here",style: TextStyle(color: Rmblue),),onTap: (){
                          setState(() {


                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => Termsandcondition()));


                          });
                        },)
                      ],
                    ),
//display error in matching theme
                    Text(
                      state.errorText ?? '',
                      style: TextStyle(
                        color: Theme.of(context).errorColor,
                      ),
                    )
                  ],
                );
              },
//output from validation will be displayed in state.errorText (above)
              validator: (value) {
                if (!checkValue) {
                  return 'You need to Accept T & C';
                } else {
                  return null;
                }
              },
            )),*/
                              SizedBox(height: 20,),

                              Container(
                                height: 50.0,
                                alignment: Alignment.center,
                                child: RaisedButton(
                                  onPressed: () {
                                   // submitBtnDidTapped();
                                   /* if(formGlobalKey.currentState.validate()){
                                      ///profileRegister();
                                      profileRegister();
                                    }*/
                                  //  makePutRequest();
                                   setState(() {
                                     submitBtnDidTapped();
                                    // profileRegister();
                                   });

                                  },
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                  padding: EdgeInsets.all(0.0),
                                  color: Rmpick,
                                  splashColor: Rmpick,
                                  child: Ink(
                                    decoration: BoxDecoration(

                                      //color: Color(0xff0066ff),
                                        gradient: LinearGradient(
                                          colors: [
                                            Rmlightblue,
                                            Rmpick,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(20.0)
                                    ),
                                    child: Container(
                                      constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                                      alignment: Alignment.center,
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Spacer(),
                                          Text(
                                            "Submit",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17.0,
                                            ),
                                          ),
                                          Spacer(),
                                          Card(
                                            //color: Color(0xCDA3C5EC),
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(35.0)),
                                            child: SizedBox(
                                              width: 35.0,
                                              height: 35.0,
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                color: Rmpick,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => LoginPage()));
                                  },
                                  child: Text(
                                    "Already have an account? Login !",
                                    style: TextStyle(
                                      color: kSecondaryTextColor,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),)
                    ),
                  ),
                ],
              ),
            ),))
    );
  }

  Widget buildTextFormField({
    TextEditingController controller,
    String hint,
    TextInputType inputType,
    int maxLength,
    Icon icon,
    String validation,
    bool focus,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
            autofocus: focus != null ? focus : false,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              color: kSecondaryTextColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
            keyboardType: inputType,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                top: 16.0,
              ),
              hintStyle: TextStyle(
                color: kSecondaryTextColor,
              ),
              hintText: hint,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
              ),
              suffixIcon: icon != null ? icon : SizedBox.shrink(),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return validation;
              }
              if(maxLength==10){
                if (value.length != 10)
                  return 'Mobile Number must be of 10 digit';
              }


              return null;
            },
            controller: controller,
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton({
    VoidCallback onPressCallback,
    Color backgroundColor,
    String title,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 16.0),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
          padding: const EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: onPressCallback,
          color: backgroundColor,
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void registrationDidFailed(String invalidFields) {
    // TODO: implement registrationDidFailed
  }

  @override
  void registrationDidSucceed() {
    // TODO: implement registrationDidSucceed
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  void submitBtnDidTapped() {
    // TODO: implement submitBtnDidTapped
    if(formGlobalKey.currentState.validate()){
     // int icnum=int.parse(_icnumber.text);
      //'dob':'${_dateofbirthController.text}'

      print("DATE "+ datee_time);
      _mPresenter.doRegistration(widget.userId,
          { 'firstName':_userNameController.text.toString().trim(),
            'lastName':_userlastNameController.text.toString().trim(),
            'icNumber':_icnumber.text.toString(),
            'dob':datee_time.toString(),
            'address1':_addressController.text.toString().trim(),
            'address2':_addressController1.text.toString().trim(),
            'city':_cityname.text.toString().trim(),
            'zipCode':_zipcode.text.toString().trim(),
            'email':_emailController.text.toString().trim(),
            'facebookId':_facebookController.text.toString().trim()
          });

      // 'icNumber':icnum,'dob':_dateofbirthController.text.toString().trim(),'address1':_addressController.text.toString().trim(),'city':_cityname.text.toString().trim(),'zipCode':_zipcode.text.toString().trim(),'email':_emailController.text.toString().trim()
    }

  }



/* bool _validateUserData() {
    RegExp regExpEmail = RegExp(kRegExpEmail);
    RegExp regExpPhone = RegExp(kRegExpPhone);


    if (_nameController.text.trim().isEmpty &&
        _userNameController.text.trim().isEmpty &&
        _emailController.text.trim().isEmpty &&
        _phoneController.text.trim().isEmpty &&
        _passwordController.text.trim().isEmpty &&
        _confirmPasswordController.text.trim().isEmpty) {
      ToastUtil.show(getString('registration_please_fill_up_all_the_fields'));
      return false;
    } else if (_nameController.text.trim().isEmpty) {
      ToastUtil.show(getString('name_is_required'));
      return false;
    } else if (_userNameController.text.trim().isEmpty) {
      ToastUtil.show(getString('username_is_required'));
      return false;
    } else if (_userNameController.text.trim().contains(" ")) {
      ToastUtil.show(getString('registration_username_space_error'));
      return false;
    } else if (_emailController.text.trim().isEmpty) {
      ToastUtil.show(getString('email_is_required'));
      return false;
    } else if (!regExpEmail.hasMatch(_emailController.text.trim())) {
      ToastUtil.show(getString('registration_please_enter_a_valid_email'));
      return false;
    } else if (_phoneController.text.trim().isEmpty) {
      ToastUtil.show(getString('phone_is_required'));
      return false;
    } else if (!regExpPhone.hasMatch(_phoneController.text.trim())) {
      ToastUtil.show(getString('registration_please_enter_a_valid_phone'));
      return false;
    } else if (_passwordController.text.trim().isEmpty) {
      ToastUtil.show(getString('password_is_required'));
      return false;
    } else if (_passwordController.text.trim().length < 8) {
      ToastUtil.show(getString('registration_passwords_should_have_length'));
      return false;
    } else if (_confirmPasswordController.text.trim().isEmpty) {
      ToastUtil.show(getString('confirm_password_is_required'));
      return false;
    } else if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      ToastUtil.show(getString('registration_your_passwords_do_not_match'));
      return false;
    } else {
      return true;
    }
  }*/


}
