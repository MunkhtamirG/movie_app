import 'package:dio/dio.dart';

class CustomerInterceptors extends InterceptorsWrapper {
  CustomerInterceptors()
      : super(
          onRequest: (options, handler) {
            print('On Request');
            return handler.next(options);
          },
          onResponse: (response, handler) {
            print('On Response');
            return handler.next(response);
          },
          onError: (DioException e, handler) {
            print('On Error');
            return handler.next(e);
          },
        );
}
