// ignore_for_file: depend_on_referenced_packages

import 'package:get_it/get_it.dart';
import 'package:ilkvisual/repository/user_reposiyory.dart';
import 'package:ilkvisual/services/fake_auth_services.dart';
import 'package:ilkvisual/services/firebase_auth_service.dart';
import 'package:ilkvisual/services/firebase_stroge_service.dart';

import 'services/firestore_db_service.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDBservice());
  locator.registerLazySingleton(() => FirebaseStrogeService());
}
