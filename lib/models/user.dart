import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobi/extras/enums.dart';
import 'package:mobi/extras/utils.dart';
import 'package:mobi/models/details.dart';
import 'package:mobi/models/driving.dart';
import 'package:mobi/models/location.dart';


part 'user.g.dart';

User userFromJson(String str) => User.fromMap(json.decode(str));
//List<CountryMerchants> countryMerchantsFromJson(String str) => new List<CountryMerchants>.from(json.decode(str).map((x) => CountryMerchants.fromJson(x)));
String userToJson(User data) {
  return json.encode(data.toMap());
}



@HiveType(typeId: 1)
class User {

  @HiveField(0)
  String fullName;

  @HiveField(1)
  String emailAddress;

  @HiveField(2)
  String phoneNumber;


  String firebaseToken;

  @HiveField(3)
  String work;

  @HiveField(4)
  String jobDesc;

  @HiveField(5)
  dynamic balance;

  @HiveField(6)
  double couponBalance;

  @HiveField(7)
  double couponBalanceWithdrawn;

  @HiveField(8)
  TheLocation homeLocation;

  @HiveField(9)
  TheLocation workLocation;

  @HiveField(10)
  DrivingState drivingState;

  @HiveField(11)
  double ratings;

  @HiveField(12)
  bool verified;

  @HiveField(13)
  CarDetails carDetails;

  @HiveField(14)
  String avatar;

  @HiveField(15)
  String workIdentityUrl;

  @HiveField(16)
  List<String> scheduledRideIds;

  @HiveField(17)
  String couponId;

  @HiveField(18)
  SocialAccounts accounts;

  @HiveField(19)
  DateTime dateJoined;

  @HiveField(20)
  DateTime dateUpdated;
  @HiveField(21)
  TimeOfDayCustom leaveForWork;
  @HiveField(22)
  TimeOfDayCustom leaveForHome;

  @HiveField(23)
  List<TheLocation> churchLocations;
  List<String> usedCoupons;

  User(
      {this.fullName,
      this.emailAddress,
      this.phoneNumber ,
      this.carDetails,
        this.firebaseToken,
      this.drivingState,
      this.homeLocation,
      this.avatar,
      this.balance,
      this.ratings,
        this.work,
        this.jobDesc,
      this.verified,
      this.workLocation,
      this.workIdentityUrl,
      this.couponId,
      this.accounts,
        this.dateJoined,
        this.leaveForHome,
        this.leaveForWork,
        this.usedCoupons,
        this.dateUpdated,
      this.scheduledRideIds,
        this.couponBalance,
        this.couponBalanceWithdrawn,
      });
  User.initial();

  static User fromUser(User user){
    User user1 = User();

    user1.fullName = user.fullName;
    user1.jobDesc = user.jobDesc;
    user1.work = user.work;
    user1.carDetails = user.carDetails;
    user1.phoneNumber = user.phoneNumber;
    user1.workIdentityUrl = user.workIdentityUrl;
    user1.avatar = user.avatar;
    user1.couponId = user.couponId;
    user1.workLocation = user.workLocation;
    user1.homeLocation = user.homeLocation;
    user1.emailAddress = user.emailAddress;
    user1.drivingState = user.drivingState;
    user1.dateJoined = user.dateJoined;
    user1.dateUpdated = user.dateUpdated;
    user1.verified = user.verified;
    user1.ratings = user.ratings;
    user1.balance = user.balance;
    user1.accounts = user.accounts;
    user1.balance = user.balance;
    user1.scheduledRideIds = user.scheduledRideIds;
    user1.leaveForWork = user.leaveForWork;
    user1.leaveForHome = user.leaveForHome;
    user1.usedCoupons = user.usedCoupons;
    user1.workIdentityUrl = user.workIdentityUrl;
    user1.couponBalance = user.couponBalance;
    user1.couponBalanceWithdrawn = user.couponBalanceWithdrawn;
    return user1;
  }

