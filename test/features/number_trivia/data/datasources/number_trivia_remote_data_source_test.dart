import 'dart:convert';

import 'package:flutter_tdd_course/core/error/exceptions.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/dataresourses/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import '../../../../fixtures/Fixture.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;
  void setUpMockHttpClientSuccess200() {
    when(
      () => mockHttpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(
      () => mockHttpClient.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => http.Response('Somthing went wrong', 404));
  }

  setUp(() {
    registerFallbackValue(Uri());
    mockHttpClient = MockHttpClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get concerete number trivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture('trivia.json')),
    );

    test(
      '''should preform [GET] request on the URL
     and number being the end-point and with application/json being the header''',
      () async {
        //Arrange
        setUpMockHttpClientSuccess200();
        //Act
        dataSource.getConcreteNumberTrivia(tNumber);

        //Assert

        verify(
          () => mockHttpClient.get(
            Uri.parse(
              'https://poll-eagles-issue-performing.trycloudflare.com/$tNumber',
            ),
            headers: {'Content-Type': 'application-json'},
          ),
        );
      },
    );

    test('should return NumberTrivia whem response in 200 success', () async {
      //Arrange
      setUpMockHttpClientSuccess200();
      //Act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      //Assert
      expect(result, tNumberTriviaModel);
    });

    test(
      'shoud throw [ServerException] when the status code 404 or other',
      () async {
        //Arrange
        setUpMockHttpClientFailure404();
        //Act
        final call = dataSource.getConcreteNumberTrivia;
        //Assert
        expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });

  group('get random number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(
      jsonDecode(fixture('trivia.json')),
    );

    test(
      '''should preform [GET] request on the URL
     and number being the end-point and with application/json being the header''',
      () async {
        //Arrange
        setUpMockHttpClientSuccess200();
        //Act
        dataSource.getRandomNumberTrivia();

        //Assert

        verify(
          () => mockHttpClient.get(
            Uri.parse(
              'https://poll-eagles-issue-performing.trycloudflare.com/random',
            ),
            headers: {'Content-Type': 'application-json'},
          ),
        );
      },
    );

    test('should return NumberTrivia whem response in 200 success', () async {
      //Arrange
      setUpMockHttpClientSuccess200();
      //Act
      final result = await dataSource.getRandomNumberTrivia();

      //Assert
      expect(result, tNumberTriviaModel);
    });

    test(
      'shoud throw [ServerException] when the status code 404 or other',
      () async {
        //Arrange
        setUpMockHttpClientFailure404();
        //Act
        final call = dataSource.getRandomNumberTrivia;
        //Assert
        expect(() => call(), throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
