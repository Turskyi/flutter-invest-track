import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:investtrack/application_services/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:investtrack/application_services/blocs/menu/menu_bloc.dart';
import 'package:investtrack/res/constants/constants.dart' as constants;
import 'package:investtrack/ui/privacy/privacy_policy_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    LocalizationProvider.of(context);
    final ThemeData theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text(
                      constants.appName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  accountEmail:
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (_, AuthenticationState state) {
                      final String email = state.user.email;
                      return Text(
                        email.isNotEmpty ? email : translate('menu.no_email'),
                        style: TextStyle(color: theme.colorScheme.onPrimary),
                      );
                    },
                  ),
                  currentAccountPicture: Image.asset('assets/images/logo.png'),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        theme.colorScheme.primary,
                        theme.colorScheme.secondary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(translate('menu.privacy_policy')),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PrivacyPolicyPage(),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: Text(translate('menu.feedback')),
                  onTap: () => _showFeedbackDialog(context),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(translate('menu.sign_out')),
                  onTap: () => context.read<AuthenticationBloc>().add(
                    const AuthenticationSignOutPressed(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 16),
          SafeArea(
            top: false,
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (BuildContext context, AuthenticationState state) {
                const double progressIndicatorSize = 24.0;
                final AuthenticationStatus status = state.status;
                final bool isDeleting =
                    status is DeletingAuthenticatedUserStatus;
                return ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                    color: theme.colorScheme.error,
                  ),
                  title: Text(
                    translate('menu.delete_account'),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  trailing: isDeleting
                      ? const SizedBox(
                          width: progressIndicatorSize,
                          height: progressIndicatorSize,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                  onTap: isDeleting
                      ? null
                      : () async {
                          await _handleDeleteAccount(context);
                        },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteAccount(BuildContext context) async {
    final bool? confirmed = await _showDeleteAccountConfirmationDialog(context);
    if (context.mounted && confirmed == true) {
      context.read<AuthenticationBloc>().add(
        const AuthenticationAccountDeletionRequested(),
      );
    }
  }

  Future<bool?> _showDeleteAccountConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translate('menu.delete_account')),
          content: Text(translate('menu.delete_account_confirmation')),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(translate('menu.cancel')),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(translate('menu.delete')),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    return context.read<MenuBloc>().add(const BugReportPressedEvent());
  }
}
