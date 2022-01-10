import 'package:hive/hive.dart';

part 'secondary_state.g.dart';

@HiveType(typeId: 5)
class SecondaryState extends HiveObject{

  @HiveField(0)
  bool isLoggedIn = false;

  SecondaryState(this.isLoggedIn);
}