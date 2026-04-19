part of 'number_trivia_bloc.dart';

sealed class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String stringNumber;

  const GetTriviaForConcreteNumber({required this.stringNumber});
  @override
  List<Object> get props => [stringNumber];
}

class GetTriviaForRandomNumber extends NumberTriviaEvent {}
