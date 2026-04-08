import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart'; // No more mockito!

import 'package:flutter_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tdd_course/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

// 1. You just write the mock class right here. No generator needed.
class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late MockNumberTriviaRepository mockRepository;
  late GetConcreteNumberTrivia usecase;

  setUp(() {
    mockRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockRepository);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia from repository', () async {
    // 2. Mocktail uses a slightly different "when" syntax: when(() => ...)
    when(
      () => mockRepository.getConcreteNumberTrivia(any()),
    ).thenAnswer((_) async => const Right(tNumberTrivia));

    // act
    final result = await usecase(Params(number: tNumber));

    // assert
    expect(result, const Right(tNumberTrivia));

    // 3. Verify also uses the () => syntax
    verify(() => mockRepository.getConcreteNumberTrivia(tNumber)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
