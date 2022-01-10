
import 'package:firebase_analytics/firebase_analytics.dart';

class MyAnalytics{
  static FirebaseAnalytics analytics = FirebaseAnalytics();

  static sendTestEvent() async {
    await analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0,
        'bool': true,
      },
    );
  }
}

