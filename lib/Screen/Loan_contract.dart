import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:creditscore/Apiservice/ApiserviceProvider.dart';
import 'package:creditscore/Data/Keys.dart';
import 'package:creditscore/Data/PreferenceManager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Common/MyFormTextField.dart';
import 'package:creditscore/Common/Toastcustom.dart';
import 'package:creditscore/Common/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import 'LoanAgreement.dart';
const directoryName = 'ACS';
class Loancontract extends StatefulWidget {
  const Loancontract({Key key, this.loainId}) : super(key: key);

  final String loainId;

  @override
  _LoandetailsState createState() => _LoandetailsState();
}

class _LoandetailsState extends State<Loancontract> {
  double _lowerValue = 0;
  double _months=0;
  double _upperValue = 180;
  bool checkBoxValue = false;
  double _height;
  File _image;
  String loanId;
  String productType;
  String tenureMonth;
  String loanFeess;
  String loanAmount;
  String mobileNumber;
  String kycPath;
  String signature;
  Random random = new Random();
  double _width;
  DateTime selectedDate=DateTime.now();
  int randomNumber=0;
  final SignatureController _controller =
  SignatureController(penStrokeWidth: 2, penColor: Colors.white);
  final _formKey = GlobalKey<FormState>();
   String token="";
  TextEditingController username = new TextEditingController();
  TextEditingController icnumber = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController mobilenumber = new TextEditingController();
  TextEditingController emailaddress = new TextEditingController();
  TextEditingController dateee = new TextEditingController();
  TextEditingController product = new TextEditingController();
  TextEditingController loanamount = new TextEditingController();
  TextEditingController Loanfees = new TextEditingController();
  TextEditingController interestrate = new TextEditingController();
  TextEditingController tenure = new TextEditingController();
  TextEditingController Loanrepayment = new TextEditingController();
  TextEditingController penalties = new TextEditingController();
  ProgressDialog pr;
  Map<String, String> headersMap ;
  Widget acceptTermsTextRow() {

    return Container(
     // margin: EdgeInsets.only(top: _height / 100.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              activeColor: Colors.orange[200],
              value: checkBoxValue,
              onChanged: (bool newValue) {
                setState(() {
                  checkBoxValue = newValue;
                });
              }),
          Text(
            "I accept all terms and conditions",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          ),
        ],
      ),
    );
  }
  void _openCustomDialog() {
    showGeneralDialog(barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),),
                title: Text(''),
                content: Text('Apply Successfully !!'),
                actions: [
                  NeumorphicButton(
                        padding: const EdgeInsets.all(10.0),
                        onPressed: () {

                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => Home()));
                        },
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape:
                          NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                        ),
                        child: Center(child:Text('ok',style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)) ,)
                    ),

                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
  @override
  void initState() {
    // TODO: implement initState
    getloandetails();
    super.initState();
  }
  @override
  getloandetails()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    username.text = preferences.getString(Constants.firstName);
    emailaddress.text = preferences.getString(Constants.emailId);
    icnumber.text = preferences.getString(Constants.icNumbe);
    address.text = preferences.getString(Constants.address1);
    dateee.text=formattedDate;
    loanId=preferences.getString(Constants.loanId)??"";
    product.text=preferences.getString(Constants.productType)??"";
    tenure.text=preferences.getString(Constants.tenureMonth)??"";
    Loanfees.text=Constants.loanFees.toString();
    //Loanfees.text=preferences.getString(Constants.loanFeess)??"";

    interestrate.text=preferences.getDouble(Constants.interestRate).toString()??"" ;
    loanamount.text=preferences.getInt(Constants.loanAmount).toString()??"";
    mobilenumber.text= "${await PreferenceManager.sharedInstance.getInt(
        Keys.MOBILE_NUM.toString())??""}";
     token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString())??"";
    kycPath=await PreferenceManager.sharedInstance.getString(Keys.E_KYC.toString())??"";
    signature=preferences.getString(Constants.docSign)??"";
    headersMap = {
      'Authorization' : token
    };
