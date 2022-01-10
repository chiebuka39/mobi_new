import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/viewmodels/payment_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/cvv_input.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';

String backendUrl = 'https://mobiride.herokuapp.com';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with AfterLayoutMixin<WalletScreen> {
  UserModel _userModel;
  PaymentViewModel _paymentViewModel;
  bool _loading = true;

  List<MobiTransaction> transactions = [];

  @override
  void afterFirstLayout(BuildContext context) async {
    _userModel.checkAndGetUser();
    List<MobiTransaction> transactions2 = [];
    //_userModel.getUserTransactions2();
    _userModel.getUserTransactions().listen((snap){
      transactions2 = [];
      var documents = snap.docs;
      print(",,,,,,,,, ${documents.length}");
      documents.forEach((doc){
        transactions2.add(MobiTransaction.fromMap(doc.data()));
      });
      setState(() {
        transactions = transactions2;
        _loading = false;
      });
    });

  }

  @override
  void initState() {
    PaystackPlugin().initialize(
        publicKey: MyStrings.paystackPublicKey());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userModel = Provider.of<UserModel>(context);
    _paymentViewModel = Provider.of<PaymentViewModel>(context);

    return Scaffold(
      body: Container(
        height: MyUtils.buildSizeHeight(100),
        child: Stack(
          children: <Widget>[
            Container(
              height: MyUtils.buildSizeHeight(30),
              width: double.infinity,
              decoration: BoxDecoration(color: primaryColor),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: MyUtils.buildSizeHeight(5),
                    right: MyUtils.buildSizeWidth(-20),
                    child: Container(
                      width: MyUtils.buildSizeWidth(70),
                      height: MyUtils.buildSizeWidth(70),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          shape: BoxShape.circle),
                    ),
                  ),
                  Positioned(
                    top: MyUtils.buildSizeHeight(-5),
                    right: MyUtils.buildSizeWidth(-20),
                    child: Container(
                      width: MyUtils.buildSizeWidth(40),
                      height: MyUtils.buildSizeWidth(40),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          shape: BoxShape.circle),
                    ),
                  ),
                  Positioned(
                    top: MyUtils.buildSizeHeight(10),
                    left: MyUtils.buildSizeWidth(-20),
                    child: Container(
                      width: MyUtils.buildSizeWidth(50),
                      height: MyUtils.buildSizeWidth(50),
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.03),
                          shape: BoxShape.circle),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: MyUtils.buildSizeHeight(5),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: <Widget>[
                            BackButton(
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Total Balance",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30, top: 0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "NGN ${_userModel.user.balance}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 30,
                          ),
                          FlatButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(5)),
                            child: Text(
                              "Load Wallet",
                              style: TextStyle(),
                            ),
                            onPressed: pay,
                            //onPressed: pay,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          FlatButton(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadiusDirectional.circular(5),
                                side: BorderSide(color: Colors.white)),
                            child: Text(
                              "Withdraw",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Positioned(
              top: 230,
              left: 0,
              right: 0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Recent Transactions",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Expanded(
                      child: _loading == true
                          ? Container(
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : transactions.length == 0 ? Container(child: Center(child: Text("You have not made any transaction yet"),),) : ListView.builder(
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final fmf = "NGN";
                                final positiveOrNegate =
                                    transactions[index].type ==
                                            TransactionType.TOP_UP
                                        ? "+"
                                        : transactions[index].iDto == _userModel.user.phoneNumber ?"+": "-";
                                final icon = transactions[index].type ==
                                        TransactionType.DEBIT
                                    ? "debit"
                                    : "credit";
                                return Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      height: 52,
                                      width: 52,
                                      child: Material(
                                        child: Center(
                                            child: SvgPicture.asset(
                                          "assets/img/$icon.svg",
                                          height: 20,
                                        )),
                                        elevation: 2,
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          transactions[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),

                                      ],
                                    ),
                                    Spacer(),
                                    Text(
                                      "NGN ${transactions[index].amount}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                );
                              }),
                    )
                  ],
                ),
                height: MyUtils.buildSizeHeight(75),
                decoration: BoxDecoration(
                    color: Color(0xFFF9F9F9),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  pay() async {
    String amount = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: CVVInputSheet(),
          );
        });
    print("this is the amount ${double.parse(amount)}");
    if (amount != null && int.parse(amount) >= 1000) {
      Charge charge = new Charge()
        // Convert to kobo and round to the nearest whole number
        ..amount = (int.parse(amount) * 100).round()
        ..email = _userModel.user.emailAddress
        ..reference = _getReference();
      var response = await PaystackPlugin().checkout(context,
          charge: charge, method: CheckoutMethod.card);
      if (!response.status) {
        print("Payment failed");
      } else {

        var result = await _paymentViewModel.createTransaction(transaction: MobiTransaction(
            title: 'Payment to wallet',
            description: 'You just credited your wallet with NGN$amount',
            type: TransactionType.TOP_UP,
            amount: int.parse(amount),
            userFrom: "",
            userTo: _userModel.user.fullName,
            iDfrom: '',
            users: [_userModel.user.phoneNumber],
            iDto: _userModel.user.phoneNumber),user: _userModel.user);
        print("result $result");

        if(result['error'] == false){
          _userModel.setUserBalance(int.parse(amount));
        }


      }
    }
  }
}

class TransactionDetail {
  TransactionType type;
  String description;
  String title;
  String currency;
  double amount;

  TransactionDetail(
      {this.type,
      this.amount,
      this.title,
      this.currency = "NGN",
      this.description});
}
