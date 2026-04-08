import 'package:dartz/dartz.dart';
import 'package:flutter_tdd_course/core/usecases/usecase.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetRandomNumberTrivia usecase;

  // returned type
  final NumberTrivia tNumberTrivia = NumberTrivia(text: 'text', number: 1);
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(repository: mockNumberTriviaRepository);
  });

  test('should get random number trivia', () async {
    // arrange
    when(
      () => mockNumberTriviaRepository.getRandomNumberTrivia(),
    ).thenAnswer((_) async => Right(tNumberTrivia));

    //assert
    final result = await usecase(NoParams());
    //act
    expect(result, Right(tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
