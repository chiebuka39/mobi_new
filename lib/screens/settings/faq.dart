import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobi/extras/colors.dart';
import 'package:mobi/extras/strings.dart';
import 'package:mobi/widgets/primary_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FaqScreen extends StatefulWidget {
  @override
  _FaqScreenState createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {


  var general = ["Why choose mobiride?","Can drivers pickup more than one?","How can i Share my ride?", "How can i set my pickup point?", "Is the ride free?"];
  var colors = [Colors.blueAccent, Colors.redAccent];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            BackButton(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                child: Text(
                  "How can we help you ?",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                constraints: BoxConstraints(maxWidth: 200),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Frequently asked",
                style: TextStyle(color: primaryColor),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  String title = MyStrings.faq[index];
                  List<String> content = MyStrings.faqContent[index];
                  return  InkWell(
                    onTap: (){
                      showModalBottomSheet(context: context, builder: (context){
                        return FaqContentWidget(title: title, content: content);
                      });
                    },
                      child: FrequentlyAskedWidget(color: faqColors[index],question: MyStrings.faq[index],));
                },
                itemCount: MyStrings.faq.length,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                "Others",
                style: TextStyle(color: primaryColor),
              ),
            ),
            SizedBox(height: 5,),
            Column(children: <Widget>[
              for(var x in MyStrings.othersFaq)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: (){
                    showModalBottomSheet(context: context, builder: (context){
                      return FaqContentWidget(title: x, content: MyStrings.faqOthersContent[MyStrings.othersFaq.indexOf(x)]);
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey,width: .3))),
                      height: 70,
                      child: Row(
                        children: <Widget>[
                          Text(x, style: TextStyle(fontSize: 16),),
                          Spacer(),
                          Icon(Icons.navigate_next)
                        ],
                      )),
                ),
              ),
            ],)

          ],
        ),
      ),
    );
  }
}

class FaqContentWidget extends StatelessWidget {
  const FaqContentWidget({
    Key key,
    @required this.title,
    @required this.content,
  }) : super(key: key);

  final String title;
  final List<String> content;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 40,),
            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            SizedBox(height: 25,),
            for(var x in content)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(x,
                style: TextStyle(fontSize: 18),),
            ),

            Spacer(),
            SecondaryButton(title: "Done",handleClick: (){
              Navigator.of(context).pop();
            },width: double.infinity,horizontalPadding: 20,),
            SizedBox(height: 20,),

          ],),
      ),
    );
  }
}

class FrequentlyAskedWidget extends StatelessWidget {
  final String question;
  final Color color;
  const FrequentlyAskedWidget({
    Key key,@required this.question,@required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Card(
        color: color,
        child: Container(
          padding: EdgeInsets.all(7),
          height: 100,
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(),
              ConstrainedBox(
                child: Text(
                  question,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                constraints: BoxConstraints(maxWidth: 150),
              ),
              Spacer(),
              Row(children: <Widget>[
                Icon(Icons.person_outline, color: Colors.white,),
                SizedBox(width: 10,),
                Text("General", style: TextStyle(color: Colors.white),)
              ],)
            ],
          ),
        ),
      ),
    );
  }
}