  Map<String, dynamic> toMap() {
    var userMap = Map<String, dynamic>();
    userMap['name'] = fullName != null ? fullName : '';
    userMap['leave_for_work'] = leaveForWork != null ? "${leaveForWork.hour}:${leaveForWork.minute}" : '07:00';
    userMap['leave_for_home'] = leaveForHome != null ? "${leaveForHome.hour}:${leaveForHome.minute}" : '17:10';
    userMap['phone_number'] = phoneNumber != null ? phoneNumber : '';
    userMap['email_address'] = emailAddress != null ? emailAddress : '';
    userMap['work'] = work != null ? work : '';
    userMap['job_desc'] = jobDesc != null ? jobDesc : '';
    userMap['car_details'] = carDetails != null
        ? CarDetails.toMap(carDetails)
        : Map<String, dynamic>();
    userMap['work_location'] = workLocation != null
        ? TheLocation.toMap(workLocation)
        : Map<String, dynamic>();
    userMap['home_location'] = homeLocation != null
        ? TheLocation.toMap(homeLocation)
        : Map<String, dynamic>();
    userMap['drive_state'] =
        drivingState != null ? fromDrivingState(drivingState) : 0;
    userMap['ratings'] = ratings != null ? ratings : 0.0;
    userMap['balance'] = balance != null  ? balance : 0.0;
    userMap['coupon_balance'] = couponBalance != null ? couponBalance : 0.0;
    userMap['coupon_balance_withdrawn'] = couponBalanceWithdrawn != null ? couponBalanceWithdrawn : 0.0;
    userMap['verified'] = verified != null ? verified : false;
    userMap['id_url'] = avatar != null ? avatar : '';
    userMap['profile_url'] = workIdentityUrl != null ? workIdentityUrl : '';
    userMap['schedule_ride_ids'] = scheduledRideIds != null ? scheduledRideIds : [];
    userMap['coupon_id'] = couponId != null ? couponId : '';
    userMap['used_coupons'] = usedCoupons != null ? usedCoupons : [];
    userMap['date_joined'] = dateJoined.millisecondsSinceEpoch != null ? dateJoined.millisecondsSinceEpoch : Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    userMap['date_updated'] = dateUpdated != null ? dateUpdated.millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch;
    userMap['accounts'] = accounts != null ? SocialAccounts.toMap(accounts) : Map<String, dynamic>();

    pprint("this is the work ${userMap['leave_for_work']}");
    return userMap;
  }
  Map<String, dynamic> toFirestore() {
    var userMap = Map<String, dynamic>();
    userMap['name'] = fullName != null ? fullName : '';
    userMap['leave_for_work'] = leaveForWork != null ? "${leaveForWork.hour}:${leaveForWork.minute}" : '07:00';
    userMap['leave_for_home'] = leaveForHome != null ? "${leaveForHome.hour}:${leaveForHome.minute}" : '17:10';
    userMap['firebase_token'] = firebaseToken != null ? firebaseToken : '';
    userMap['phone_number'] = phoneNumber != null ? phoneNumber : '';
    userMap['email_address'] = emailAddress != null ? emailAddress : '';
    userMap['work'] = work != null ? work : '';
    userMap['job_desc'] = jobDesc != null ? jobDesc : '';
    userMap['car_details'] = carDetails != null
        ? CarDetails.toMap(carDetails)
        : Map<String, dynamic>();
    userMap['work_location'] = workLocation != null
        ? TheLocation.toMap(workLocation)
        : Map<String, dynamic>();
    userMap['home_location'] = homeLocation != null
        ? TheLocation.toMap(homeLocation)
        : Map<String, dynamic>();
    userMap['drive_state'] =
        drivingState != null ? fromDrivingState(drivingState) : 0;
    userMap['ratings'] = ratings != null ? ratings : 0.0;
    userMap['balance'] = balance != null ? balance : 0.0;
    userMap['coupon_balance'] = couponBalance != null ? couponBalance : 0.0;
    userMap['coupon_balance_withdrawn'] = couponBalanceWithdrawn != null ? couponBalanceWithdrawn : 0.0;
    userMap['verified'] = verified != null ? verified : false;
    userMap['id_url'] = avatar != null ? avatar : '';
    userMap['profile_url'] = workIdentityUrl != null ? workIdentityUrl : '';
    userMap['schedule_ride_ids'] = scheduledRideIds != null ? scheduledRideIds : [];
    userMap['coupon_id'] = couponId != null ? couponId : '';
    userMap['used_coupons'] = usedCoupons != null ? usedCoupons : [];
 userMap['date_joined'] = dateJoined.millisecondsSinceEpoch != null ? dateJoined.millisecondsSinceEpoch : Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    userMap['date_updated'] = dateUpdated != null ? Timestamp.fromDate(dateUpdated) : Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch);
    userMap['accounts'] = accounts != null ? SocialAccounts.toMap(accounts) : Map<String, dynamic>();

