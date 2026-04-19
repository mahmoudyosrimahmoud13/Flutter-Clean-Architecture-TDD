import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_course/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter converter;

  setUp(() {
    converter = InputConverter();
  });

  group('StringToUnsignedTest', () {
    test('should return int when the string represent unsigned int', () async {
      //Arrange
      final str = '123';
      //Act
      final result = converter.stringToUnsignedInteger(number: str);
      //Assert
      expect(result, Right(123));
    });
    test(
      'should return Failure when the string does not represent unsigned int',
      () async {
        //Arrange
        final str = 'abc';
        //Act
        final result = converter.stringToUnsignedInteger(number: str);
        //Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
    test(
      'should return Failure when the string represent negative int',
      () async {
        //Arrange
        final str = '-123';
        //Act
        final result = converter.stringToUnsignedInteger(number: str);
        //Assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
