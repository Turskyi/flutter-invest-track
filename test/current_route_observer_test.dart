import 'package:flutter_test/flutter_test.dart';
import 'package:investtrack/ui/app/current_route_observer.dart';

import 'fakes/fake_route.dart';

void main() {
  group('CurrentRouteObserver', () {
    late CurrentRouteObserver observer;

    setUp(() {
      observer = CurrentRouteObserver();
    });

    test('didPush sets currentRouteName', () {
      final FakeRoute route = FakeRoute('/investments');

      observer.didPush(route, null);

      expect(observer.currentRouteName, '/investments');
    });

    test('didPop sets currentRouteName to previous route', () {
      final FakeRoute current = FakeRoute('/details');
      final FakeRoute previous = FakeRoute('/investments');

      observer.didPush(current, null);
      observer.didPop(current, previous);

      expect(observer.currentRouteName, '/investments');
    });

    test('didReplace sets currentRouteName to new route', () {
      final FakeRoute oldRoute = FakeRoute('/sign-in');
      final FakeRoute newRoute = FakeRoute('/investments');

      observer.didPush(oldRoute, null);
      observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);

      expect(observer.currentRouteName, '/investments');
    });

    test('didRemove of the current route updates currentRouteName', () {
      final FakeRoute route = FakeRoute('/investments');

      observer.didPush(route, null);
      expect(observer.currentRouteName, '/investments');

      observer.didRemove(route, null);

      expect(observer.currentRouteName, isNull);
    });

    // Regression test: pushAndRemoveUntil pushes the new route first (didPush),
    // then removes old routes below it (didRemove). The old didRemove
    // unconditionally overwrote currentRouteName with previousRoute?.settings
    // .name, which was null for the bottom route. This caused
    // _isCurrentRoutePublic() to fall back to the initial route ('/sign-in'),
    // a public route, so the sign-out navigation to the sign-in page was
    // skipped entirely.
    test(
      'didRemove of a route below the current one preserves currentRouteName',
      () {
        final FakeRoute signIn = FakeRoute('/sign-in');
        final FakeRoute investments = FakeRoute('/investments');

        // Simulate pushAndRemoveUntil(investmentsRoute, (_) => false):
        // 1. Push /investments on top of /sign-in.
        observer.didPush(investments, signIn);
        expect(observer.currentRouteName, '/investments');

        // 2. Remove /sign-in (bottom of stack, previousRoute is null).
        observer.didRemove(signIn, null);

        // currentRouteName must still be '/investments', NOT null.
        expect(observer.currentRouteName, '/investments');
      },
    );

    // Same scenario with multiple routes removed below the current one.
    test('didRemove of several routes below the current one preserves '
        'currentRouteName', () {
      final FakeRoute routeA = FakeRoute('/a');
      final FakeRoute routeB = FakeRoute('/b');
      final FakeRoute current = FakeRoute('/current');

      // Push /a, then /b, then /current.
      observer.didPush(routeA, null);
      observer.didPush(routeB, routeA);
      observer.didPush(current, routeB);
      expect(observer.currentRouteName, '/current');

      // Remove /b (between /a and /current); previousRoute = /a.
      observer.didRemove(routeB, routeA);
      expect(observer.currentRouteName, '/current');

      // Remove /a (bottom of stack); previousRoute = null.
      observer.didRemove(routeA, null);
      expect(observer.currentRouteName, '/current');
    });
  });
}