    return userMap;
  }

  Map<String, dynamic> toPersonalFirestore() {
    var userMap = Map<String, dynamic>();
    userMap['name'] = fullName != null ? fullName : '';
    userMap['id_url'] = avatar != null ? avatar : '';
    userMap['date_updated'] = Timestamp.now();
    userMap['email_address'] = emailAddress != null ? emailAddress : '';


    userMap['drive_state'] =
        drivingState != null ? fromDrivingState(drivingState) : 0;

    return userMap;
  }

  Map<String, dynamic> toWorkFirestore() {
    var userMap = Map<String, dynamic>();
    userMap['work'] = work != null ? work : '';
    userMap['date_updated'] = Timestamp.now();
    userMap['profile_url'] = workIdentityUrl != null ? workIdentityUrl : '';
    userMap['job_desc'] = jobDesc != null ? jobDesc : '';


    return userMap;
  }

  static User fromMap(Map<String, dynamic> map) {
    var user = User(
        fullName: map['name'],
        leaveForHome: map['leave_for_home'] == null ?
        TimeOfDayCustom(hour: 17,minute: 10) :TimeOfDay(
            hour: int.parse(map['leave_for_home'].toString().split(":")[0]),
            minute: int.parse(map['leave_for_home'].toString().split(":")[1]),
        ),
        leaveForWork: map['leave_for_work'] == null ?
        TimeOfDayCustom(hour: 7,minute: 0) :TimeOfDay(
          hour: int.parse(map['leave_for_work'].toString().split(":")[0]),
          minute: int.parse(map['leave_for_work'].toString().split(":")[1]),
        ),
        phoneNumber: map['phone_number'],
        firebaseToken: map['firebase_token'],
        emailAddress: map['email_address'],
        work: map['work'],
        jobDesc: map['job_desc'] ?? '',
        carDetails: CarDetails.fromMap(map['car_details']),
        accounts: SocialAccounts.fromMap(map['accounts'] ),
        workLocation: TheLocation.fromMap(map['work_location']),
        homeLocation: TheLocation.fromMap(map['home_location']),
        drivingState: getDrivingState(map['drive_state']),
        ratings: map['ratings'],
        balance: map['balance'] != null ? (map['balance'] as num).isNaN ? 0.0:map['balance']:0.0,
        couponBalance: map['coupon_balance'] ?? 0.0,
        couponBalanceWithdrawn: map['coupon_balance_withdrawn'] ?? 0.0,
        verified: map['verified'],
        dateJoined: map['date_joined'] != null ? DateTime.fromMillisecondsSinceEpoch( map['date_joined']): DateTime.now(),
        dateUpdated: map['date_updated'] != null ? DateTime.fromMillisecondsSinceEpoch( map['date_updated']): DateTime.now(),
        avatar: map['id_url'],
        usedCoupons: map['used_coupons'] != null ?
        List.from(map['used_coupons']).map((admin) => admin.toString()).toList(): [],
        scheduledRideIds: map['schedule_ride_ids'],
        couponId: map['coupon_id'] ?? '',
        workIdentityUrl: map['profile_url'] ?? '');
    return user;
  }

  static User fromFirestore(Map<String, dynamic> map) {
    print("opooop $map");
    return User(
        fullName: map['name'],
        leaveForHome: map['leave_for_home'] == null ?
        TimeOfDayCustom(hour: 17,minute: 10) :TimeOfDayCustom(
          hour: int.parse(map['leave_for_home'].toString().split(":")[0]),
          minute: int.parse(map['leave_for_home'].toString().split(":")[1]),
        ),
        leaveForWork: map['leave_for_work'] == null ?
        TimeOfDayCustom(hour: 7,minute: 0) :TimeOfDayCustom(
          hour: int.parse(map['leave_for_work'].toString().split(":")[0]),
          minute: int.parse(map['leave_for_work'].toString().split(":")[1]),
        ),
        firebaseToken: map['firebase_token'],
        phoneNumber: map['phone_number'],
        emailAddress: map['email_address'],
        work: map['work'],
        jobDesc: map['job_desc'] ?? '',
        balance: map['balance'] != null ? (map['balance'] as num).isNaN ? 0.0:map['balance']:0.0,
        couponBalance: map['coupon_balance'] ?? 0.0,
        couponBalanceWithdrawn: map['coupon_balance_withdrawn'] ?? 0.0,
        carDetails: CarDetails.fromMap(map['car_details']),
        workLocation: TheLocation.fromFirestore(map['work_location']),
        homeLocation: TheLocation.fromFirestore(map['home_location']),
        drivingState: getDrivingState(map['drive_state']),
        accounts: SocialAccounts.fromMap(map['accounts']),
        ratings: map['ratings'],
        verified: map['verified'],
        avatar: map['id_url'],
        dateJoined: map['date_joined'] != null ?  DateTime.fromMillisecondsSinceEpoch(map['date_joined']):DateTime.now(),
        dateUpdated: map['date_updated'] != null ? DateTime.fromMillisecondsSinceEpoch( (map['date_updated'] as Timestamp).millisecondsSinceEpoch): DateTime.now(),
        couponId: map['coupon_id'] ?? '',

        scheduledRideIds:  map['schedule_ride_ids'] != null ?
        List.from(map['schedule_ride_ids']).map((admin) => admin.toString()).toList(): [],
        usedCoupons: map['used_coupons'] != null ?
        List.from(map['used_coupons']).map((admin) => admin.toString()).toList(): [],
        workIdentityUrl: map['profile_url'] ?? '');
  }

  static List<User> listFromFirestore(List<DocumentSnapshot> docs){
    List<User> users = [];
    docs.forEach((doc){
      Map<String, dynamic> map = doc.data();
      users.add(User.fromFirestore(map));
    });


    return users;
  }

  static DrivingState getDrivingState(int num) {
    pprint("driving state: $num");
    if(num == 0) {
      return DrivingState.Does_Not_Drive;
    } else if (num == 1) {
      return DrivingState.Drives;
    } else {
      return DrivingState.Drives_Once_A_While;
    }
  }

  static int fromDrivingState(DrivingState state) {
    if (state == DrivingState.Does_Not_Drive) {
      return 0;
    } else if (state == DrivingState.Drives) {
      return 1;
    } else {
      return 2;
    }
  }
}









