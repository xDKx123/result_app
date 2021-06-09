import 'dart:async';
import 'dart:core';

///Class to handle expired Token
class VerificationException implements Exception {
  final String message;

  VerificationException(this.message);

  @override
  String toString() => message;
}