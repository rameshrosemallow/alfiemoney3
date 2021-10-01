
import 'package:creditscore/Screen/SplashScreen.dart';
import 'package:creditscore/Screen/profile/Profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'Common/Colors.dart';
import 'Common/Constants.dart';
import 'Screen/Demo.dart';
import 'Screen/FileDownload.dart';
import 'Screen/Home.dart';
import 'Screen/KYCimage.dart';
import 'Screen/Loan_contract.dart';

import 'Screen/Loan_list.dart';
import 'Screen/Loanapproed.dart';
import 'Screen/bankDetails/BankDetails.dart';
import 'Screen/size_config.dart';
const debug = true;
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize(debug: debug);
  runApp(MyApp());
}
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final platform = Theme.of(context).platform;
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: Constants.appName,
                theme: ThemeData(
                  primarySwatch: createMaterialColor(Rmlightblue),
                  fontFamily: Constants.fontName,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: SplashScreen());
          },
        );
      },
    );
  }
}
