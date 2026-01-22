import 'package:bli/features/auth/bloc/auth_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthEvent', () {
    group('AuthCheckRequested', () {
      test('creates event correctly', () {
        const event = AuthEvent.checkRequested();
        expect(event, isA<AuthCheckRequested>());
      });

      test('equality works', () {
        const event1 = AuthEvent.checkRequested();
        const event2 = AuthEvent.checkRequested();
        expect(event1, equals(event2));
      });
    });

    group('GoogleSignInRequested', () {
      test('creates event correctly', () {
        const event = AuthEvent.googleSignInRequested();
        expect(event, isA<GoogleSignInRequested>());
      });
    });

    group('GitHubSignInRequested', () {
      test('creates event correctly', () {
        const event = AuthEvent.gitHubSignInRequested();
        expect(event, isA<GitHubSignInRequested>());
      });
    });

    group('EmailSignInRequested', () {
      test('creates event with email', () {
        const event = AuthEvent.emailSignInRequested('test@example.com');
        expect(event, isA<EmailSignInRequested>());
        expect((event as EmailSignInRequested).email, 'test@example.com');
      });

      test('events with same email are equal', () {
        const event1 = AuthEvent.emailSignInRequested('test@example.com');
        const event2 = AuthEvent.emailSignInRequested('test@example.com');
        expect(event1, equals(event2));
      });

      test('events with different email are not equal', () {
        const event1 = AuthEvent.emailSignInRequested('test1@example.com');
        const event2 = AuthEvent.emailSignInRequested('test2@example.com');
        expect(event1, isNot(equals(event2)));
      });
    });

    group('EmailLinkVerified', () {
      test('creates event with email and link', () {
        const event = AuthEvent.emailLinkVerified(
          'test@example.com',
          'https://example.com/link',
        );
        expect(event, isA<EmailLinkVerified>());
        expect((event as EmailLinkVerified).email, 'test@example.com');
        expect(event.link, 'https://example.com/link');
      });
    });

    group('EmailLinkPendingEmail', () {
      test('creates event with link', () {
        const event = AuthEvent.emailLinkPendingEmail(
          'https://example.com/link',
        );
        expect(event, isA<EmailLinkPendingEmail>());
        expect(
          (event as EmailLinkPendingEmail).link,
          'https://example.com/link',
        );
      });
    });

    group('PhoneSignInRequested', () {
      test('creates event with phone number', () {
        const event = AuthEvent.phoneSignInRequested('+1234567890');
        expect(event, isA<PhoneSignInRequested>());
        expect((event as PhoneSignInRequested).phoneNumber, '+1234567890');
      });
    });

    group('PhoneCodeVerified', () {
      test('creates event with verification id and code', () {
        const event = AuthEvent.phoneCodeVerified('verification-id', '123456');
        expect(event, isA<PhoneCodeVerified>());
        expect((event as PhoneCodeVerified).verificationId, 'verification-id');
        expect(event.code, '123456');
      });
    });

    group('GuestSignInRequested', () {
      test('creates event correctly', () {
        const event = AuthEvent.guestSignInRequested();
        expect(event, isA<GuestSignInRequested>());
      });
    });

    group('SignOutRequested', () {
      test('creates event correctly', () {
        const event = AuthEvent.signOutRequested();
        expect(event, isA<SignOutRequested>());
      });
    });
  });
}
