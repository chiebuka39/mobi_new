import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/margins.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/bank.dart';
import 'package:mobi/models/user.dart';
import 'package:mobi/screens/tabs/wallet/transaction_detail.dart';

import 'package:mobi/viewmodels/payment_view_model.dart';
import 'package:mobi/viewmodels/user_view_model.dart';
import 'package:mobi/widgets/cvv_input.dart';
import 'package:mobi/widgets/new/bottom_sheets.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  WalletScreen({Key key});
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> with AfterLayoutMixin<WalletScreen> {
  UserModel _userModel;
  PaymentViewModel _paymentViewModel;
  bool _loading = true;
  Bank bank;

  List<MobiTransaction> transactions = [];
  PaystackPlugin paystackPlugin = PaystackPlugin();



  @override
  void initState() {
    //print("pppppppp mmm ${DotEnv().env['PAYSTACK_TEST']}");
    paystackPlugin.initialize(
        publicKey: MyStrings.paystackPublicKey());
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
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
    _paymentViewModel.fetchBankTransferDetails().then((value) {
      if(value.error == false){
        setState(() {
          bank = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final oCcy = new NumberFormat("#,##0", "en_US");
    _userModel = Provider.of<UserModel>(context);
    _paymentViewModel = Provider.of<PaymentViewModel>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(delegate: SliverChildListDelegate([
              SizedBox(height: 45,),
              Text("Wallet", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Text("Balance", style: TextStyle(fontSize: 12),),
              Text("NGN ${oCcy.format(_userModel.user.balance)}", style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Row(children: <Widget>[
                SecondaryButton(
                  elevation: 0,
                  title: "Add Money",
                  handleClick: pay,
                  width: (MediaQuery.of(context).size.width - 60) /2,
                ),
                Spacer(),
                SecondaryOutlineButton(
                  title: "Withdraw",
                  elevation: 0,
                  handleClick: null,
                  width: (MediaQuery.of(context).size.width - 60) /2,
                )
              ],),
              YMargin(20),
              InkWell(
                onTap: (){
                  showModalBottomSheet < Null > (context: context, builder: (BuildContext context) {
                    return ShowBankDetailsWidget(bank: bank,);
                  });
                },
                  child: Text("Fund With Transfer", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),)),
              SizedBox(height: 40,),
              Row(children: <Widget>[
                Text("Transactions".toUpperCase()),
                Spacer(),
                Text("View all".toUpperCase(),
                  style: TextStyle(color: primaryColor,fontSize: 12),)
              ],),
              SizedBox(height: 20,),
            ]),),
            SliverList(delegate: SliverChildBuilderDelegate((context,index){
              var transaction = transactions[index];
              print("kkk ${transaction.type}");
              var icon = getIconName(transaction);
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => TransactionDetailScreen(transaction: transaction,)));
                },
                child: Container(
                  height: 70,
                  child: Row(children: <Widget>[
                    SvgPicture.asset("assets/img/${icon}.svg"),
                    SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Text(getTitle(transaction),style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      Text(MyUtils.getDateTitle(transaction.date),style: TextStyle(color: Colors.black.withOpacity(0.5)),)
                    ],),
                    Spacer(),
                    Text("${transaction.iDto == _userModel.user.phoneNumber ? "+":"-"} NGN ${transaction.amount}", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),)
                  ],),
                ),
              );
            }, childCount: transactions.length <=5 ? transactions.length : 5),)
          ],
        ),
      ),
    );
  }

  String getTitle(MobiTransaction transaction) {
    if(transaction.type == TransactionType.TOP_UP){
     return  "Wallet Top up";
    }else if(transaction.type == TransactionType.COUPON){
      return  "Coupon Top up";
    }else if(transaction.iDto == _userModel.user.phoneNumber){
      return  "Recieved payment for....";
    }
    else{
      return  "Payed for .....";
    }
  }

  String getIconName(MobiTransaction transaction) {
    if(transaction.type == TransactionType.TOP_UP){
      return 'top_up';
    }
    else if(transaction.iDto == _userModel.user.phoneNumber){
      return 'recieve';
    }else if(transaction.iDfrom == _userModel.user.phoneNumber){
      return 'send';
    }else{
      return 'top_up';
    }
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
      var response = await paystackPlugin.checkout(context,
          charge: charge, method: CheckoutMethod.card);
      if (!response.status) {
        print("Payment failed");
      } else {

        var result = await _paymentViewModel.createTransaction(transaction: MobiTransaction(
            title: 'Payment to wallet',
            description: 'You just credited your wallet with NGN$amount',
            type: TransactionType.TOP_UP,
            amount: int.parse(amount),
            userFrom: _userModel.user.fullName,
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

  _dummyPay()async{
    var result = await _paymentViewModel.createTransaction(transaction: MobiTransaction(
        title: 'Payment for a trip',
        description: 'Payment of a trip',
        type: TransactionType.PAYMENT,
        amount: int.parse("500"),
        userFrom: _userModel.user.fullName,
        userTo: "Gyan Samuel",
        iDfrom: _userModel.user.phoneNumber,
        users: [_userModel.user.phoneNumber, "+2348100001113"],
        iDto: "+2348100001113"),user: _userModel.user);
    print("result $result");

    if(result['error'] == false){
      _userModel.substractUserBalance(int.parse("500"));
      showSimpleNotification(Text("Money sent"), background: Colors.greenAccent);
    }else{
      showSimpleNotification(Text("Error occured"), background: Colors.redAccent);
    }
  }
}
