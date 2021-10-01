
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Apiservice/base/BaseState.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/CountDown.dart';
import 'package:creditscore/Common/Country_Code.dart';
import 'package:creditscore/Common/Sharedprefrance_data.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:creditscore/Common/size_config.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Screen/forgotPassword/Forgot.dart';
import 'package:creditscore/Screen/login/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../OtpScreen.dart';
import 'registration_contract.dart';
import 'package:http/http.dart' as http;
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends BaseState<RegistrationPage>
    implements RegistrationView {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();


  RegistrationPresenterImpl _mPresenter;


  TextEditingController _phonenumber=new TextEditingController();
  SharedPreferences sharedPreferences;
  bool isLoading = false;
  bool checkValue = false;
  bool condition = false;
  bool codeSent = false;
  FocusNode pin2FocusNode;
  FocusNode pin3FocusNode;
  FocusNode pin4FocusNode;
  FocusNode pin5FocusNode;
  FocusNode pin6FocusNode;
  String countrycode;
  String phoneNumber = "+91";
  ProgressDialog pr;
  final formGlobalKey = GlobalKey < FormState > ();
  File _image;
  String termsCondition="";
  @override
  void initState() {

    _mPresenter = RegistrationPresenterImpl(this);
    //_mPresenter.getTerms();
    getterms();
    super.initState();
  }

  Future<void> getterms() async {
     termsCondition = await PreferenceManager.sharedInstance
        .getString(Keys.TC.toString());
    print(termsCondition);
    if (termsCondition.isEmpty) {
      var response = await http.get(Uri.parse(APIS.terms),);
      if (response.statusCode == 200) {
        print('ramesh' + response.body);
        var responseJSON = json.decode(response.body);
        termsCondition = responseJSON;
        print(responseJSON);
        await PreferenceManager.sharedInstance.putString(
            Keys.TC.toString(), responseJSON);

      }
      else {
        throw Exception('Failed to load post');
      }
    }
  }


  @override
  void dispose() {
    _phonenumber.dispose();
    super.dispose();
  }





  void nextField(String value, FocusNode focusNode) {
    if (value.length == 1) {
      focusNode.requestFocus();
    }
  }

  _imgFromCamera() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;

    });
    await PreferenceManager.sharedInstance.putString(
        Keys.SIGN1.toString(), _image.path);
    await PreferenceManager.sharedInstance.putBoolean(
        Keys.SIGN_STATUS.toString(), true);
  }

  _imgFromGallery() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;

    });
    await PreferenceManager.sharedInstance.putString(
        Keys.SIGN1.toString(), _image.path);
    await PreferenceManager.sharedInstance.putBoolean(
        Keys.SIGN_STATUS.toString(), true);
  }
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
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

              ),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,color: Colors.white,),
                      title: new Text('Upload from Gallery',style: TextStyle(color: Colors.white),),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera,color: Colors.white),
                    title: new Text('Capture image & upload',style: TextStyle(color: Colors.white)),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      phoneNumber =  countryCode.toString();
      print(phoneNumber);
    });


  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(Constants.messageExit),
        content: new Text(Constants.messageExit1),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 30),
          new GestureDetector(
            onTap: () => exit(0),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget Conditionpage(){

    return Container(
        color: Rmlightblue,
        child: SafeArea(child:Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              brightness: Brightness.light,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
                onPressed: (){
                  setState(() {
                    condition=false;
                    checkValue=false;
                  });
                },
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text("Terms and conditions",style: TextStyle(fontWeight: FontWeight.bold,color: Rmlightblue),),
            ),
            body: termsCondition==""?Center(child: CircularProgressIndicator(),):SingleChildScrollView(child:Container(padding:EdgeInsets.symmetric(horizontal: 15,vertical: 10),child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(termsCondition??""),
             /*   Text("Consent authorisation"),
                Text("By this consent, I/we understand and agree that:  "),
                Text("I.  You may access private and digital data from my device(s) for the purposes of determining my/our creditworthiness and qualification for specific services provided by Alfie Tech Sdn Bhd."),
                Text("II. You may conduct credit/ trade check including CCRIS checks on me/us and when consent has been given individually, on our  directors, shareholders, guarantors, etc. with any registered Credit Bureaus at any time for as long as I/we have a trade relationship with you or where any dues remain unpaid and outstanding with you, for any one or more of the following purposes:  "),
                Text("   1. Opening of account",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   2. Credit/Account monitoring",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   3. Debt recovery",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   4. Credit/Account evaluation  ",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   5. Credit/Account review  ",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("   6. Legal documentation consequent to a contract or facility granted by you.  ",style: TextStyle(fontWeight: FontWeight.bold),),
                Text("III.  You may disclose any information on my/our conduct of my/our account(s) with you, to any business entity/ies for bona fide trade checking at any time.  I/We am/are also aware and understand that such information will be provided to Alfie Tech Sdn Bhd, who may in turn share such information to subscribers of their service.  "),
                Text("IV.  Where you require any processing of my/our application to be processed by any processing center located outside Malaysia (including your Head Office), I/we hereby give consent to Alfie Tech Sdn Bhd to disclose my/our credit information except CCRIS, to such  locations outside Malaysia.  "),
                Text("V.  Apart from the above, I/we the undersigned do give my/our consent to you and the Alfie Tech Sdn Bhd, to process my/our personal data as  per the PDPA Act."),

*/

                SizedBox(height: 10,),
                Text("Insert Signature ",style: TextStyle(fontWeight: FontWeight.bold),),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(

                      decoration: BoxDecoration(
                        border: Border.all(color: Rmlightblue),

                        borderRadius:BorderRadius.all(Radius.circular(20.0)),
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      child: _image==null?Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ):Image.file(
                        _image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),

                /* Row(children: [
          Text("Signature below: ",style: TextStyle(fontWeight: FontWeight.bold),),
          IconButton(icon: Icon(Icons.brush), onPressed:(){
            setState(() {
              _controller.clear();
            });
          })
        ],),
        Container(
          color: Rmlightblue,
          padding: EdgeInsets.all(5),
          child: Signature(
              width: MediaQuery.of(context).size.width,
              height: 70,
              controller: _controller,
              backgroundColor: Colors.grey),
        ),*/
                /* buildButton(
            onPressCallback: () {
              setState(() {
                Navigator.of(context).pop();

              });
            },
            backgroundColor: appcolor,
            title: "Submit"
        ),
*/
                SizedBox(height: 10,),

                Container(
                  height: 50.0,
                  alignment: Alignment.center,

                  child: RaisedButton(
                    onPressed: () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      setState(() {
                       // Navigator.of(context).pop();

                        if(_image==null){
                          ToastUtil.show("Please select Signature image");
                        }else{

                          preferences.setString("_docSign",_image.path );
                          condition=false;
                          checkValue=true;

                        }
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    padding: EdgeInsets.all(0.0),
                    color: Rmpick,
                    splashColor: Rmpick,
                    elevation: 10,
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
                              "Accept",
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
              ],) ,),))));
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return condition?Conditionpage():Container(
      color: Rmlightblue,
      child: SafeArea(child:WillPopScope(
        onWillPop: _onBackPressed,
        child:Scaffold(
        key: _scaffoldkey,
       backgroundColor: Colors.white,
        body:SingleChildScrollView(child: Form(
          key: formGlobalKey,
          child: Stack(

          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
           Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 1.0,
                        ),
                        child: Image.asset(
                          Constants.developerLogo,
                          width: 100,
                          height:100,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                      child:Text(Constants.welcomeBack,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0, 1.0, 32.0, 1.0),
                      child:Text(Constants.welcomeBack1,
                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,


                        ),

                      ),),

                    SizedBox(height: 20,),

                    buildTextFormField(
                            controller: _phonenumber,
                            hint: "Mobile Number",
                            maxLength: 10,
                            validation: "Enter Mobile number",
                            inputType: TextInputType.phone,
                            icon: Icon(
                              Icons.phone,
                              color: Rmblue,
                            ),
                          ),


                    SizedBox(height: 20,),
                    Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 20.0),
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
                            condition=true;
                            checkValue = value;
                            state.didChange(value);
                          });
                        }),
                    GestureDetector(child:Text('Accept T & C'),onTap: (){
                      setState(() {
                        /*Navigator.push(
                            context, MaterialPageRoute(builder: (context) => Termsandcondition()));*/
                      });
                    },),
                  ],
                ),
                Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                  ),
                )
              ],
            );
          },

          validator: (value) {
            if (!checkValue) {
              return 'You need to accept T & C';
            } else {
              return null;
            }
          },
        ), ),
                    /*Container(
                      width: 200,
                      height: 50,
                      child: MyWidget()),*/
                    Container(
                      height: 50.0,

                      alignment: Alignment.center,

                      child: RaisedButton(
                        onPressed: () {
                          submitBtnDidTapped();
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

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Text(
                                  "Register",
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
                                  elevation: 10,
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
                    SizedBox(height: 20,),
                   Center(
                      child: GestureDetector(
                        onTap: () {

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                          GestureDetector(child:Text(
                            "Already Registered",
                            style: TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onTap: (){
                            setState(() {
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => LoginPage()));
                            });
                          },
                          ),

                            GestureDetector(child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: kSecondaryTextColor,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ), onTap: (){
                              setState(() {
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => Forgotpassword()));
                              });
                            },),
                        ],),
                      ),
                    ),

                  ],


            ),
          ],
        ),)
      ),)))
    );
  }

  Widget buildTextFormField({
    TextEditingController controller,
    String hint,
    TextInputType inputType,
    int maxLength,
    Icon icon,
    String validation,

  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 1.0, 15.0, 1.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,vertical: 5
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
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
              prefixIcon: CountryCodePicker(
                onChanged: _onCountryChange,

                initialSelection: 'In',
                countryList:countryCodes,

                favorite: ['+91','In'],

                showCountryOnly: false,
                // optional. Shows only country name and flag when popup is closed.
                showOnlyCountryWhenClosed: false,
                // optional. aligns the flag and the Text left
                alignLeft: false,
              ),
              suffixIcon: icon != null ? icon : SizedBox.shrink(),
            ),
            controller: controller,
            validator: (value) {
              if (value.isEmpty) {
                return validation;
              }   if (value.length != 10)
                return 'Mobile Number must be of 10 digit';

              return null;
            },
            inputFormatters: [
              LengthLimitingTextInputFormatter(maxLength),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void registrationDidFailed(String invalidFields) {
    Fluttertoast.showToast(
        msg: invalidFields,
        timeInSecForIosWeb: 1,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Rmlightblue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void registrationDidSucceed() {
    _mPresenter.Verification(context,_phonenumber.text,phoneNumber);
  }

  @override
  void submitBtnDidTapped() {
    if(formGlobalKey.currentState.validate()){
      _mPresenter.doRegistration({ 'mobile':_phonenumber.text});
    }
  }

  @override
  void termsandconditionDidSucceed(String terms) {
    // TODO: implement termsandconditionDidSucceed
  }
}
class MyWidget extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return SizedBox(
    height: 48.0,

    child: Container(


      decoration: BoxDecoration(
          color: Rmlightblue,
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(1.0, 2.0),
                blurRadius: 8.0,
                spreadRadius: 2.0)
          ]),
      child: new InkWell(
        onTap: () => print('hello'),
        child: Row(children: [
          Container(
            width: 50.0,
            height: 150.0,
            decoration: new BoxDecoration(

              gradient: LinearGradient(
                colors: [
                  Rmlightblue,
                  Rmpick,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(95.0),
                  topLeft: Radius.circular(95.0),

              ),
              border: new Border.all(color: Rmlightblue, width: 2.0),
              // borderRadius: new BorderRadius.circular(10.0),
            ),
            child: new Center(child: new Icon(
              Icons.edit,
              color: Colors.white,
            ),),
          ),
          Spacer(),
          Text('Register', style: new TextStyle(fontSize: 18.0, color: Colors.white),),

          Spacer(),
        ],)
      ),
    ),
  );
}
}
class MyButton extends StatelessWidget {
  MyButton({@required this.onPressed});

  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Rmlightblue,
      splashColor: Colors.grey,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.pending_actions,
              color: Colors.amber,
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Register',
              maxLines: 1,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      onPressed: onPressed,
      shape: const StadiumBorder(),
    );
  }
}