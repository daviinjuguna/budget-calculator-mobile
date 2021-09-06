import 'package:http_interceptor/http_interceptor.dart';
import 'package:sortika_budget_calculator/di/injection.dart';
import 'package:sortika_budget_calculator/features/data/datasource/local.dart';

class HttpInterceptors implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    try {
      final _token = await getIt<LocalDataSource>().fetchTokens();
      data.headers["Content-Type"] = "application/json";
      data.headers["Accept"] = "application/json";
      if (_token != null) data.headers["Authorization"] = "Token $_token";
    } catch (e) {
      print(e);
    }
    print("BEGIN REQUEST");
    print(
        'REQUEST: ${data.method}\nPATH: ${data.baseUrl}\nPARAMS: ${data.params}\nHEADERS: ${data.headers}\nBODY: ${data.body}');
    print("END REQUEST");
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print(data.toString());
    print("BEGIN RESPONSE");
    print(
        'RESPONSE: ${data.method}\nPATH: ${data.url}\nSTATUS CODE: ${data.statusCode}\nHEADERS: ${data.headers}\nBODY: ${data.body}\nREQUEST: ${data.request}');
    print("END RESPONSE");
    return data;
  }
}
