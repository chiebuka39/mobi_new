class Bank{
  String accountName;
  String accountNum;
  String bankName;

  Bank({this.bankName,this.accountName,this.accountNum});

  static Bank fromMap(Map<String, dynamic> map){
    print("llln $map");
    return Bank(
      bankName: map['account_name'],
      accountNum: map['account_num'],
      accountName: map['bank_name'],
    );

  }
}