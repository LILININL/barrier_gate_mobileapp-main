import 'dart:developer';

import 'package:ehp_api/ehp_endpoint/ehp_api.dart';
import 'package:flutter/cupertino.dart';

import 'package:ehp_api/dio/cancel_token.dart';
import 'package:ehp_api/dio/dio.dart';
import 'package:ehp_api/dio/options.dart';
import 'package:ehp_api/dio/response.dart';
import 'ehp_endpoint.dart';
import 'dart:developer' as logDev;  

class DioClient {
// dio instance
  final Dio _dio;
  static const _secretKeyName = "X-Secret-Key";
  static const _secretKeyValue = "bms";
  DioClient(this._dio) {
    _dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  changeBaseURL(String baseURL) {
    _dio.options.baseUrl = baseURL;
  }

  getBaseURLDio() {
    return _dio.options.baseUrl;
  }

  Future<DioResponse> get(
    String url, {
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('dio.get : $url');

    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      _dio.options.headers[_secretKeyName] = _secretKeyValue;

      final DioResponse response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      // log('RES ${response}');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<DioResponse> post(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      logFull("authHeader " + authHeader);
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      print("URL " + url);

      debugPrint('post data to ${_dio.options.baseUrl}$url with data');
      logDev.log('${data}', name: 'post_body');

      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      print("DioResponse >>> response.data.toString");
      print(response.data.toString());

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<DioResponse> put(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

class MOPHDioClient {
// dio instance
  final Dio _dio;

  MOPHDioClient(this._dio) {
    _dio
      ..options.baseUrl = '${Endpoints.mophBaseUrl}/token'
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  changeBaseURL(String baseURL) {
    _dio.options.baseUrl = baseURL;
  }

  Future<DioResponse> get(
    String url, {
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('moph dio.get : $url');

    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<DioResponse> post(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      //debugPrint('Set payload data to $data');

      final DioResponse response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      //  debugPrint('receive moph post data : $response');

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<DioResponse> put(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

class IDPDioClient {
// dio instance
  final Dio _dio;

  IDPDioClient(this._dio) {
    _dio
      ..options.baseUrl = '${Endpoints.idpBaseUrl}'
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  Future<DioResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('idp dio.get : $url');

    try {
      final authHeader = Endpoints.mophAPIJWT;

      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<DioResponse> post(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    DioResponse<dynamic>? response;
    try {
      final authHeader = Endpoints.mophAPIJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      // debugPrint('Set payload data to $data');

      response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('receive idpapi post data : $response');

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<DioResponse> put(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophAPIJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophAPIJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

class FCMDioClient {
// dio instance
  final Dio _dio;

  FCMDioClient(this._dio) {
    _dio
      ..options.baseUrl = 'https://fcm.googleapis.com'
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  changeBaseURL(String baseURL) {
    _dio.options.baseUrl = baseURL;
  }

  Future<DioResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('fcm dio.get : $url');

    try {
      final authHeader = Endpoints.FCMAPIKey;

      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<DioResponse> post(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    DioResponse<dynamic>? response;
    try {
      final authHeader = Endpoints.FCMAPIKey;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "key=$authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      _dio.options.headers["content-type"] = "application/json";

      debugPrint('post data to ${_dio.options.baseUrl} payload : ${data}');

      response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('receive FCM post data : $response');

      return response;
    } catch (e) {
      return response as DioResponse;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<DioResponse> put(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.FCMAPIKey;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.FCMAPIKey;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

class PHRDioClient {
// dio instance
  final Dio _dio;

  PHRDioClient(this._dio) {
    _dio
      ..options.baseUrl = '${Endpoints.phrBaseUrl}'
      ..options.connectTimeout = const Duration(milliseconds: Endpoints.connectionTimeout)
      ..options.receiveTimeout = const Duration(milliseconds: Endpoints.receiveTimeout)
      ..options.responseType = ResponseType.json;
  }

  Future<DioResponse> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    debugPrint('phr dio.get : $url');

    try {
      final authHeader = Endpoints.mophAPIJWT;

      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //  debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'GET', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<DioResponse> post(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophAPIJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      // debugPrint('Set payload data to $data');

      final DioResponse response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'POST', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      debugPrint('receive phr post data : $response');

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<DioResponse> put(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophAPIJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'PUT', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String url, {
    data,
    // required String authHeader,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final authHeader = Endpoints.mophAPIJWT;
      if (authHeader.isNotEmpty) {
        _dio.options.headers["Authorization"] = "Bearer $authHeader";
        //   debugPrint('Set authorization header to $authHeader');
      } else {
        _dio.options.headers.remove('Authorization');
      }

      final DioResponse response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options ?? Options(method: 'DELETE', validateStatus: (code) => validPassAllStatusCode(code)),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

bool validPassAllStatusCode(int? value) {
  return true;
}


// class LineClient extends DioClient {
//   LineClient(super.dio) {
//     _dio
//     ..options.baseUrl = Endpoints.lineAPIUrl
//     ..options.contentType = 'application/x-www-form-urlencoded';
//   }


// }