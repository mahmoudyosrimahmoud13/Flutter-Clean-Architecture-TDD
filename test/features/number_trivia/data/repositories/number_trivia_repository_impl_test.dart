import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_course/core/error/exceptions.dart';
import 'package:flutter_tdd_course/core/error/failures.dart';
import 'package:flutter_tdd_course/core/platform/network_info.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/dataresourses/number_trivia_local_data_source.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/dataresourses/number_trivia_remote_data_source.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockLocalDataSource();
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  setUpAll(() {
    registerFallbackValue(NumberTriviaModel(number: 1, text: 'fallback'));
  });

  void runTestOnline(Function body) {
    group("Device is online", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });
      body();
    });
  }

  void runTestOffline(Function body) {
    group("Device is offline", () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });
      body();
    });
  }

  group('get concrete number trivia', () {
    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(
      number: tNumber,
      text: 'test text',
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
      ).thenAnswer((_) async => tNumberTriviaModel);
      when(
        () => mockLocalDataSource.cacheNumberTrivia(any()),
      ).thenAnswer((_) async => Future.value());
      //Act
      await repository.getConcreteNumberTrivia(tNumber);
      //Assert
      verify(() => mockNetworkInfo.isConnected);
    });
    runTestOnline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'Should return remote data when the call to remote data source is success',
        () async {
          //Arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenAnswer((_) async => tNumberTriviaModel);

          when(
            () => mockLocalDataSource.cacheNumberTrivia(any()),
          ).thenAnswer((_) async => Future.value());
          //Act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //Assert
          verify(
            () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          ).called(1);
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'Should cached the data locally when the call to remote data source is success',
        () async {
          //Arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenAnswer((_) async => tNumberTriviaModel);

          when(
            () => mockLocalDataSource.cacheNumberTrivia(any()),
          ).thenAnswer((_) async => Future.value());

          //Act
          await repository.getConcreteNumberTrivia(tNumber);
          //Assert
          verify(
            () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          ).called(1);
          verify(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          );
        },
      );
      test(
        'Should return server failure when the call to remote data source is unsuccessfull',
        () async {
          //Arrange
          when(
            () => mockRemoteDataSource.getConcreteNumberTrivia(any()),
          ).thenThrow(ServerException());

          //Act
          final result = await repository.getConcreteNumberTrivia(tNumber);
          //Assert
          verify(
            () => mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
          ).called(1);
          verifyZeroInteractions(mockLocalDataSource);

          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    runTestOffline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return cached data when the cached data is present',
        () async {
          //Arrange
          when(
            () => mockLocalDataSource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //Assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );
      test(
        'should return [CacheFailure] when the cached data is present',
        () async {
          //Arrange
          when(
            () => mockLocalDataSource.getLastNumberTrivia(),
          ).thenThrow(CacheException());
          //Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          //Assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });

  group('get random number trivia', () {
    final tNumberTriviaModel = NumberTriviaModel(
      number: 123,
      text: 'test text',
    );
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(
        () => mockRemoteDataSource.getRandomNumberTrivia(),
      ).thenAnswer((_) async => tNumberTriviaModel);
      when(
        () => mockLocalDataSource.cacheNumberTrivia(any()),
      ).thenAnswer((_) async => Future.value());
      //Act
      await repository.getRandomNumberTrivia();
      //Assert
      verify(() => mockNetworkInfo.isConnected);
    });
    runTestOnline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'Should return remote data when the call to remote data source is success',
        () async {
          //Arrange
          when(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);

          when(
            () => mockLocalDataSource.cacheNumberTrivia(any()),
          ).thenAnswer((_) async => Future.value());
          //Act
          final result = await repository.getRandomNumberTrivia();
          //Assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia()).called(1);
          expect(result, Right(tNumberTrivia));
        },
      );

      test(
        'Should cached the data locally when the call to remote data source is success',
        () async {
          //Arrange
          when(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);

          when(
            () => mockLocalDataSource.cacheNumberTrivia(any()),
          ).thenAnswer((_) async => Future.value());

          //Act
          await repository.getRandomNumberTrivia();
          //Assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia()).called(1);
          verify(
            () => mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel),
          );
        },
      );
      test(
        'Should return server failure when the call to remote data source is unsuccessfull',
        () async {
          //Arrange
          when(
            () => mockRemoteDataSource.getRandomNumberTrivia(),
          ).thenThrow(ServerException());

          //Act
          final result = await repository.getRandomNumberTrivia();
          //Assert
          verify(() => mockRemoteDataSource.getRandomNumberTrivia()).called(1);
          verifyZeroInteractions(mockLocalDataSource);

          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
    runTestOffline(() {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test(
        'should return cached data when the cached data is present',
        () async {
          //Arrange
          when(
            () => mockLocalDataSource.getLastNumberTrivia(),
          ).thenAnswer((_) async => tNumberTriviaModel);
          //Act
          final result = await repository.getRandomNumberTrivia();

          //Assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, Right(tNumberTrivia));
        },
      );
      test(
        'should return [CacheFailure] when the cached data is present',
        () async {
          //Arrange
          when(
            () => mockLocalDataSource.getLastNumberTrivia(),
          ).thenThrow(CacheException());
          //Act
          final result = await repository.getRandomNumberTrivia();

          //Assert
          verifyNoMoreInteractions(mockRemoteDataSource);
          verify(() => mockLocalDataSource.getLastNumberTrivia());
          expect(result, Left(CacheFailure()));
        },
      );
    });
  });
}
