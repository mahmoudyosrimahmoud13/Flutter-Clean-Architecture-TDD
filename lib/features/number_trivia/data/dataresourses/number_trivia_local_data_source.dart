import 'dart:convert';

import 'package:flutter_tdd_course/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({required this.sharedPreferences});
  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    // TODO: implement getLastNumberTrivia
    if (sharedPreferences.getString(CACHED_NUMBER_TRIVIA) != null) {
      final cachedNumberTrivia = NumberTriviaModel.fromJson(
        jsonDecode(sharedPreferences.getString(CACHED_NUMBER_TRIVIA)!),
      );
      return Future.value(cachedNumberTrivia);
    }
    throw CacheException();
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    // TODO: implement cacheNumberTrivia
    await sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      jsonEncode(triviaToCache.toJson()),
    );
  }
}
