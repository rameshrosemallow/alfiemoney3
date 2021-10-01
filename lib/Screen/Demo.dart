import 'dart:isolate';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:creditscore/Common/Constants.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:creditscore/Common/Colors.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
const debug = true;
const directoryName = 'ACS';
class Downloadfile extends StatefulWidget {
  const Downloadfile({Key key}) : super(key: key);

  @override
  _DownloadfileState createState() => _DownloadfileState();
}

class _DownloadfileState extends State<Downloadfile> {
  ReceivePort _port = ReceivePort();
  @override
  void initState() {
    // TODO: implement initState
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }
  @override
  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }
  void _bindBackgroundIsolate() {
    bool isSuccess = ui.IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      if (debug) {
        print('UI Isolate Callback: $data');
      }
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
    });
  }

  void _unbindBackgroundIsolate() {
    ui.IsolateNameServer.removePortNameMapping('downloader_send_port');
  }
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    if (debug) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    }
    final SendPort send =
    ui.IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<String> _findLocalPath() async {
    final platform = Theme.of(context).platform;
    final directory = platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss:a').format(dateTime);
  }

  Future<void> requestDownload(String _url, String _name) async {
    final dir = await getApplicationDocumentsDirectory();
//From path_provider package
    String _localPath =
        (await _findLocalPath()) + Platform.pathSeparator + 'My Badge';

    final savedDir = Directory(_localPath);
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    await savedDir.create(recursive: true).then((value) async {
      String _taskid = await FlutterDownloader.enqueue(
        url: "https://www.google.co.in/imgres?imgurl=https%3A%2F%2Fwww.industrialempathy.com%2Fimg%2Fremote%2FZiClJf-1920w.jpg&imgrefurl=https%3A%2F%2Fwww.industrialempathy.com%2Fposts%2Fimage-optimizations%2F&tbnid=z4_uU0QB2pe-SM&vet=12ahUKEwiHj8fZwM3yAhVc4nMBHa3eDdgQMygGegUIARDVAQ..i&docid=7SySw5zvOgPYAM&w=1920&h=1080&q=image&client=safari&ved=2ahUKEwiHj8fZwM3yAhVc4nMBHa3eDdgQMygGegUIARDVAQ",
        fileName: _name + "_" + formattedDateTime,
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true,
      );
      print("ram123" + _taskid);
    });
  }
  void getImage() async{
    var uri = Uri.parse("http://104.131.5.210:7400/api/users/doc/d51708f0-0572-11ec-b4e0-15617ff50f8c.png?key=docSign");

     String userId="ram";
    try {
      final response = await http.get(uri,
          headers: {"Authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MTI1ZGY4Njc1ZWY4NDI1ZmM5MmM0YTgiLCJyb2xlIjoiMSIsImlhdCI6MTYyOTg3MjI0MX0.wP6D26hdjVrRfTdCw29rbbkgzx6ITYi-Be301P9d7JQ"});

      if (response.contentLength == 0){
        return;
      }
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File file = new File('$tempPath/$userId.png');
      await file.writeAsBytes(response.bodyBytes);
      //displayImage(file);
    }
    catch (value) {
      print(value);
    }
  }
  _save() async {
    var response = await Dio().get(
        "http://104.131.5.210:7400/api/users/doc/d51708f0-0572-11ec-b4e0-15617ff50f8c.png?key=docSign",
        options: Options(responseType: ResponseType.bytes,headers: {"Authorization":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2MTI1ZGY4Njc1ZWY4NDI1ZmM5MmM0YTgiLCJyb2xlIjoiMSIsImlhdCI6MTYyOTg3MjI0MX0.wP6D26hdjVrRfTdCw29rbbkgzx6ITYi-Be301P9d7JQ"}));
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "hello");

    print(result);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body:
      Center(child: Container(child:  Container(
        height: 50.0,
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 10),
        child: RaisedButton(
          onPressed: () {
            setState(() {
              _save();
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
      ),),),));
  }
}


class PdfCreator extends StatefulWidget {
  const PdfCreator({Key key}) : super(key: key);

  @override
  _PdfCreatorState createState() => _PdfCreatorState();
}

class _PdfCreatorState extends State<PdfCreator> {

  Future<void> main() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a5,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context){
          return <pw.Widget>  [
            pw.Header(
                level: 0,
                child: pw.Text("Easy Approach Document")
            ),

            pw.Paragraph(
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
            ),

            pw.Paragraph(
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
            ),

            pw.Header(
                level: 1,
                child: pw.Text("Second Heading")
            ),

            pw.Paragraph(
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
            ),

            pw.Paragraph(
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
            ),

            pw.Paragraph(
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Malesuada fames ac turpis egestas sed tempus urna. Quisque sagittis purus sit amet. A arcu cursus vitae congue mauris rhoncus aenean vel elit. Ipsum dolor sit amet consectetur adipiscing elit pellentesque. Viverra justo nec ultrices dui sapien eget mi proin sed."
            ),
          ];
        },
      ),
    );
    final DateTime now = DateTime.now();
    final String formattedDateTime = Constants.formatDateTime(now);


    Directory directory = await getExternalStorageDirectory();
    String path1 = directory.path;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String path = appDocDir.path;
    final file = File('$path1/$directoryName/${"Rosemallow"+formattedDateTime}.pdf');
    print(file);
    await file.writeAsBytes(await pdf.save());
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child:Column(
        children: [
          Spacer(),
         Center(child: Container(
            height: 50.0,
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: 10),
            child: RaisedButton(
              onPressed: () {
                setState(() {
                 // main();

                  OpenFile.open("storage/emulated/0/Android/data/com.rosemallow.creditscore/files/ACS/Rosemallow05:56:30:PM.pdf");
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
          )),
        ],
      )
    );
  }
}