print("Ramesh"+""+kycPath);
  }
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
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

  _asyncFileUpload() async{
    //create multipart request for POST or PATCH method
    SharedPreferences preferences = await SharedPreferences.getInstance();
    pr = new ProgressDialog(context);
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
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
   String userid=await PreferenceManager.sharedInstance.getString(Keys.USER_ID.toString());
    String  token=await PreferenceManager.sharedInstance.getString(Keys.ACCESS_TOKEN.toString());
    var postUri = Uri.parse(APIS.fileupload+"${userid}");
   print("Test Ramesh");
   print(userid);
    print(token);
    print(postUri);

    var request = http.MultipartRequest("POST",postUri);
    //add text fields
    Map<String, String> headers = {
      "Authorization":token,
    };
    request.headers.addAll(headers);
    request.fields["key"] =Constants.docSign;
    //create multipart using filepath, string or bytes
    String datatime = preferences.getString("formattedDateTime");
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    File file = new File('$path/$directoryName/${datatime}.png');
    print(file.path);

    var pic = await http.MultipartFile.fromPath(Constants.doc, file.path,  contentType: MediaType('image','png'),);
    //add multipart to request
    print(pic.filename);
    request.files.add(pic);
    var response = await request.send();
    print(response.statusCode);

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if(response.statusCode==200){
      print(responseString);
      pr.hide();
      Fluttertoast.showToast(
          msg: "Upload Successfully",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoanAgreement(loanId:loanId,)));
    }
    if(response.statusCode==401){
      print(responseString);
      pr.hide();
      Fluttertoast.showToast(
          msg: "Invalid Token",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Rmlightblue,
          textColor: Colors.white,
          fontSize: 16.0);
    }



    // print(responseString["url"]);
  }

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1600, 8),
        lastDate: DateTime(2101),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Rmpick,
                onPrimary: Colors.white,
                surface: Rmpick,
                onSurface: Colors.white,
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
        dateee.text = DateFormat('dd-MM-yyyy').format(picked);

      });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text("Loan Agreement",style: TextStyle(fontWeight: FontWeight.bold,color: Rmlightblue),),
        ),
        body: Container(
          color: Colors.white,
      height: MediaQuery.of(context).size.height,
          padding:EdgeInsets.symmetric(horizontal: 15,vertical: 10),
      child: SingleChildScrollView(child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10,),
          Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: [
                      Text("Loan Id: ",style: TextStyle(fontWeight: FontWeight.bold),),
                      Text(widget.loainId,style: TextStyle(fontWeight: FontWeight.bold)),
                    ],),

                    SizedBox(height: 10,),

                    Text("Personal info: ",style: TextStyle(fontWeight: FontWeight.bold),),

                    buildTextFormField(
                      controller: username,
                      hint:"User name",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter username",
                      icon: Icon(
                        Icons.account_circle,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    buildTextFormField(
                      controller: icnumber,
                      hint:"IC Number",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter IC Number",
                      icon: Icon(
                        Icons.confirmation_num,
                        color: Color(0xFFFEB71E),
                      ),
                    ),


                    SizedBox(height: 10,),
                    Text("IC Image "),
                    SizedBox(height: 10,),
                   /* Center(
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
                          height: MediaQuery.of(context).size.height/5,
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
                    ),*/

                    GestureDetector(child: Container(
               decoration: BoxDecoration(
                 border: Border.all(color: Rmlightblue),

                 borderRadius:BorderRadius.all(Radius.circular(20.0)),
                 color: Colors.black,
               ),
               padding: EdgeInsets.all(20),
               margin: EdgeInsets.all(20),
               width: MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height/5,
               child: CachedNetworkImage(

                 /*placeholder: (context, url) => Container(
                     height: 20,
                     width: 20,
                     child: CircularProgressIndicator()),*/
                 placeholder: (context, url) => Container(
                     height: 20,
                     width: 20,
                     child: Icon(Icons.image,color: Colors.white,)),
                 errorWidget: (context, url, error) => Icon(Icons.image,color: Colors.white,),
                 imageUrl: 'http://104.131.5.210:7400/api/users/doc/${kycPath}?key=${"docEKYC"}',
                 httpHeaders: headersMap,
                 width: 100,
                 height: 100,
                 fit: BoxFit.fitHeight,
               )/*Image.network("http://104.131.5.210:7400/api/users/doc/$kycPath?key=${"docEKYC"}", headers: headersMap, width: 100,
                 height: 100,
                 fit: BoxFit.fitHeight,)*/,),onTap: (){
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(token: token,path:kycPath ,keyvalue: "docEKYC",title:"IC Image")));
                      });
                    },),

                    buildTextFormField(
                      controller: address,
                      hint:"Address",
                      showtext:false,
                      inputType: TextInputType.text,
                      validation:"Enter Address",
                      icon: Icon(
                        Icons.location_on,
                        color: Color(0xFFFEB71E),
                      ),
                    ),

                    buildTextFormField(
                      controller: mobilenumber,
                      hint:"Mobile number",
                      maxLength: 10,
                      showtext: false,
                      inputType: TextInputType.number,
                      validation:"Enter mobilenumber",
                      icon: Icon(
                        Icons.phone,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    buildTextFormField(
                      controller: emailaddress,
                      hint:"Email address",
                      showtext: false,
                      inputType: TextInputType.text,
                      validation:"Enter Email id",
                      icon: Icon(
                        Icons.email,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
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
                        controller: dateee,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Select Agreement date";
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
                                setState(() {
                                  _selectDate1(context);
                                });
                              },
                            ), // icon is 48px widget.
                          ),
                          hintText: 'Agreement date e.g dd-mm-yyyy',
                          hintStyle: TextStyle(fontSize: 14.0,color: Colors.grey),

                        ),
                      ),),),),
                    /*buildTextFormField(
                                controller: dateee,
                                hint:"Agreement date",
                                inputType: TextInputType.text,
                                validation:"Enter Agreement date",
                                icon: Icon(
                                  Icons.date_range,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),*/
                    buildTextFormField(
                      controller: product,
                      hint:"Product",
                      inputType: TextInputType.text,
                      validation:"Enter Product",
                      icon: Icon(
                        Icons.email,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    buildTextFormField(
                      controller: loanamount,
                      hint:"Loan Amount",
                      inputType: TextInputType.text,
                      validation:"Enter Loan Amount",
                      icon: Icon(
                        Icons.local_atm,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    buildTextFormField(
                      controller: Loanfees,
                      hint:"Loan fees",
                      inputType: TextInputType.text,
                      validation:"Enter Loan fees",
                      icon: Icon(
                        Icons.local_atm,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    buildTextFormField(
                      controller: interestrate,
                      hint:"Interestrate",
                      inputType: TextInputType.text,
                      validation:"Enter Interestrate",
                      icon: Icon(
                        Icons.calculate_rounded,
                        color: Color(0xFFFEB71E),
                      ),
                    ),
                    buildTextFormField(
                      controller: tenure,
                      hint:"Tenure",
                      inputType: TextInputType.text,
                      validation:"Enter Tenure",
                      icon: Icon(
                        Icons.calendar_view_month,
                        color: Color(0xFFFEB71E),
                      ),
                    ),


                  ],
                ),
              ),



            ],
          ),

         /* Stack(children: [
            Container(
            *//*  decoration: BoxDecoration(color:appcolor,
                borderRadius:BorderRadius.all(Radius.circular(20.0)),),*//*
              padding: EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height/1.8,
              width: double.infinity,
              child: Stack(children: [ Container(
                   // padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    decoration: BoxDecoration(color: Colors.white10,
                      borderRadius:BorderRadius.all(Radius.circular(10.0)),),
                    child:SingleChildScrollView(child:  Column(
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: [
                                Text("Loan Id: ACS",style: TextStyle(fontWeight: FontWeight.bold),),
                                Text(randomNumber.toString(),style: TextStyle(fontWeight: FontWeight.bold)),
                              ],),

                              SizedBox(height: 10,),

                              Text("Personal info: ",style: TextStyle(fontWeight: FontWeight.bold),),

                              buildTextFormField(
                                controller: username,
                                hint:"User name",
                                inputType: TextInputType.text,
                                validation:"Enter username",
                                icon: Icon(
                                  Icons.account_circle,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: icnumber,
                                hint:"IC Number",
                                inputType: TextInputType.text,
                                validation:"Enter IC Number",
                                icon: Icon(
                                  Icons.confirmation_num,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),


                              SizedBox(height: 10,),
                              Text("IC Image Capture "),
        SizedBox(height: 10,),
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
                                    height: MediaQuery.of(context).size.height/5,
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
                              buildTextFormField(
                                controller: address,
                                hint:"Address",
                                inputType: TextInputType.text,
                                validation:"Enter Address",
                                icon: Icon(
                                  Icons.location_on,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: mobilenumber,
                                hint:"Mobile number",
                                maxLength: 10,
                                inputType: TextInputType.number,
                                validation:"Enter mobilenumber",
                                icon: Icon(
                                  Icons.phone,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: emailaddress,
                                hint:"Email address",
                                inputType: TextInputType.text,
                                validation:"Enter Email id",
                                icon: Icon(
                                  Icons.email,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
                                child:Card(child:Padding( padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),child:TextFormField(
                                  textAlign: TextAlign.left,

                                  onTap: (){
                                    setState(() {
                                      _selectDate1(context);
                                    });
                                  },
                                  controller: dateee,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Select Agreement date";
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
                                          setState(() {
                                            _selectDate1(context);
                                          });
                                        },
                                      ), // icon is 48px widget.
                                    ),
                                    hintText: 'Agreement date e.g dd-mm-yyyy',
                                    hintStyle: TextStyle(fontSize: 14.0,color: Colors.grey),

                                  ),
                                ),),),),
                              *//*buildTextFormField(
                                controller: dateee,
                                hint:"Agreement date",
                                inputType: TextInputType.text,
                                validation:"Enter Agreement date",
                                icon: Icon(
                                  Icons.date_range,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),*//*
                              buildTextFormField(
                                controller: product,
                                hint:"Product",
                                inputType: TextInputType.text,
                                validation:"Enter Product",
                                icon: Icon(
                                  Icons.email,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: loanamount,
                                hint:"Loan Amount",
                                inputType: TextInputType.text,
                                validation:"Enter Loan Amount",
                                icon: Icon(
                                  Icons.local_atm,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: Loanfees,
                                hint:"Loan fees",
                                inputType: TextInputType.text,
                                validation:"Enter Loan fees",
                                icon: Icon(
                                  Icons.local_atm,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: interestrate,
                                hint:"Interestrate",
                                inputType: TextInputType.text,
                                validation:"Enter Interestrate",
                                icon: Icon(
                                  Icons.calculate_rounded,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: tenure,
                                hint:"Tenure",
                                inputType: TextInputType.text,
                                validation:"Enter Tenure",
                                icon: Icon(
                                  Icons.calendar_view_month,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: Loanrepayment,
                                hint:"Loan repayment",
                                inputType: TextInputType.text,
                                validation:"Enter Loan repayment",
                                icon: Icon(
                                  Icons.payments_outlined,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),
                              buildTextFormField(
                                controller: penalties,
                                hint:"Penalties",
                                inputType: TextInputType.text,
                                validation:"Enter penalties",
                                icon: Icon(
                                  Icons.pending_actions,
                                  color: Color(0xFFFEB71E),
                                ),
                              ),

                            ],
                          ),
                        ),



                      ],
                    ),)
                ),Align(alignment:Alignment.bottomRight,child: Icon(Icons.arrow_circle_down_sharp),)
              ],),),
          ],),*/
          Text("Signature Image ",style: TextStyle(fontWeight: FontWeight.bold),),
          GestureDetector(child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Rmlightblue),

              borderRadius:BorderRadius.all(Radius.circular(20.0)),
              color: Colors.black,
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/5,
            child: CachedNetworkImage(

              placeholder: (context, url) => Container(
                  height: 20,
                  width: 20,
                  child: Icon(Icons.image,color: Colors.white,)),
              errorWidget: (context, url, error) => Icon(Icons.image,color: Colors.white,),
              imageUrl: 'http://104.131.5.210:7400/api/users/doc/${signature}?key=${"docSign"}',
              httpHeaders: headersMap,
              width: 100,
              height: 100,
              fit: BoxFit.fitHeight,
            )/*Image.network("http://104.131.5.210:7400/api/users/doc/$kycPath?key=${"docEKYC"}", headers: headersMap, width: 100,
                 height: 100,
                 fit: BoxFit.fitHeight,)*/,),onTap: (){
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ImageView(token: token,path:signature ,keyvalue: "docSign",title: "Signature",)));
            });
          },),
         /* Row(children: [
            Text("Signature below ",style: TextStyle(fontWeight: FontWeight.bold),),
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
          SizedBox(height: 20),
          Container(
            height: 50.0,
            alignment: Alignment.center,
            child: RaisedButton(
              onPressed: () async {
                var data = await _controller.toPngBytes();
                SharedPreferences preferences = await SharedPreferences.getInstance();
                if(_formKey.currentState.validate()){
                 // _openCustomDialog();
                  /* if(_controller.isEmpty){
                    ToastUtil.show("Enter Your Signature");
                  }
                  else{


                  }*/
                 /* final DateTime now = DateTime.now();
                  final String formattedDateTime = Constants.formatDateTime(now);

                  preferences.setString("formattedDateTime", formattedDateTime);

                  Directory directory = await getExternalStorageDirectory();
                  String path = directory.path;

                  await Directory('$path/$directoryName')
                      .create(recursive: true);
                  File('$path/$directoryName/${formattedDateTime}.png')
                      .writeAsBytesSync(data.buffer.asInt8List());
                  _asyncFileUpload();*/
                  /*Navigator.push(
                        context, MaterialPageRoute(builder: (context) => LoanAgreement()));*/
                  setState(() {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => LoanAgreement()));
                  });

                }
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
                        "Next",
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

          SizedBox(height: 20,),
        ],
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
    bool showtext
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1.0, 1.0, 2.0, 1.0),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: TextFormField(
            obscureText: inputType == TextInputType.visiblePassword,
            textInputAction: TextInputAction.next,
            enabled:showtext ,
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
              }if(maxLength==10){
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
}
class ImageView extends StatelessWidget {
  const ImageView({Key key,this.path,this.token,this.keyvalue,this.title}) : super(key: key);
 final String path;
  final String token;
  final String keyvalue;
  final String title;
  @override
  Widget build(BuildContext context) {
    Map<String, String> headersMap = {
      'Authorization' : token
    };
    return Container(
        color: Rmlightblue,
        child:SafeArea(child: Scaffold(appBar: AppBar(
          brightness: Brightness.light,
          title: Text(title,style: TextStyle(color: Rmlightblue),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Rmlightblue),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),body: Container(child:CachedNetworkImage(
          imageUrl: 'http://104.131.5.210:7400/api/users/doc/$path?key=${keyvalue}',
          httpHeaders: headersMap,
          placeholder: (context, url) => Container(
              height: 20,
              width: 20,
              child: Icon(Icons.image,color: Colors.white,)),
          errorWidget: (context, url, error) => Icon(Icons.image,color: Colors.white,),
          width: MediaQuery.of(context).size.width,
          height:  MediaQuery.of(context).size.height,
          fit: BoxFit.fitHeight,
        ),),),)

    );
  }
}