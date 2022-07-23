@JS('messageHandler')
library messageHandler;

import 'package:js/js.dart';

@JS('Address')
class Address {
  external factory Address(AddressOptions options);

  external String get addressZoneCode;

  external String get addressBasic;

  external String get addressDetail;

  external open(String url);

  external postMessage(String data);
}

// 자바스크립트 라이브러리로 넘겨줄 파라미터를 위한 것
@anonymous
@JS()
class AddressOptions {
  external String get addressZoneCode;

  external String get addressDetail;

  // javascript 는 object 형태가 있지만, dart 에는 없기 때문에 object 형태의 클래스를 만들어서 넘겨주어야 함
  external factory AddressOptions(
      {String addressZoneCode, String addressBasic, String addressDetail});
}

// 데이터를 가져오기 위해 javascript 라이브러리에 넘겨주기 위한 인자를 위해 만든 것
class AddressPostsQuery {
  final String addressZoneCode;
  final String addressBasic;
  final String addressDetail;

  AddressPostsQuery(
      {required this.addressZoneCode,
      required this.addressBasic,
      required this.addressDetail});
}
