import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final List<Object?> properties;

  Failure([this.properties = const <dynamic>[]]) : super();

  @override
  // TODO: implement props
  List<Object?> get props => properties;
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
