import 'dart:convert';

import 'package:flutter_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/Fixture.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test('Should be subclass of number trivia entity.', () async {
    //assert
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('FromJson', () {
    test('Should return a valid Json structure when the number is int', () {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('trivia_double.json'),
      );
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });
  });

  group('to Json', () {
    test('should return Json map containig the proper data', () {
      //arange

      //act
      final result = tNumberTriviaModel.toJson();

      //assert
      final expectedMap = {'text': 'Test text', 'number': 1};
      expect(result, expectedMap);
    });
  });
}
