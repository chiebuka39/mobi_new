import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobi/extras/utils.dart';

class MyStrings {

  static String verifiedMessage = "You need to add details of your car to continue";

  static List<String> intToStringMonth = [
    "",
    "January",
    "Febuary",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  static List<String> intToStringMonthSemi = [
    "",
    "Jan",
    "Feb",
    "March",
    "April",
    "May",
    "June",
    "July",
    "Aug",
    "Sept",
    "Oct",
    "Nov",
    "Dec"
  ];


  static List<String> intToStringDayOfWeek = [
    "",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  static List<String> intToStringDayOfWeekShort = [
    "",
    "Mon",
    "Tue",
    "Wed",
    "Thur",
    "Fri",
    "Sat",
    "Sun"
  ];

  static String shareNEarn = "Earn cash rewards when you share mobiride with your friends and the get take their first ride, your friends also get NGN200 when they sign up with your link ";

  static String transactions = "transactions";

  static String state = "state";

  static String dayOfmonth(int day){
    if(day == 1 || day == 21 || day == 31){
      return "$day"+"st";
    }else if(day == 2 || day == 22){
      return "$day"+"nd";
    }else if(day == 3 || day == 23){
      return "$day"+"rd";
    }else{
      return "$day"+"th";
    }

  }

  static String numToString(int value){
    if(value == 1){
      return "One";
    }else if(value == 2){
      return "Two";
    }else if(value == 3){
      return "Three";
    }else if(value == 4){
      return "Four";
    }else if(value == 5){
      return "Five";
    }else if(value == 6){
      return "Six";
    }else if(value == 7){
      return "Seven";
    }else if(value == 8){
      return "Eight";
    }else if(value == 9){
      return "Nine";
    }
    else{
      return "Ten";
    }

  }

  static String noPlannedRides = "You do not have any planned rides yet";

  static String profileCreated = "profile_created";
  static String loggedUser = "logged_user";
  static String scheduledRide = "scheduled_ride";
  static String appOpened = "app_opened";
  static String apiKey = "AIzaSyD6yE7cukLA7fkc1gRB7RifQFb2XZSecvA";

  static String appStoreLink() {
    return Platform.isIOS
        ? 'itms-apps://itunes.apple.com/app/id14181578143'
        : 'market://details?id=me.mobbid.mobiride';
  }

  static String users() {
    if(isInDebugMode){
      return "users";
    }else{
      return "users_production";
    }
  }

  static String address() {
    if(isInDebugMode){
      return "adresses";
    }else{
      return "adresses_production";
    }
  }

  static String coupons() {
    if(isInDebugMode){
      return "coupons";
    }else{
      return "coupons_production";
    }
  }

  static String rides() {
    if(isInDebugMode){
      return "rides";
    }else{
      return "rides_production";
    }
  }
  static String search_rides() {
    if(isInDebugMode){
      return "search_rides";
    }else{
      return "search_rides_production";
    }
  }

  static String rideRatings() {
    if(isInDebugMode){
      return "rides_ratings";
    }else{
      return "rides_ratings_production";
    }
  }

  static String profileLocation(String number) {
    if(isInDebugMode){
      return "$number.jpg";
    }else{
      return "profile/$number.jpg";
    }
  }
  static String userDocsLocation(String userId,String docType) {
      return "$userId/$docType.jpg";

  }

  static String help = "Help Mobiride grow by inviting your friends, they get a free ride and so do you";
  static String noOne = "There is no one going your way";

  static paystackPublicKey() {
    if (isInDebugMode) {
      return DotEnv().env['PAYSTACK_TEST'];
    } else {
      return DotEnv().env['PAYSTACK_LIVE'];;
    }
  }
//  }static paystackPublicKey() {
//    if(isInDebugMode){
//      return 'pk_test_f19911920c3004ac8e396fcd187deb4369afc5f5';
//    }else{
//      return 'pk_live_a5b9c09f9e0dec12e995ac5209a4dce2e5710f9b';
//    }
//
//  }

  static paystackSecretKey() {
    return 'sk_test_8048763b6f9f68668be30e5986001f38b2e3d63d';
  }

  static List<String> faq = ["How does Mobiride work?",
    "Who will i carpool with?","How does payment work?","Can drivers pick up more than one rider?"];
  static List<String> othersFaq = [
    "How can i set my pickup point?",
    "Is the ride free?",
    "What if I forget something in the car?",
  ];

  static List<List<String>> faqContent = [
    ['Go to App Store or Playstore and Download Mobiride.',
      'If you are a car owner, choose the option of driving while setting up, '
          'finish your up by getting verified within minutes and start '
          'scheduling your next rides.',
          ' If you are a rider, you can choose that option while setting up your account, '
              'finish up and get verified and you can start by searching for rides around you'
    ],
    [
      'Commuters in your area who use Mobiride for their daily commutes',
      'Your matches are based on criteria like route, and walking distance (if you’re a rider).',
      'Mobiride offers a more personalized options as you can decide to carpool based on gender, ',
      'people you are familiar with (on social media or street neighbours) '
          'and your co-workers or thosewho work very close to your organisation'
    ],
    [
      'Mobiride advocates for more cashless transactions by encouraging users to top '
          'up their wallets from their bank using our secured mode of payment.',
      'Your payment is confirmed once you start your ride '
          'and the car owner automatically gets the payment.',
      'Our payment plan helps you solve the problem of sorting balance '
          'and helps car owners get immediate payment without any hassle.',
    ],
    [
      'Yes,',
      'Depending on the type of car, car owners can take up to 5 additional commuters in their cars.'
    ]
  ];
  static String avatar = 'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y';

  static List<List<String>> faqOthersContent = [
    [
      'To set your pickup point after requesting for a ride is quite simple',
      'After You have been accepted for a ride, ',
      'You can lias with the driver by the in built chat as to where you want to be picked from',
    ],
    [
      'Rides can be free',
      'Depending on who is the host of the ride, ',
      'So Mobiride does not have any say in the price of a ride.',
    ],
    [
      'You will always be notified after every ride to check for probable forgotten items. ',
      'If this does not work, you can count on Mobiride to reconnect you back to the car owner to '
          'retrieve your forgotten items at a very convenient place',
      'We encourage you to turn on our notification on your devices so you can getreal time updates like this'
    ]

  ];
  

  
  //String users = "users_production";
//  static String apiKey2 = "AIzaSyD6yE7cukLA7fkc1gRB7RifQFb2XZSecvA";
}
