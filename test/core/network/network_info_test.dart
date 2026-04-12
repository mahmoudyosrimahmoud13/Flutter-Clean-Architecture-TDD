import 'package:flutter_tdd_course/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(
      internetConnectionChecker: mockInternetConnectionChecker,
    );
  });

  group("is connected", () {
    test(
      'should forward the call to [InternetConnectionChecker.hasConnection]',
      () async {
        //Arrange
        final tHasConnectionFuture = Future.value(true);
        when(
          () => mockInternetConnectionChecker.hasConnection,
        ).thenAnswer((_) => tHasConnectionFuture);
        //Act
        final result = networkInfoImpl.isConnected;
        //Assert
        verify(() => mockInternetConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      },
    );
  });
}