class MobiTransaction{

  TransactionType type;
  String description;
  String title;
  int amount;
  String userTo;
  String userFrom;
  String iDto;
  String iDfrom;
  DateTime date;
  List<dynamic> users;


  MobiTransaction({
    this.title, this.type, this.amount, 
    this.description, this.iDfrom, this.iDto, this.userFrom, this.userTo, this.users, this.date
  });

  static fromMap(Map<String, dynamic> map) {

    pprint("hhhh $map");
    return MobiTransaction(
        title: map != null ? map['title'] : '',
        description: map != null ? map['description'] : '',
        amount: map != null ?  (map['amount'] is double ? (map['amount'] as double).toInt():map['amount']): '',
        iDfrom: map != null ? map['id_from'] : '',
        iDto: map != null ? map['id_to'] : '',
        userFrom: map != null ? map['user_from'] : '',
        userTo: map != null ? map['user_to'] : '',
        users: map != null ? map['users']: [],
        date: map['date'] != null ? DateTime.fromMillisecondsSinceEpoch(
            (map['date'] as Timestamp).millisecondsSinceEpoch): DateTime.now(),
        type: map != null ? MobiTransaction.getTransactionType(map['type']) : TransactionType.DEBIT);
  }

   Map<dynamic, dynamic> toMap2(MobiTransaction transaction) {
    return {
      'title': transaction.title ?? '',
      'description': transaction.description ?? '',
      'type': transaction.type ?? TransactionType.CREDIT,
      'amount':transaction.amount ?? 0.0,
      'id_from': transaction.iDfrom ?? '',
      'id_to': transaction.iDto ?? '',
      'date' :date == null ? Timestamp.now(): Timestamp.fromDate(date),
      'user_from': transaction.userFrom ?? '',
      'user_to':transaction.userTo ?? '',
      'users': transaction.users ?? []
    };
  }

  static Map<String, dynamic> toMap(MobiTransaction transaction) {
    var social = Map<String, dynamic>();
    social['title'] = transaction.title ?? 0;
    social['description'] = transaction.description ?? '';
    social['amount'] = transaction.amount ?? '';
    social['type'] =  MobiTransaction.fromTransactionType(transaction.type) ?? 0;
    social['id_from']= transaction.iDfrom ?? '';
    social['id_to']= transaction.iDto ?? '';
    social['user_from'] = transaction.userFrom ?? '';
    social['users'] = transaction.users ?? [];
    social['date'] = transaction.date == null ? Timestamp.now(): Timestamp.fromDate(transaction.date);
    social['user_to'] =transaction.userTo ?? '';

    return social;
  }

  static TransactionType getTransactionType(int num) {
    pprint("driving state: $num");
    if(num == 0) {
      return TransactionType.TOP_UP;
    } else if (num == 1) {
      return TransactionType.COUPON;
    }
    else if (num == 2) {
      return TransactionType.PAYMENT;
    } else {
      return TransactionType.CREDIT;
    }
  }

  static int fromTransactionType(TransactionType type) {
    pprint("inside Transaction type state: $type");
    if (type == TransactionType.TOP_UP) {
      return 0;
    } else if (type == TransactionType.COUPON) {
      return 1;
    }
    else if (type == TransactionType.PAYMENT) {
      return 2;
    } else {
      return 3;
    }
  }
}


