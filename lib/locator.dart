import 'package:get_it/get_it.dart';
import 'package:mobi/api/profile_api.dart';
import 'package:mobi/local/local_state.dart';
import 'package:mobi/services/chat_api.dart';
import 'package:mobi/services/payment_api.dart';
import 'package:mobi/services/places_detail_api.dart';
import 'package:mobi/services/places_details_repo.dart';
import 'package:mobi/services/places_prediction_api.dart';
import 'package:mobi/services/places_prediction_repo.dart';
import 'package:mobi/services/rides_service/coupons_service.dart';
import 'package:mobi/services/rides_service/rides_service.dart';
import 'package:mobi/viewmodels/user_repo.dart';

import 'extras/app_config.dart';
import 'services/dialogs/dialog_service.dart';
import 'services/rides_service/rides_api.dart';

GetIt locator = GetIt.asNewInstance();

void setUpLocator(){
  locator.registerLazySingleton(() => ProfileRepository());
  locator.registerLazySingleton(() => PlacesPredictionRepository());
  locator.registerLazySingleton(() => PlaceDetailsRepository());
  locator.registerLazySingleton(() => RidesService());
  locator.registerLazySingleton<ACouponService>(() => CouponService());

//  locator.registerLazySingleton(() => AppConfig());

  locator.registerLazySingleton(() => DialogService());


  locator.registerLazySingleton(() => ProfileApi ());
  locator.registerLazySingleton<ABSPaymentApi>(() => FirestorePaymentApi());
  locator.registerLazySingleton(() => PlacesPredictionApi ());
  locator.registerLazySingleton(() => PlaceDetailsApi ());
  locator.registerLazySingleton(() => RidesApi ());
  locator.registerLazySingleton<ABSChatApi>(() => FirestoreChatApi ());

  locator.registerLazySingleton<ABSAppStateLocalStorage>(() => AppStateBoxStorage());

}
void reset(){
  //locator.resetL
}