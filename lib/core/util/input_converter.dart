import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_course/core/error/failures.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger({required String number}) {
    try {
      final integer = int.parse(number);
      if (integer > 0) {
        return Right(integer);
      } else {
        throw FormatException();
      }
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
