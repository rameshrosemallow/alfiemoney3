import 'package:creditscore/Common/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'History.dart';

class LoanDetails extends StatefulWidget {
  const LoanDetails({Key key}) : super(key: key);

  @override
  _HistoryscreenState createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<LoanDetails> {

  List<Color> colors = [Colors.indigo, Colors.pink, Colors.pink];
  List<Color> colors2 = [Rmyellow, Rmblue, Colors.pink];
  List<String> score=["20","50","40","45","60"];
  bool redmi=false;
  List<String> date=["07 July 2021","05 July 2021","04 July 2021","03 July 2021","02 July 2021"];
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
  Widget loanperformance(){
    return SingleChildScrollView(child: Container(
     /* decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.purple, Colors.blue]),
          ),*/
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(height: 10,),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Card(
            color: Colors.white,

            child: ListTile(
              leading: Icon(Icons.article),
              title: Text("No. of Applications : 999",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
          child: Card(
            color: Colors.white,
            child: ListTile(
              leading: Icon(Icons.stacked_bar_chart),
              title: Text(" %: 25 Volume: 250 ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold)),
            ),
          ),
        ),


          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: MediaQuery.of(context).size.width/2.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("STATUS OF LOANS:",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),


                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 1.0),
                        child: Container(
                          height: 60,
                          width: 180,

                          child:Card(
                            color: Colors.blueAccent,
                          child: ListTile(
                            title: Text("Total loans disbursed(D/M/Q/YTD)",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),
                          ),
                        ),)
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 1.0),
                        child: Container(
                          height: 60,
                          width: 180,

                          child:Card(
                            color: Colors.blueAccent,
                          child: ListTile(

                            title: Text("Total loans outstanding(D/M/Q/YTD)",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),
                          ),
                        ),)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 1.0),
                        child: Container(
                          height: 60,
                          width: 180,

                          child:Card(
                            color: Colors.blueAccent,
                          child: ListTile(

                            title: Center(child: Text("Active",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                          ),
                        ),)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 1.0),
                        child: Container(
                          height: 60,
                          width: 180,

                          child:Card(
                            color: Colors.blueAccent,
                          child: ListTile(

                            title: Center(child: Text("Late payment",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                          ),)
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 1.0),
                        child:Container(
                          height: 60,
                          width: 180,

                          child: Card(
                            color: Colors.blueAccent,
                          child: ListTile(

                            title:Center(child:  Text("30+ DPD",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                          ),
                        ),)
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 1.0),
                        child: Container(
                          height: 60,
                          width: 180,

                          child:Card(
                            color: Colors.blueAccent,
                          child: ListTile(

                            title:Center(child: Text("60+ DPD",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),),
                          ),)
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 1.0),
                        child:Container(
                          height: 60,
                          width: 180,

                          child: Card(
                          color: Colors.blueAccent,
                          child: ListTile(
                            title: Center(child: Text("90+ DPD",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                          ),
                        ),)
                      ),


                    ],),),
                Spacer(),
              Container(
                width: MediaQuery.of(context).size.width/2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("OVERVIEW OF BORROWERS:",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      child: Container(
                        height: 60,
                        width: 180,

                        child: Card(
                        color: Colors.purpleAccent.shade700,
                        child: ListTile(

                          title: Center(child: Text("By ACS score",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                        ),
                      ),)
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      child:Container(
                        height: 60,
                        width: 180,

                        child: Card(
                        color: Colors.purpleAccent.shade700,
                        child: ListTile(

                          title: Center(child: Text("By Value of loan",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                        ),
                      ),)
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      child: Container(
                        height: 60,
                        width: 180,

                        child:Card(
                        color: Colors.purpleAccent.shade700,
                        child: ListTile(

                          title:Center(child:  Text("By Gender",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                        ),
                      ),)
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      child: Container(
                        height: 60,
                        width: 180,

                        child:Card(
                        color:Colors.purpleAccent.shade700,
                        child: ListTile(

                          title:Center(child:  Text("By Location",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                        ),
                      ),)
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
                      child:Container(
                        height: 60,
                        width: 180,

                        child: Card(
                        color: Colors.purpleAccent.shade700,
                        child: ListTile(

                          title: Center(child: Text("By Age group",style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white)),)
                        ),
                      ),)
                    ),


                ],),),



            ],),),



      ],),
    ));
  }
  Widget businessperformance(){
    return  SingleChildScrollView(child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
        /*  Container(
              height: redmi? 70:65,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.purple, Colors.blue]),
                  borderRadius: BorderRadius.circular(12)),
              child:  Center(child:Text('Total projected collections',style: TextStyle(fontSize: 14,color: Colors.white),) ,)*//*NeumorphicButton(
                padding: const EdgeInsets.all(18.0),
                onPressed: () {
                  *//**//*  Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Loanprocess()));*//**//*
                },

                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                ),
                child: Center(child:Text('Status of loans',style: TextStyle(fontSize: 18),) ,)
            ),*//*
          ),
          Container(
              height: redmi? 70:65,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.purple, Colors.blue]),
                  borderRadius: BorderRadius.circular(12)),
              child:  Center(child:Text('Total actual interest',style: TextStyle(fontSize: 14,color: Colors.white),) ,)*//*NeumorphicButton(
                padding: const EdgeInsets.all(18.0),
                onPressed: () {
                  *//**//*  Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Loanprocess()));*//**//*
                },

                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                ),
                child: Center(child:Text('Status of loans',style: TextStyle(fontSize: 18),) ,)
            ),*//*
          ),
          Container(
              height: redmi? 70:65,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.purple, Colors.blue]),
                  borderRadius: BorderRadius.circular(12)),
              child:  Center(child:Text('Projected loss from 30+ DPD and above ',style: TextStyle(fontSize: 14,color: Colors.white),) ,)*//*NeumorphicButton(
                padding: const EdgeInsets.all(18.0),
                onPressed: () {
                  *//**//*  Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Loanprocess()));*//**//*
                },

                style: NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(12),),
                ),
                child: Center(child:Text('Status of loans',style: TextStyle(fontSize: 18),) ,)
            ),*//*
          ),*/
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(

                title: Text("Total projected collections for the day/month/ quarter/ year to date:",style: TextStyle(fontWeight: FontWeight.bold,fontSize:14),),
                subtitle: Text("99,99,99,9999"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(

                title: Text("Total actual interest + fees collected (D/M/Q/YTD):",style: TextStyle(fontWeight: FontWeight.bold,fontSize:14),),
                subtitle: Text("99,99,99,9999"),

              ),
            ),
          ), Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(

                title: Text("Projected loss from 30+ DPD and above:",style: TextStyle(fontWeight: FontWeight.bold,fontSize:14),),
                subtitle: Text("99,99,99,9999"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child:Text("Users:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.supervised_user_circle_outlined),
                title: Text("Active"),
                subtitle: Text("100000"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: Text("In-active (no log-on for more than 90 days)"),
                subtitle: Text("50000"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child:Text("Fees Collected:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.score),
                title: Text("Monthly account fees:"),
                subtitle: Text("99,99,99,9999"),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.attach_money_sharp),
                title: Text("Early alert penalty fees:"),
                subtitle: Text("99,99,99,9999"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("Late penalties: "),
                subtitle: Text("99,99,99,9999"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading: Icon(Icons.location_city),
                title: Text("Account reactivation fees :  "),
                subtitle: Text("99,99,99,9999"),

              ),
            ),
          ),




        ],),
    ));
  }
  Widget Riskindicator(){
    return SingleChildScrollView(child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child:Text("Loan performance:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(

                title: Text("Early alerts raised (volume and value):",style: TextStyle(fontWeight: FontWeight.bold,fontSize:14),),
                subtitle: Text("Count: 999 Value:99,99,999"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(

                title: Text("List of app users with deteriorating ACS score >10% :",style: TextStyle(fontWeight: FontWeight.bold,fontSize:14),),
                subtitle: Text("999"),

              ),
            ),
          ), Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(

                title: Text("List of defaulters in 60+ DPD and longer :",style: TextStyle(fontWeight: FontWeight.bold,fontSize:14),),
                subtitle: Text("99999"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(

                title: Text("Concentration risk i.e., more than 20% of loans (volume and/or value) in a specific geographical area (by residential or commercial address):",style: TextStyle(fontWeight: FontWeight.bold,fontSize:14),),
                subtitle: Text("99999"),

              ),
            ),
          ), Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.white,
              child: ListTile(

                title: Text("Restructured loans – volume and value:",style: TextStyle(fontWeight: FontWeight.bold,fontSize:14),),
                subtitle: Text("Count: 999 Value:99,99,999"),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child:Text("App performance:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),


          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.blue,
              child: ListTile(
                leading: Icon(Icons.pending_actions,color: Colors.white),
                title: Text("App live performance/ downtime",style: TextStyle(color: Colors.white,fontSize: 12)),
                trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.blue,
              child: ListTile(
                leading: Icon(Icons.policy_rounded,color: Colors.white),
                title: Text("# of security/ vulnerability issues",style: TextStyle(color: Colors.white,fontSize: 12)),
                trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
            child: Card(
              color: Colors.blue,
              child: ListTile(
                leading: Icon(Icons.comment_bank,color: Colors.white),
                title: Text("No of complaints by users ",style: TextStyle(color: Colors.white,fontSize: 12)),
                trailing: Icon(Icons.arrow_forward_ios_outlined,color: Colors.white),

              ),
            ),
          ),


        ],
      ),
    ),) ;
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
    if (MediaQuery.of(context).size.height > 765) {
      redmi = true;

    } else {
      redmi = false;
    }
    return DefaultTabController(
      length: 3,

      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child:AppBar(
         backgroundColor: Rmblue,

         flexibleSpace: Container(
           decoration: BoxDecoration(
               gradient: LinearGradient(
                   begin: Alignment.centerLeft,
                   end: Alignment.centerRight,
                   colors: [Colors.purple, Colors.blue]),
               ),
         ),

          automaticallyImplyLeading: false,


          bottom: TabBar(
            indicatorColor: Rmyellow,
           labelColor: Rmyellow,
           labelStyle: TextStyle(fontSize: 8),
           unselectedLabelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.score), text: "Loan performance",),
              Tab(icon: Icon(Icons.library_books_outlined), text: "Business performance",),
              Tab(icon: Icon(Icons.warning), text: "Risk indicators"),
            ],
          ),
          title: Text("Dashboard"),
        ),),
        body: TabBarView(
          children: [
            loanperformance(),
            businessperformance(),
            Riskindicator(),
          ],
        ),
      ),
    );
  }
}
