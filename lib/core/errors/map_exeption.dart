import 'dart:io';

import 'exeptions.dart';

String mapExeption(Object exception) {
  if (exception is CacheException) return CACHE_FAILURE_MESSAGE;
  if (exception is UnAuthenticatedException) return UNAUTHENTICATED;
  if (exception is DatabaseExeption) return DATABASE_ERROR;
  if (exception is SocketException) return SOCKET_ERROR;
  return SERVER_FAILURE_MESSAGE;
}

///constants
const CACHE_FAILURE_MESSAGE = "Could not access records";
const SERVER_FAILURE_MESSAGE = "Server error please try again,";
const UNAUTHENTICATED = "You are not authorized";
const DATABASE_ERROR = "Could not access local database";
const SOCKET_ERROR = "Check your internet connection";
