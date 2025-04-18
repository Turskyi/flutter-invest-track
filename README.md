[![Stand With Ukraine](https://raw.githubusercontent.com/vshymanskyy/StandWithUkraine/main/banner-direct-single.svg)](https://stand-with-ukraine.pp.ua)
[![style: flutter lints](https://img.shields.io/badge/style-flutter__lints-blue)](https://pub.dev/packages/flutter_lints)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/Turskyi/flutter-invest-track)
[![codecov](https://codecov.io/gh/Turskyi/flutter-invest-track/graph/badge.svg?token=MBRYB1UFQM)](https://codecov.io/gh/Turskyi/flutter-invest-track)
[![Code Quality](https://github.com/Turskyi/flutter-invest-track/actions/workflows/code_quality_tests.yml/badge.svg)](https://github.com/Turskyi/flutter-invest-track/actions/workflows/code_quality_tests.yml)
[![Upload Android build to App Tester.](https://github.com/Turskyi/flutter-invest-track/actions/workflows/flutter_android_ci.yml/badge.svg)](https://github.com/Turskyi/flutter-invest-track/actions/workflows/flutter_android_ci.yml)
[![Codemagic build status](https://api.codemagic.io/apps/6775c76403822966ad61431e/6775c76403822966ad61431d/status_badge.svg)](https://codemagic.io/app/6775c76403822966ad61431e/6775c76403822966ad61431d/latest_build)
[![Deploy to Firebase Hosting on PR](https://github.com/Turskyi/flutter-invest-track/actions/workflows/firebase-hosting-pull-request.yml/badge.svg)](https://github.com/Turskyi/flutter-invest-track/actions/workflows/firebase-hosting-pull-request.yml)
[![Deploy to Firebase Hosting on merge](https://github.com/Turskyi/flutter-invest-track/actions/workflows/firebase-hosting-merge.yml/badge.svg)](https://github.com/Turskyi/flutter-invest-track/actions/workflows/firebase-hosting-merge.yml)
<img alt="GitHub commit activity" src="https://img.shields.io/github/commit-activity/m/Turskyi/flutter-invest-track">

# InvestTrack (Flutter Version).

InvestTrack is a cross-platform Flutter application that helps users track
their stock portfolios in real-time. It fetches live stock prices, displays
investment performance, and calculates gains or losses in multiple
currencies.  
The app is primarily designed for Web, iOS, and Android, but it includes
support for Linux, macOS, and Windows, with potential for future testing
and official support on these platforms. Perfect for anyone looking to monitor
their investments on the go.

### Accessing the application:

- [Official Web Version](https://invest.turskyi.com): This is the primary web
  version of **InvestTrack**, built with Next.js. It shares the same backend as
  this Flutter application and also provides links to the mobile apps.
- [Flutter Web Version](https://invest-track-application.web.app/):
  This is a web build of the Flutter application, demonstrating the
  cross-platform capabilities of Flutter by running the same codebase on
  the web.

### Testing the App:

Join our testing program and provide valuable feedback:

- [Android App Distribution Tester Invite](https://appdistribution.firebase.dev/i/052c3e006f2c8352)
- [iOS TestFlight Tester Invite](https://testflight.apple.com/join/GxB2Hzq7)

## Features

- **User Authentication:** Secure login and account management.

- **Investment Dashboard:** Detailed overview of all investments with real-time
  updates.

- **Add/Edit/Delete Investments:** Manage your investment portfolio easily.

- **Performance Insights:** Visual and numerical analysis of investment
  performance.

- **Responsive Design:** Optimized for both mobile and desktop views.

- **Dark and Light Modes:** User preference for dark or light theme.

## Getting Started

Follow these instructions to get a copy of the project up and running on your
local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)

- [Dart SDK](https://dart.dev/get-dart)

- [Android Studio](https://developer.android.com/studio) or
  [Visual Studio Code](https://code.visualstudio.com/) with Flutter and Dart
  plugins.
- A device or emulator for testing.

### Installation

- Clone the repository:

```bash
git clone https://github.com/Turskyi/flutter-invest-track.git
```

- Navigate to the project directory:

```bash
cd flutter-invest-track
```

- Install dependencies:

```bash
flutter pub get
```

### Create generated files:

```
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

- Run the app on an emulator or connected device:

```bash
flutter run
```

## Usage

### Sign In

- Launch the app and sign in using your credentials. If you don’t
  have an account, you can sign up.

### Dashboard

- View an overview of your investments, including their current
  value, gain/loss, and other key metrics.

### Manage Investments

- Add new investments by providing details such as ticker, company name,
  quantity, purchase price, and more.

- Edit existing investments to update their details.

- Delete investments that you no longer wish to track.

### Insights

- Analyze the performance of your investments through visual graphs and
  detailed reports.

## Contributing

We welcome contributions! Follow these steps to contribute:

- Fork the repository

- Create your feature branch:

```bash
git checkout -b feature/your-feature-name
```

- Commit your changes:

```bash
git commit -m 'Add some feature'
```

- Push to the branch:

```bash
git push origin feature/your-feature-name
```

- Open a pull request.

- Please follow
  [the Flutter style guide](https://github.com/flutter/flutter/blob/master/docs/contributing/Style-guide-for-Flutter-repo.md)
  when contributing to this project. You can also use the issues and discussions
  tabs to report bugs, request features, or give feedback.

<details style="border: 1px solid #aaa; border-radius: 4px; padding: 0.5em 0.5em 0;">
  <summary style="font-weight: bold; margin: -0.5em -0.5em 0; padding: 0.5em; border-bottom: 1px solid #aaa;">Style guides:

[Style guide for Flutter](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo),
[Dart style guide](https://dart.dev/effective-dart).

  </summary>

- [DO use trailing commas for all function calls and declarations unless the function call or definition, from the start of the function name up to the closing parenthesis, fits in a single line.](https://dart-lang.github.io/linter/lints/require_trailing_commas.html)

- [DON'T cast a nullable value to a non-nullable type. This hides a null check and most of the time it is not what is expected.](https://dart-lang.github.io/linter/lints/avoid_as.html)

- [PREFER using
  `const` for instantiating constant constructors](https://dart-lang.github.io/linter/lints/prefer_const_constructors.html)

If a constructor can be invoked as const to produce a canonicalized instance,
it's preferable to do so.

- [DO sort constructor declarations before other members](https://dart-lang.github.io/linter/lints/sort_constructors_first.html)

- ### Avoid Mental Mapping

A single-letter name is a poor choice; it’s just a placeholder that the reader
must mentally map to the actual concept. There can be no worse reason for using
the name `c` than because `a` and `b` were already taken.

- ### Method names

Methods should have verb or verb phrase names like `postPayment`, `deletePage`,
or `save`. Accessors, mutators, and predicates should be named for their value
and prefixed with `get`…, `set`…, and `is`….

- ### Use Intention-Revealing Names

If a name requires a comment, then the name does not reveal its intent.

- ### Use Pronounceable Names

If you can’t pronounce it, you can’t discuss it without sounding silly.

- ### Class Names

Classes and objects should have noun or noun phrase names and not include
indistinct noise words:

```
GOOD:
Customer, WikiPage, Account, AddressParser.

BAD:
Manager, Processor, Data, Info.
```

- ### Functions should be small

Functions should hardly ever be 20 lines long.
Blocks within if statements, else statements, while statements, and so on
should be **_one_** line long. Probably that line should be a function call.

- ### Functions should do one thing

To know that a function is doing more than “one thing” is if you can extract
another function from it with a name that is not merely a restatement of its
implementation.

- ### One Level of Abstraction per Function

We want the code to read like a top-down narrative. We want every function to
be followed by those at the next level of abstraction so that we can read the
program, descending one level of abstraction at a time as we read down the list
of functions.

- ### Dependent Functions

If one function calls another, they should be vertically close, and the caller
should be **_above_** the callee, if possible.

- ### Use Descriptive Names

Don’t be afraid to make a name long. A long descriptive name is better than a
short enigmatic name. A long descriptive name is better than a long descriptive
comment.

- ### Function Arguments

The ideal number of arguments for a function is zero (niladic). Next comes one
(monadic), followed closely by two (dyadic). Three arguments (triadic) should
be avoided where possible.

```
GOOD:
includeSetupPage()

BAD:
includeSetupPageInto(newPageContent)
```

- ### Flag Arguments

Flag arguments are ugly. Passing a boolean into a function is a truly terrible
practice. It immediately complicates the signature of the method, loudly
proclaiming that this function does more than one thing. It does one thing if
the flag is true and another if the flag is false!

```
GOOD:
renderForSuite()
renderForSingleTest()

BAD:
render(bool isSuite)
```

- ### Explain Yourself in Code

Only the code can truly tell you what it does. Comments are, at best, a
necessary evil. Rather than spend your time writing the comments that explain
the mess you’ve made, spend it cleaning that mess. Inaccurate comments are far
worse than no comments at all.

```
BAD:
// Check to see if the employee is eligible
// for full benefits
if ((employee.flags & hourlyFlag) && (employee.age > 65))

GOOD:
if (employee.isEligibleForFullBenefits())

```

- ### TODO Comments

Nowadays, good IDEs provide special gestures and features to locate all the
`//TODO` comments, so it’s not likely that they will get lost.

- ### Public APIs

There is nothing quite so helpful and satisfying as a well-described public API.
It would be challenging, at best, to write programs without them.

```dart
/// dart doc comment
```

- ### Commented-Out Code

We’ve had good source code control systems for a very long time now. Those
systems will remember the code for us. We don’t have to comment it out anymore.

- ### Position Markers

In general, they are the clutter that should be eliminated—especially the noisy
train of slashes at the end. If you overuse banners, they’ll fall into the
background noise and be ignored.

```dart
// Actions //////////////////////////////////
```

- ### Don’t Return Null

When we return `null`, we are essentially creating work for ourselves and
foisting problems upon our callers. All it takes is one missing `null` check to
send an app spinning out of control.

- ### Don’t Pass Null

In most programming languages, there is no **GOOD** way to deal with a `null`
that is passed by a caller accidentally. Because this is the case, the rational
approach is to forbid passing null by default. When you do, you can code with
the knowledge that a `null` in an argument list is an indication of a problem,
and end up with far fewer careless mistakes.

- ### Classes Should Be Small!

With functions, we measured size by counting physical lines. With classes, we
use a different measure. **We count responsibilities.** The Single
Responsibility Principle (SRP) states that a class or module should have one,
and only one, reason to change. The name of a class should describe what
responsibilities it fulfills. The more ambiguous the class name, the more
likely it has too many responsibilities. The problem is that too many of us
think that we are done once the program works. We move on to the next problem
rather than going back and breaking the overstuffed classes into decoupled
units with single responsibilities.

- ### Artificial Coupling

In general, an artificial coupling is a coupling between two modules that
serves no direct purpose. It is a result of putting a variable, constant, or
function in a temporarily convenient, though inappropriate, location. For
example, general `enum`s should not be contained within more specific classes
because this forces the app to know about these more specific classes. The same
goes for general purpose `static` functions being declared in specific classes.

- ### Prefer Polymorphism to If/Else or Switch/Case

There may be no more than one switch statement for a given type of selection.
The cases in that switch statement must create polymorphic objects that take
the place of other such switch statements in the rest of the system.

- ### Replace Magic Numbers with Named Constants

In general, it is a bad idea to have raw numbers in your code. You should hide
them behind well-named constants. The term “Magic Number” does not apply only
to numbers. It applies to any token that has a value that is not
self-describing.

- ## Encapsulate Conditionals

Boolean logic is hard enough to understand without having to see it in the
context of an `if` or `while` statement. Extract functions that explain the
intent of the conditional.

```
GOOD:
if (shouldBeDeleted(timer))

BAD:
if (timer.hasExpired() && !timer.isRecurrent())
```

- ### Avoid Negative Conditionals

Negatives are just a bit harder to understand than positives. So, when
possible, conditionals should be expressed as positives.

```
GOOD:
if (buffer.shouldCompact())

BAD:
if (!buffer.shouldNotCompact())
```

- ### Encapsulate Boundary Conditions

Boundary conditions are hard to keep track of. Put the processing for them in
one place.

```
BAD:
if (level + 1 < tags.length) {
  parts = Parse(body, tags, level + 1, offset + endTag);
  body = null;
}

GOOD:
int nextLevel = level + 1;
if (nextLevel < tags.length) {
  parts = Parse(body, tags, nextLevel, offset + endTag);
  body = null;
}
```

- ### Constants versus Enums

Don’t keep using the old trick of public `static` `final` `int`s. `enum`s can
have methods and fields. This makes them very powerful tools that allow much
more expression and flexibility.

</details>

## Contact

For any inquiries, please contact support@turskyi.com.

## Screenshots:

<!--suppress CheckImageSize -->
<img src="screenshots/login_20241202_223414.png" width="400"  alt="screenshot">
<!--suppress CheckImageSize -->
<img src="screenshots/details_20241202_224900.png" width="400"  alt="screenshot">
<!--suppress CheckImageSize -->
<img src="screenshots/Investments_20241202_223809.png" width="400"  alt="screenshot">
<!--suppress CheckImageSize -->
<img src="screenshots/edit_20241202_224929.png" width="400"  alt="screenshot">

# Acknowledgments

- Flutter documentation: https://flutter.dev/docs
- Dart documentation: https://dart.dev/guides
- [Vitalii Khomenko](https://github.com/Vitaliklisa) - For creating the
  original Google Sheet that served as the foundation for this project.
- All contributors and community members who helped build this project.

## Download

<a href="https://play.google.com/store/apps/details?id=com.turskyi.investtrack" target="_blank">
<img src="https://play.google.com/intl/en_gb/badges/static/images/badges/en_badge_web_generic.png" width=240  alt="google play badge"/>
</a>
