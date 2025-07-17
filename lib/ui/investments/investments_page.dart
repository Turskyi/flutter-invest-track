import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/domain_services/exchange_rate_repository.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/res/constants/hero_tags.dart' as hero_tags;
import 'package:investtrack/router/slide_page_route.dart';
import 'package:investtrack/ui/investments/investment/add_edit_investment_page.dart';
import 'package:investtrack/ui/investments/investment_tile/investment_tile.dart';
import 'package:investtrack/ui/investments/investment_tile/shimmer_investment.dart';
import 'package:investtrack/ui/menu/app_drawer.dart';
import 'package:investtrack/ui/widgets/blurred_app_bar.dart';
import 'package:investtrack/ui/widgets/blurred_floating_action_button.dart';
import 'package:investtrack/ui/widgets/gradient_background_scaffold.dart';
import 'package:models/models.dart';

/// The [InvestmentsPage] can access the current user id via
/// `context.select((AuthenticationBloc bloc) => bloc.state.user.id)` and
/// displays it via a [Text] widget. In addition, when the sign out button is
/// tapped, an [AuthenticationLogoutRequested] event is added to the
/// [AuthenticationBloc].
/// `context.select((AuthenticationBloc bloc) => bloc.state.user.id)` will
/// trigger updates if the user id changes.
class InvestmentsPage extends StatefulWidget {
  const InvestmentsPage({super.key});

  static Route<void> route(AuthenticationBloc authenticationBloc) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) {
        return BlocProvider<InvestmentsBloc>(
          create: (_) => InvestmentsBloc(
            GetIt.I.get<InvestmentsRepository>(),
            GetIt.I.get<ExchangeRateRepository>(),
            authenticationBloc,
          )..add(const LoadInvestments()),
          child: const InvestmentsPage(),
        );
      },
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        const Offset begin = Offset(1.0, 0.0);
        const Offset end = Offset.zero;
        const Curve curve = Curves.easeInOut;
        final Animatable<Offset> tween = Tween<Offset>(begin: begin, end: end)
            .chain(CurveTween(curve: curve));
        final Animation<Offset> offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  State<InvestmentsPage> createState() => _InvestmentsPageState();
}

class _InvestmentsPageState extends State<InvestmentsPage> {
  FeedbackController? _feedbackController;

  @override
  void didChangeDependencies() {
    _feedbackController = BetterFeedback.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackgroundScaffold(
      appBar: BlurredAppBar(
        title: Row(
          children: <Widget>[
            Hero(
              tag: hero_tags.appLogo,
              child: Image.asset(
                '${constants.imagePath}logo.png',
                width: 36,
                height: 36,
              ),
            ),
            const SizedBox(width: 10),
            Text(translate('title')),
          ],
        ),
      ),
      drawer: BlocListener<MenuBloc, MenuState>(
        listener: _menuStateListener,
        child: const AppDrawer(),
      ),
      body: BlocConsumer<InvestmentsBloc, InvestmentsState>(
        listener: _handleInvestmentsState,
        builder: (BuildContext context, InvestmentsState state) {
          if (state is InvestmentsLoading) {
            //TODO: replace with shimmer.
            return const Center(child: CircularProgressIndicator());
          } else if (state is InvestmentsError) {
            final bool isRateLimit = state.errorMessage.contains('429');

            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    isRateLimit
                        ? 'Too many requests. Please wait a moment and try '
                            'again.'
                        : 'Error: ${state.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<InvestmentsBloc>().add(
                          const LoadInvestments(),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state.investments.isEmpty) {
            final ThemeData themeData = Theme.of(context);
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Illustration
                    Icon(
                      Icons.trending_down,
                      size: 80,
                      color: themeData.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(height: 24),

                    // Message
                    Text(
                      'No investments yet!',
                      style: themeData.textTheme.titleLarge?.copyWith(
                        color: themeData.colorScheme.onSurface.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start tracking your portfolio today.',
                      style: themeData.textTheme.bodyLarge?.copyWith(
                        color: themeData.colorScheme.onSurface.withOpacity(
                          0.6,
                        ),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Button
                    ElevatedButton.icon(
                      onPressed: _navigateToAddEditPage,
                      icon: const Icon(Icons.add),
                      label: const Text('Create your first investment'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is InvestmentsLoaded) {
            final List<Investment> allInvestments = state.investments;

            return NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                return _handleScrollNotification(
                  scrollInfo: scrollInfo,
                  state: state,
                );
              },
              child: RefreshIndicator(
                onRefresh: () async => context.read<InvestmentsBloc>().add(
                      const LoadInvestments(),
                    ),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16.0,
                    112,
                    16,
                    80,
                  ),
                  itemCount: state is CreatingInvestment
                      ? allInvestments.length + 1
                      : allInvestments.length +
                          // Add extra item for loader.
                          (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (BuildContext _, int index) {
                    if (state is CreatingInvestment &&
                        index == allInvestments.length) {
                      return const ShimmerInvestment();
                    } else if (index == allInvestments.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final Investment investment = allInvestments[index];
                    return InvestmentTile(investment: investment);
                  },
                ),
              ),
            );
          } else {
            // TODO: handle this case. We should not be here.
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: BlurredFabWithBorder(
        onPressed: _navigateToAddEditPage,
        tooltip: 'Add Investment',
        icon: Icons.add,
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController?.removeListener(_onFeedbackChanged);
    _feedbackController = null;
    super.dispose();
  }

  void _handleInvestmentsState(BuildContext context, InvestmentsState state) {
    if (state is UnauthenticatedInvestmentsAccessState) {
      context
          .read<AuthenticationBloc>()
          .add(const AuthenticationSignOutPressed());
    } else if (state is InvestmentDeleted) {
      final String message = state.message;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _showFeedbackUi() {
    _feedbackController?.show(
      (UserFeedback feedback) {
        context.read<MenuBloc>().add(SubmitFeedbackEvent(feedback));
      },
    );
    _feedbackController?.addListener(_onFeedbackChanged);
  }

  void _onFeedbackChanged() {
    final bool? isVisible = _feedbackController?.isVisible;
    if (isVisible == false) {
      _feedbackController?.removeListener(_onFeedbackChanged);
      context.read<MenuBloc>().add(const ClosingFeedbackEvent());
    }
  }

  void _notifyFeedbackSent() {
    BetterFeedback.of(context).hide();
    // Let user know that his feedback is sent.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(translate('feedback.feedbackSent')),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToAddEditPage() {
    Navigator.of(context).push<bool?>(
      SlidePageRoute<bool?>(
        page: BlocProvider<InvestmentsBloc>.value(
          value: context.read<InvestmentsBloc>(),
          child: const AddEditInvestmentPage(),
        ),
      ),
    );
  }

  void _menuStateListener(BuildContext _, MenuState state) {
    if (state is FeedbackState) {
      _showFeedbackUi();
    } else if (state is FeedbackSent) {
      _notifyFeedbackSent();
    }
  }

  bool _handleScrollNotification({
    required ScrollNotification scrollInfo,
    required InvestmentsLoaded state,
  }) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
        !state.isLoadingMore &&
        !state.hasReachedMax) {
      context.read<InvestmentsBloc>().add(const LoadMoreInvestments());
    }
    return false;
  }
}
