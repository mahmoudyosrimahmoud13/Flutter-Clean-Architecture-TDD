import 'dart:convert';

import 'package:flutter_tdd_course/core/error/exceptions.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/dataresourses/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/Fixture.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });
  group('getLastNumberTriviaTest', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      json.decode(fixture('trivia_chached.json')),
    );
    test('should return NumberTrivia when is one chached', () async {
      //Arrange
      when(
        () => mockSharedPreferences.getString(any()),
      ).thenReturn(fixture('trivia_chached.json'));
      //Act
      final result = await dataSource.getLastNumberTrivia();

      //Assert
      verify(() => mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
      'should throw CacheExeption when is there is no chached value',
      () async {
        //Arrange
        when(() => mockSharedPreferences.getString(any())).thenReturn(null);
        //Act
        final call = dataSource.getLastNumberTrivia;

        //Assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');
    test('should call shared preferences to cahche the data', () async {
      when(
        () => mockSharedPreferences.setString(any(), any()),
      ).thenAnswer((_) async => true);
      //Act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      //Assert
      final expectedJsonString = jsonEncode(
        json.decode(fixture('trivia_chached.json')),
      );
      verify(
        () => mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA,
          expectedJsonString,
        ),
      );
    });
  });
}
