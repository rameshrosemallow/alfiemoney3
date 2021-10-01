import 'package:creditscore/Common/Colors.dart';
import 'package:creditscore/Model/receiver_model.dart';
import 'package:flutter/material.dart';
class SendMoneyPageRoute extends PageRouteBuilder {
  SendMoneyPageRoute(ReceiverModel receiver)
      : super(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      return SendMoneyPage(
        receiver: receiver,
      );
    },
    transitionsBuilder: (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
      return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(animation),
        child: new SlideTransition(
          position: new Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(-1.0, 0.0),
          ).animate(secondaryAnimation),
          child: child,
        ),
      );
    },
  );
}

class SendMoneyPage extends StatefulWidget {
  final ReceiverModel receiver;

  SendMoneyPage({this.receiver});

  @override
  SendMoneyPageState createState() => SendMoneyPageState();
}

class SendMoneyPageState extends State<SendMoneyPage> {
  final TextEditingController amountController = TextEditingController();

  int selectedCardIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: Stack(children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding:
                  const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      Text(
                        'Send Money',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20.0),
                      ),
                    ],
                  )),
              Expanded(
                child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (BuildContext context, int index) {
                      return _getSection(index);
                    }),
              ),

Align(alignment: Alignment.bottomCenter,child: _getSendSection(),)
//            _getReceiverSection(this.widget.receiver),
//            _getEnterAmountSection()
            ],
          ),
        ),
      ],)
    );
  }

  Widget _getSection(int index) {
    switch (index) {
      case 0:
        return _getReceiverSection(widget.receiver);
        break;
      case 1:
        return _getEnterAmountSection();
      case 2:
        return _getBankCardSection();
    }
  }

  Widget _getReceiverSection(ReceiverModel receiver) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              child: Text(receiver.name.substring(0, 1)),
            ),
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    receiver.name,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.phone,
                          size: 13.0,
                          color: Color(0xFF929091),
                        ),
                      ),
                      Text(
                        receiver.phoneNumber,
                        style: TextStyle(fontSize: 12.0, color: Color(0xFF929091)),
                      ),
                    ],
                  ),
                 /* Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(Icons.account_balance,
                            size: 13.0, color: Color(0xFF929091)),
                      ),
                      Text(
                        receiver.accountNumber,
                        style: TextStyle(fontSize: 12.0, color: Color(0xFF929091)),
                      ),
                    ],
                  )*/
                ],
              ))
        ],
      ),
    );
  }

  Widget _getEnterAmountSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                child: Text(
                  'Enter Amount',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '\$',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30.0),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                          decoration: InputDecoration(
                              hintText: 'Amount',
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30.0)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBankCardSection() {
    return Container(

      margin: EdgeInsets.all(16.0),
//      height: 200.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Bank Accounts',
                    style:
                    TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _getBankCard(index);
                }),
          ),

        /*  Container(
            margin: EdgeInsets.symmetric(vertical: 20.0),
            child: GestureDetector(
              onTapUp: (tapDetail) {},
              child: Text('ADD A NEW BANK ACCOUNT',
                  style: TextStyle(

                      fontSize: 14.0,
                      fontWeight: FontWeight.bold)),
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _getBankCard(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
      height: 150,

      child:Card(
          margin: EdgeInsets.all(5),
          color:Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(11.0))),
          child:Column(children: [
        Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('XXXX XXXX XXXX 9898',style: TextStyle(color: Colors.black),),
                )),

           IconButton(icon: Icon(Icons.arrow_forward_ios), onPressed:() {



           },)
           /* Radio(
              activeColor: Colors.green,
              value: index,
              groupValue: selectedCardIndex,
              onChanged: (value) {
                selectedCardIndex = value;
                setState(() {});
              },
            )*/
          ],
        ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Set as primary',style: TextStyle(color: Colors.black),),
                    )),


                 Radio(
              activeColor: Colors.green,
              value: index,
              groupValue: selectedCardIndex,
              onChanged: (value) {
                selectedCardIndex = value;
                setState(() {});
              },
            )
              ],
            ),
        Row(
          children: <Widget>[
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Balance: \$7900',style: TextStyle(color: Colors.black),),
                )),
            Text('CHECK BALANCE',style: TextStyle(color: Rmyellow),),
            SizedBox(width: 10,)
          ],
        ),

      ],),)
    );
  }

  Widget _getSendSection() {
    return Container(
     // margin: EdgeInsets.all(16.0),
      child: GestureDetector(
        onTapUp: (tapDetail) {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        },
        child: Container(
          width: double.infinity,
          height: 50.0,
          decoration: BoxDecoration(
              color: Rmblue,
              ),
          padding:
          EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            'ADD NEW BANK ACCOUNT',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}