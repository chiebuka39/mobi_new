import 'package:flutter/material.dart';

class BarItem{
  final IconData icon;
  final String iconSvg;
  final String text;

  BarItem( {@required this.icon,@required this.text, this.iconSvg,});

}

final List<BarItem> items = [
  BarItem(text: "Home", icon: Icons.home),
  BarItem(text: "Trips", icon: Icons.show_chart),
  BarItem(text: "Wallet", iconSvg: "wallet",icon: Icons.account_balance_wallet),
  BarItem(text: "Settings", icon: Icons.settings),
];
