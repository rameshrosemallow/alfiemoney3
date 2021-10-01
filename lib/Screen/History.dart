import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Common/FadeAnimation.dart';
import 'package:creditscore/Screen/select_account_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Historyscreen extends StatefulWidget {
  const Historyscreen({Key key}) : super(key: key);

  @override
  _HistoryscreenState createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<Historyscreen> {

  List<Color> colors = [Colors.indigo, Colors.pink, Colors.pink];
  List<Color> colors2 = [Rmyellow, Rmblue, Colors.pink];
  List<String> score=["20","50","40","45","60"];
  List<String> date=["07 july 2021","05 july 2021","04 july 2021","03 july 2021","02 july 2021"];
  Widget _getRadialGauge() {
    return SfRadialGauge(
      enableLoadingAnimation: true,
      animationDuration: 2,

      axes:<RadialAxis>[
        RadialAxis(showLabels: false, showAxisLine: false, showTicks: false,
            minimum: 0, maximum: 99,
            ranges: <GaugeRange>[GaugeRange(startValue: 5, endValue: 20,
              color: Color(0xFFFE2A25),

              labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:  20),
              startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
            ),GaugeRange(startValue: 20, endValue: 40,
              color:Colors.orange,
              labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
              startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
            ),
              GaugeRange(startValue: 40, endValue: 60,
                color:Color(0xFFFFBA00),
                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
                startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
              ),
              GaugeRange(startValue: 60, endValue: 80,
                color:Colors.blueAccent,
                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
                startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
              ),
              GaugeRange(startValue: 80, endValue: 96,
                color:Color(0xFF00AB47),
                labelStyle: GaugeTextStyle(fontFamily: 'Times', fontSize:   20),
                startWidth: 30, endWidth: 30, sizeUnit: GaugeSizeUnit.logicalPixel,
              ),

            ],
            pointers: <GaugePointer>[NeedlePointer(value: 60
            )],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Container(
                      child: const Text('600.0',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white))),
                  angle: 90,
                  positionFactor: 0.5)
            ]

        )
      ],
    );
  }
  Widget acsscore_list(){
    return SingleChildScrollView(child: Container(
      color: Colors.white,
      child: Column(children: [
        SizedBox(height: 10,),
        Container(
          height: MediaQuery.of(context).size.height/4,
          width: MediaQuery.of(context).size.width,
          child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,

                      colors: [Colors.teal, Colors.deepPurple]),),
            child:Container(child: Column(children: [
              Flexible(child: _getRadialGauge(),),
              Align(
                  alignment: Alignment.bottomLeft,
                  child:Row(children: [
                    Column(children: [
                      FadeAnimation(1.6,
                          Text("Your Last Score", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)
                      ),
                      SizedBox(height: 5,),
                      FadeAnimation(1.6,
                          Text("580", style: TextStyle(color: Colors.grey),))
                    ],),
                    Spacer(),
                    Column(children: [
                      FadeAnimation(1.6,
                          Text("Your Score Added", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),)
                      ),
                      SizedBox(height: 5,),
                      FadeAnimation(1.6,
                          Text("+20", style: TextStyle(color: Colors.grey),))
                    ],),
                  ],) ),


            ],),),
          ) ,),

      FadeAnimation(1.6, ListView.builder(
            itemCount: score.length,
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                children: [
                 Row(children: [
                   new Image.asset(
                     'assets/images/logo.png',
                     width: 50,
                     height: 50,
                   ),
                   SizedBox(width: 10,),
                   Text('+${score[index]} is Credited your score!')
                 ],),

                  Align(
                      child: Text(date[index]),alignment: Alignment.bottomRight,),
                ],
              ));
            })),
      ],),
    ));
  }
  Widget activeloan(){
    return  ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height/4,

          decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xff2b83ba), Color(0xfff2ccff)])),
                margin: EdgeInsets.all(10),

                  child: Stack(children: [ Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),

                      ListTile(
                          title: Text("Loan Id :ACS09090k"),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                            Text("Amount  :"+"\$10000"),
                            Text("Due On   : 31-07-2021"),
                          ],),
                          leading: CircleAvatar(

                            backgroundColor: Colors.blue,
                            child: CircleAvatar( radius: 18,backgroundColor: Colors.white,child:Container(padding:EdgeInsets.all(5),child: Image.asset("assets/images/logo.png"),),),
                          ),),
                          //trailing: Text("31-07-2021")),


                      SizedBox(height: 10,),

                      Spacer(),
                     GestureDetector(child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 40,

                       decoration: BoxDecoration(
                           color: Color(0xffb3d1ff),
                           borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))),
                        child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Icon(Icons.attach_money_sharp,color: Colors.white,),
                          Text("Pay",style: TextStyle(color: Colors.white,fontSize: 12),)
                        ],),),onTap: (){

                         Navigator.push(
                             context, MaterialPageRoute(builder: (context) => SelectAccountPage()));

                     },),
                    ],
                  ),
                  Align(child:IconButton(icon: Icon(Icons.info,color: Colors.black,), onPressed: (){

                  }) ,alignment: Alignment.topRight,)
                  ],),
                ),



            ],
          );
        });
  }
  Widget pendingloan(){
    return  ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height/4,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xff0099cc), Color(0xfff2ccff)])),
                child:  Stack(children: [


          Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5,),
                      ListTile(
                        title: Text("Application No :ACS09090k"),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Text("Amount                :"+"\$10000"),
                            Text("Date and time     : 08-07-2021"),
                          ],),
                        leading: CircleAvatar(

                          backgroundColor: Colors.blue,
                          child: CircleAvatar( radius: 18,backgroundColor: Colors.white,child:Container(padding:EdgeInsets.all(5),child: Image.asset("assets/images/logo.png"),),),
                        ),),

                     SizedBox(height: 30,)

                    ],
                  ),
                    Align(child: Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width/4.5,
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      margin: EdgeInsets.all(10),
                      child:Center(child:Text('View',style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))
                      ),),alignment: Alignment.bottomRight,),
                    Align(child:Container(child:Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Container(
          width: 10.0,
          height: 10.0,
          decoration: new BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          //  border: Border.all(width: 5.0, color: Colors.white),
          ),
          ),Text(
          "In Progress",
          textAlign: TextAlign.center,
          style: TextStyle(
          color: Colors.green,
          fontSize: 12),
          ),],),padding: EdgeInsets.all(10),),alignment: Alignment.topRight,)
                  ],
                ),
              ),


            ],
          );
        });
  }
  Widget rejectedloan(){
    return  ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width ,
                height: MediaQuery.of(context).size.height/4,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.redAccent, Colors.grey])),
                child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 5,),
                      Text(
                        "Oops! ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,

                            fontSize: 14),
                      ),
                      Text(
                        ' Rejected Your Application No.ACS09091',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,

                            fontSize:15),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Better luck Next Time',
                        style: TextStyle(
                            color: Colors.white,

                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color(0xffb3d1ff),
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight: Radius.circular(10))),
                        child:Center(child:Text('Details',style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))
                        ),),
                    ],
                  ),
                ),



            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
         backgroundColor: Rmblue,
         flexibleSpace: Container(
         decoration: BoxDecoration(
             gradient: LinearGradient(
                 begin: Alignment.centerLeft,
                 end: Alignment.centerRight,
                 colors: [Colors.purple, Colors.blue]),)),

          automaticallyImplyLeading: false,


          bottom: TabBar(
            indicatorColor: Rmyellow,
           labelColor: Rmyellow,
           labelStyle: TextStyle(fontSize: 10),
           unselectedLabelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.score), text: "ACS Score",),
              Tab(icon: Icon(Icons.access_time), text: "Active",),
              Tab(icon: Icon(Icons.pending_actions), text: "Pending"),
              Tab(icon: Icon(Icons.cancel_presentation_sharp), text: "Rejected"),
            ],
          ),
          title: Text("Loan History"),
        ),
        body: TabBarView(
          children: [
            acsscore_list(),
            activeloan(),
            pendingloan(),
            rejectedloan()
          ],
        ),
      ),
    );
  }
}
