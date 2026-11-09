import 'dart:io';

import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/investments/investments_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/domain_services/exchange_rate_repository.dart';
import 'package:investtrack/domain_services/investments_repository.dart';
import 'package:investtrack/domain_services/settings_repository.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/res/constants/hero_tags.dart' as hero_tags;
import 'package:investtrack/router/app_route.dart';
import 'package:investtrack/router/slide_page_route.dart';
import 'package:investtrack/services/home_widget_service.dart';
import 'package:investtrack/ui/investments/desktop_table.dart';
import 'package:investtrack/ui/investments/import/xlsx_import_page.dart';
import 'package:investtrack/ui/investments/investment/add_edit_investment_page.dart';
import 'package:investtrack/ui/investments/investment/investment_page.dart';
import 'package:investtrack/ui/investments/investment_tile/investment_tile.dart';
import 'package:investtrack/ui/investments/investment_tile/shimmer_investment.dart';
import 'package:investtrack/ui/investments/shimmer_desktop_table.dart';
import 'package:investtrack/ui/menu/app_drawer.dart';
import 'package:investtrack/ui/widgets/blurred_app_bar.dart';
import 'package:investtrack/ui/widgets/blurred_fab_with_border.dart';
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
  const InvestmentsPage({
    required this.homeWidgetService,
    super.key,
    this.isDemo = false,
  });

  final HomeWidgetService homeWidgetService;
  final bool isDemo;

  static Route<void> route({
    required AuthenticationBloc authenticationBloc,
    required InvestmentsRepository investmentsRepository,
    required ExchangeRateRepository exchangeRateRepository,
    required HomeWidgetService homeWidgetService,
    required SettingsRepository settingsRepository,
  }) {
    return PageRouteBuilder<void>(
      settings: RouteSettings(name: AppRoute.investments.path),
      pageBuilder: (BuildContext _, Animation<double> _, Animation<double> _) {
        return BlocProvider<InvestmentsBloc>(
          create: (BuildContext _) {
            return InvestmentsBloc(
              investmentsRepository,
              exchangeRateRepository,
              authenticationBloc,
              homeWidgetService,
              settingsRepository,
            )..add(const LoadInvestments());
          },
          child: InvestmentsPage(homeWidgetService: homeWidgetService),
        );
      },
      transitionsBuilder:
          (
            BuildContext _,
            Animation<double> animation,
            Animation<double> _,
            Widget child,
          ) {
            const Offset begin = Offset(1.0, 0.0);
            const Offset end = Offset.zero;
            const Curve curve = Curves.easeInOut;
            final Animatable<Offset> tween = Tween<Offset>(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
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
  ScaffoldMessengerState? _scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _feedbackController = BetterFeedback.of(context);
    if (widget.isDemo) {
      _scaffoldMessenger = ScaffoldMessenger.of(context);
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        _showDemoBanner();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
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
            Expanded(
              child: BlocBuilder<InvestmentsBloc, InvestmentsState>(
                builder: (BuildContext context, InvestmentsState state) {
                  final DateTime? lastUpdated = state.lastUpdated;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(translate('title')),
                      if (lastUpdated != null)
                        Text(
                          _formatLastUpdated(lastUpdated),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.6),
                                fontSize: 11,
                              ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: translate('investments.refresh_tooltip'),
            onPressed: () {
              context.read<InvestmentsBloc>().add(
                const LoadInvestments(forceRefresh: true),
              );
            },
          ),
        ],
      ),
      drawer: widget.isDemo
          ? null
          : BlocListener<MenuBloc, MenuState>(
              listener: _menuStateListener,
              child: AppDrawer(homeWidgetService: widget.homeWidgetService),
            ),
      body: BlocConsumer<InvestmentsBloc, InvestmentsState>(
        listener: _handleInvestmentsState,
        builder: (BuildContext context, InvestmentsState state) {
          Widget content;

          if (state is InvestmentsLoading && state.investments.isEmpty) {
            content = LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth > 800.0) {
                  return const ShimmerDesktopTable();
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16.0, 112, 16, 80),
                    itemCount: 6,
                    itemBuilder: (BuildContext _, int _) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: constants.maxWidth,
                          ),
                          child: const ShimmerInvestment(),
                        ),
                      );
                    },
                  );
                }
              },
            );
          } else if (state is InvestmentsError && state.investments.isEmpty) {
            final bool isRateLimit = state.errorMessage.contains(
              '${HttpStatus.tooManyRequests}',
            );

            content = Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    isRateLimit
                        ? translate('investments.error_too_many_requests')
                        : '${translate('investments.error_generic_prefix')}'
                              '${state.errorMessage}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<InvestmentsBloc>().add(
                      const LoadInvestments(forceRefresh: true),
                    ),
                    child: Text(translate('investments.retry_button')),
                  ),
                ],
              ),
            );
          } else if (state.investments.isEmpty && !state.isRefreshing) {
            final ThemeData themeData = Theme.of(context);
            content = Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.trending_down,
                      size: 80,
                      color: themeData.colorScheme.onSurface.withOpacity(0.4),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      translate('investments.no_investments'),
                      style: themeData.textTheme.titleLarge?.copyWith(
                        color: themeData.colorScheme.onSurface.withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      translate('investments.start_tracking'),
                      style: themeData.textTheme.bodyLarge?.copyWith(
                        color: themeData.colorScheme.onSurface.withOpacity(0.6),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _navigateToAddEditPage,
                      icon: const Icon(Icons.add),
                      label: Text(translate('investments.create_first')),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      translate('investments.or_divider'),
                      style: themeData.textTheme.bodySmall?.copyWith(
                        color: themeData.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: widget.isDemo
                          ? _showDemoSignInPrompt
                          : _navigateToImportPage,
                      icon: const Icon(Icons.upload_file),
                      label: Text(translate('investments.import_from_xlsx')),
                      style: OutlinedButton.styleFrom(
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
          } else {
            final List<Investment> allInvestments = state.investments;

            content = RefreshIndicator(
              onRefresh: () async {
                context.read<InvestmentsBloc>().add(
                  const LoadInvestments(forceRefresh: true),
                );
              },
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  final bool isLoadingMore =
                      state is InvestmentsLoaded && state.isLoadingMore;
                  final bool canLoadMore =
                      state is InvestmentsLoaded && state.canLoadMore;
                  final bool hasReachedMax = state is InvestmentsLoaded
                      ? state.hasReachedMax
                      : true;

                  if (constraints.maxWidth > 800.0) {
                    return DesktopTable(
                      investments: allInvestments,
                      showLoader: state is CreatingInvestment || isLoadingMore,
                      canLoadMore: canLoadMore,
                      onLoadMore: () {
                        context.read<InvestmentsBloc>().add(
                          const LoadMoreInvestments(),
                        );
                      },
                      onInvestmentTap: _navigateToInvestmentDetails,
                    );
                  } else {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        return _handleScrollNotification(
                          scrollInfo: scrollInfo,
                          state: state,
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16.0, 112, 16, 104),
                        itemCount: state is CreatingInvestment
                            ? allInvestments.length + 1
                            : allInvestments.length +
                                  // Add extra item for loader.
                                  (hasReachedMax ? 0 : 1),
                        itemBuilder: (BuildContext _, int index) {
                          if (state is CreatingInvestment &&
                              index == allInvestments.length) {
                            return Center(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: constants.maxWidth,
                                ),
                                child: const ShimmerInvestment(),
                              ),
                            );
                          } else if (index == allInvestments.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          final Investment investment = allInvestments[index];
                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: constants.maxWidth,
                              ),
                              child: InvestmentTile(investment: investment),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            );
          }

          return Stack(
            children: <Widget>[
              content,
              if (state.isRefreshing)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 3),
                ),
            ],
          );
        },
      ),
      floatingActionButton: BlurredFabWithBorder(
        onPressed: _navigateToAddEditPage,
        tooltip: translate('investments.add_investment_tooltip'),
        icon: Icons.add,
      ),
    );
  }

  @override
  void dispose() {
    _scaffoldMessenger?.clearMaterialBanners();
    _scaffoldMessenger = null;
    _feedbackController?.removeListener(_onFeedbackChanged);
    _feedbackController = null;
    super.dispose();
  }

  void _showDemoBanner() {
    if (mounted) {
      _scaffoldMessenger?.showMaterialBanner(
        MaterialBanner(
          backgroundColor: Colors.amber.shade800,
          content: SelectableText(
            translate('demo.banner_message'),
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _scaffoldMessenger?.clearMaterialBanners();
                Navigator.of(
                  context,
                ).pushReplacementNamed(AppRoute.signIn.path);
              },
              child: Text(
                translate('demo.sign_in_action'),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _handleInvestmentsState(BuildContext context, InvestmentsState state) {
    if (state is UnauthenticatedInvestmentsAccessState) {
      context.read<AuthenticationBloc>().add(
        const AuthenticationSignOutPressed(),
      );
    } else if (state is InvestmentDeleted) {
      final String message = state.message;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
      );
    }
  }

  void _showFeedbackUi() {
    _feedbackController?.show((UserFeedback feedback) {
      context.read<MenuBloc>().add(SubmitFeedbackEvent(feedback));
    });
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

  Future<void> _navigateToInvestmentDetails(Investment investment) async {
    final bool? deleted = await Navigator.of(context).push<bool?>(
      SlidePageRoute<bool?>(
        page: BlocProvider<InvestmentsBloc>.value(
          value: context.read<InvestmentsBloc>()
            ..add(LoadInvestment(investment)),
          child: const InvestmentPage(),
        ),
      ),
    );

    if (deleted == true && mounted) {
      // If an investment was deleted, refresh the list to ensure UI is in sync.
      context.read<InvestmentsBloc>().add(const LoadInvestments());
    }
  }

  void _navigateToAddEditPage() {
    if (widget.isDemo) {
      _showDemoSignInPrompt();
    } else {
      Navigator.of(context).push<bool?>(
        SlidePageRoute<bool?>(
          page: BlocProvider<InvestmentsBloc>.value(
            value: context.read<InvestmentsBloc>(),
            child: const AddEditInvestmentPage(),
          ),
        ),
      );
    }
  }

  Future<void> _navigateToImportPage() {
    return Navigator.of(context).push<void>(
      SlidePageRoute<void>(
        page: BlocProvider<InvestmentsBloc>.value(
          value: context.read<InvestmentsBloc>(),
          child: const XlsxImportPage(),
        ),
      ),
    );
  }

  Future<void> _showDemoSignInPrompt() {
    final NavigatorState navigator = Navigator.of(context);
    final ScaffoldMessengerState? messenger = _scaffoldMessenger;
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.lock_outline,
                size: 48,
                color: Theme.of(sheetContext).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                translate('demo.sign_in_required_title'),
                style: Theme.of(sheetContext).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                translate('demo.sign_in_required_body'),
                textAlign: TextAlign.center,
                style: Theme.of(sheetContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    messenger?.clearMaterialBanners();
                    navigator.pushReplacementNamed(AppRoute.signIn.path);
                  },
                  child: Text(translate('demo.sign_in_action')),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(sheetContext).pop(),
                child: Text(translate('demo.continue_demo_action')),
              ),
            ],
          ),
        );
      },
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
    required InvestmentsState state,
  }) {
    if (state is InvestmentsLoaded) {
      if (scrollInfo.metrics.axis == Axis.vertical &&
          scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent &&
          !state.isLoadingMore &&
          !state.hasReachedMax) {
        context.read<InvestmentsBloc>().add(const LoadMoreInvestments());
      }
    }
    return false;
  }

  String _formatLastUpdated(DateTime lastUpdated) {
    final DateTime now = DateTime.now();
    final bool isToday =
        lastUpdated.year == now.year &&
        lastUpdated.month == now.month &&
        lastUpdated.day == now.day;
    if (isToday) {
      final String timeStr = DateFormat.jm().format(lastUpdated);
      return '${translate('investments.last_updated_today_at')} $timeStr';
    } else {
      final String dateStr = DateFormat(
        constants.lastUpdatedDateFormat,
      ).format(lastUpdated);
      return '${translate('investments.last_updated_at')} $dateStr';
    }
  }
}
