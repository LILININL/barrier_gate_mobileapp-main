import 'package:get_it/get_it.dart';
import 'package:ehp_api/dio/dio.dart';
// import '../dio/dio.dart';
import 'dio_client.dart';
import 'ehp_api.dart';

final serviceLocator = GetIt.instance;

void setUpServiceLocator() {
  serviceLocator.registerSingleton(Dio());
  serviceLocator.registerSingleton(DioClient(serviceLocator<Dio>()));
  // serviceLocator.registerSingleton(LineClient(Dio()));
  serviceLocator.registerSingleton(MOPHDioClient(Dio()));
  serviceLocator.registerSingleton(IDPDioClient(Dio()));
  serviceLocator.registerSingleton(PHRDioClient(Dio()));
  serviceLocator.registerSingleton(FCMDioClient(Dio()));
  serviceLocator.registerSingleton(EHPApi(dioClient: serviceLocator<DioClient>()));
  
  // serviceLocator.registerSingleton(
  // LineApi(dioClient : serviceLocator<LineClient>()));
}
