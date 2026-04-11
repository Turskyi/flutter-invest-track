import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// A minimal [Route] stub that carries only [RouteSettings].
class FakeRoute extends Fake implements Route<dynamic> {
  FakeRoute(String? name) : settings = RouteSettings(name: name);

  @override
  final RouteSettings settings;
}
