import 'package:injectable/injectable.dart';

import 'exeptions.dart';

@lazySingleton

///check the status code of the url and throws error according
///to status code
class HandleNetworkCall {
  bool checkStatusCode(int responseStatus) {
    if (responseStatus == 200 || responseStatus == 201) {
      return true;
    } else if (responseStatus == 401) {
      throw UnAuthenticatedException();
    } else if (responseStatus == 500) {
      throw ServerException();
    } else {
      return false;
    }
  }
}
