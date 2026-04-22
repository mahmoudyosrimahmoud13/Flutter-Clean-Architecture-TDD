import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_course/core/util/input_converter.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
    registerFallbackValue(const Params(number: 1));
  });

  test('initial state Should be empty state', () async {
    //Assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final tNumberString = '1';
    final tNumberParsed = 1;
    final tNumberTrivia = NumberTrivia(text: 'test text', number: 1);

    void setUpInputConverterSuccess() {
      when(
        () => mockInputConverter.stringToUnsignedInteger(
          number: any(named: 'number'),
        ),
      ).thenReturn(Right(tNumberParsed));
    }

    test(
      'should call InputConverter to validate the string and convert the string to unsigned intger',
      () async {
        //Arrange
        setUpInputConverterSuccess();
        //Act
        bloc.add(GetTriviaForConcreteNumber(stringNumber: tNumberString));
        await untilCalled(
          () => mockInputConverter.stringToUnsignedInteger(
            number: any(named: 'number'),
          ),
        );
        //Assert
        verify(
          () =>
              mockInputConverter.stringToUnsignedInteger(number: tNumberString),
        );
      },
    );

    test('Should emit [Error] when the input is invalid', () async {
      //Arrange
      when(
        () => mockInputConverter.stringToUnsignedInteger(
          number: any(named: 'number'),
        ),
      ).thenReturn(Left(InvalidInputFailure()));
      //Assert later TODO: very important
      final expected = [Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      final futureExpectation = expectLater(
        bloc.stream,
        emitsInOrder(expected),
      );

      bloc.add(const GetTriviaForConcreteNumber(stringNumber: 'abc'));

      await futureExpectation;
    });

    test('should get data from the concrete usecase', () async {
      //Arrange
      setUpInputConverterSuccess();

      when(
        () => mockGetConcreteNumberTrivia(any()),
      ).thenAnswer((_) async => Right(tNumberTrivia));
      //Act
      bloc.add(GetTriviaForConcreteNumber(stringNumber: tNumberString));
      await untilCalled(() => mockGetConcreteNumberTrivia(any()));

      //Assert
      verify(() => mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
    });

    test(
      'should emit [Loading , Loaded] when data is gotten successfully ',
      () async {
        //Arrange
        setUpInputConverterSuccess();

        when(
          () => mockGetConcreteNumberTrivia(any()),
        ).thenAnswer((_) async => Right(tNumberTrivia));
        //Assert later
        final expected = [Loading(), Loaded(numberTrivia: tNumberTrivia)];

        //Act

        final futureExpectation = expectLater(
          bloc.stream,
          emitsInOrder(expected),
        );
        bloc.add(GetTriviaForConcreteNumber(stringNumber: tNumberString));
        await futureExpectation;
      },
    );
  });
}
