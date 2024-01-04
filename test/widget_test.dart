import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:usercrud/main.dart';

void main() {
  testWidgets('Add user smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Tekan tombol tambah user
    await tester.tap(find.byKey(const Key('addUserButton')));
    await tester.pump();

    // Pastikan dialog tambah user muncul
    expect(find.byKey(const Key('addUserDialog')), findsOneWidget);

    // Isi identitas user (username, password, nama, dan email)
    await tester.enterText(find.byKey(const Key('usernameField')), 'admin');
    await tester.enterText(find.byKey(const Key('passwordField')), 'admin');
    await tester.enterText(find.byKey(const Key('nameField')), 'Administrator');
    await tester.enterText(
        find.byKey(const Key('emailField')), 'admin@gmail.com');

    // Tekan tombol tambah user
    await tester.tap(find.byKey(const Key('submitAddUserButton')));
  });

  testWidgets('Login page smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Pastikan belum login
    expect(find.text('Login'), findsOneWidget);

    // Tekan tombol login
    await tester.tap(find.byKey(const Key('loginButton')));
    await tester.pump();

    // Pastikan dialog login muncul
    expect(find.byKey(const Key('loginDialog')), findsOneWidget);

    // Isi identitas user
    await tester.enterText(find.byKey(const Key('usernameField')), 'admin');
    await tester.enterText(find.byKey(const Key('passwordField')), 'admin');

    // Tekan tombol login
    await tester.tap(find.byKey(const Key('submitLoginButton')));
    await tester.pump();

    // Pastikan sudah login
    expect(find.text('Logout'), findsOneWidget);
    expect(find.text('@admin'),
        findsOneWidget); // @admin adalah username yang sedang login
  });
}
