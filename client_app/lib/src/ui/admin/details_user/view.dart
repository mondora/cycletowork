import 'package:badges/badges.dart';
import 'package:cycletowork/src/data/user.dart';
import 'package:cycletowork/src/theme.dart';
import 'package:cycletowork/src/ui/admin/details_user/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminDetailsUser extends StatelessWidget {
  final User user;
  final User userInfo;

  const AdminDetailsUser({
    Key? key,
    required this.user,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorSchemeExtension =
        Theme.of(context).extension<ColorSchemeExtension>()!;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    final actionColor = colorSchemeExtension.action;
    final userImageUrl = user.photoURL;
    final displayName = user.displayName;
    final email = user.email;

    return ChangeNotifierProvider<ViewModel>(
      create: (_) => ViewModel.instance(userInfo),
      child: Consumer<ViewModel>(
        builder: (context, viewModel, child) {
          final verified = (viewModel.uiState.userInfo != null &&
                  viewModel.uiState.userInfo!.verified) ||
              user.verified;

          final isAdmin = (viewModel.uiState.userInfo != null &&
                  viewModel.uiState.userInfo!.admin) ||
              user.admin;

          if (viewModel.uiState.error) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                      SnackBar(
                        backgroundColor: colorScheme.error,
                        content: Row(
                          children: [
                            Icon(
                              Icons.error,
                              color: colorScheme.onError,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              viewModel.uiState.errorMessage.toUpperCase(),
                              style: textTheme.button!.apply(
                                color: colorScheme.onError,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .closed
                    .then((value) => viewModel.clearError());
              },
            );
          }

          if (viewModel.uiState.loading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton.icon(
                  label: const Text('Diventa Admin'),
                  onPressed: !isAdmin ? () => viewModel.setAdminUser() : null,
                  icon: const Icon(
                    Icons.admin_panel_settings_rounded,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                TextButton.icon(
                  label: const Text('Verifica'),
                  onPressed: !verified ? () => viewModel.verifyUser() : null,
                  icon: const Icon(
                    Icons.verified_outlined,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 20.0,
                    ),
                    Tooltip(
                      message: verified ? 'VERIFICATO' : '',
                      child: Badge(
                        badgeColor: Colors.blueAccent,
                        position: BadgePosition.bottomEnd(end: 15.0),
                        showBadge: verified,
                        badgeContent: const Icon(
                          Icons.verified_outlined,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[400],
                          backgroundImage: userImageUrl != null
                              ? NetworkImage(userImageUrl)
                              : null,
                          child: userImageUrl == null
                              ? Icon(
                                  Icons.person,
                                  color: actionColor,
                                  size: 50,
                                )
                              : Container(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      displayName ?? '',
                      style: textTheme.bodyText1,
                    )
                  ],
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  'ACCOUNT',
                  style: textTheme.bodyText1!.apply(
                    color: colorSchemeExtension.textSecondary,
                  ),
                ),
                const SizedBox(
                  height: 6.0,
                ),
                Text(
                  'Email',
                  style: textTheme.caption!.apply(
                    color: colorSchemeExtension.textSecondary,
                  ),
                ),
                Text(
                  email,
                  style: textTheme.bodyText1,
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
