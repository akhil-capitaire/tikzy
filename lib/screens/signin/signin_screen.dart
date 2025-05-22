import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tikzy/utils/fontsizes.dart';

import '../../utils/routes.dart';
import '../../utils/screen_size.dart';
import '../../utils/spaces.dart';
import '../../widgets/buttons.dart';
import '../../widgets/custom_scaffold.dart';
import '../../widgets/form_input.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => SigninScreenState();
}

class SigninScreenState extends ConsumerState<SigninScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool forgotPassword = false;
  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScaffold(
      backNeeded: false,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(commonRadiusSize),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.12),
              theme.colorScheme.secondary.withOpacity(0.12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;

            return Center(
              child: isWide
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.width(6),
                        vertical: ScreenSize.height(6),
                      ),
                      child: buildWideLayout(theme),
                    )
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: ScreenSize.width(6),
                        vertical: ScreenSize.height(6),
                      ),
                      child: buildNarrowLayout(theme),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget buildWideLayout(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: buildTitlePanel(theme)),
        SizedBox(width: ScreenSize.width(6)),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ScreenSize.width(35),
            minWidth: ScreenSize.width(25),
          ),
          child: buildAuthCard(theme),
        ),
      ],
    );
  }

  Widget buildNarrowLayout(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildTitlePanel(theme),
        sb(0, 5),
        buildAuthCard(theme),
        sb(0, 3),
      ],
    );
  }

  Widget buildTitlePanel(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.account_circle_rounded,
          size: 72,
          color: theme.colorScheme.primary,
          shadows: [
            Shadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        sb(0, 2),
        Text(
          "Tikzy",
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.primary,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: theme.colorScheme.primary.withOpacity(0.25),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildAuthCard(ThemeData theme) {
    return Material(
      elevation: 14,
      borderRadius: BorderRadius.circular(commonRadiusSize),
      shadowColor: theme.colorScheme.primary.withOpacity(0.4),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenSize.width(6),
          vertical: ScreenSize.height(6),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(commonRadiusSize),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.06),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                forgotPassword ? "Forgot Password" : "Welcome Back",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
              sb(0, 4),
              FormInput(
                controller: emailController,
                hintText: 'Enter Email ID',
                validator: validateEmail,
                suffix: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              if (!forgotPassword) sb(0, 3),
              if (!forgotPassword)
                FormInput(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  hintText: 'Enter Password',
                  validator: validatePassword,
                  suffix: InkWell(
                    onTap: () =>
                        setState(() => obscurePassword = !obscurePassword),
                    child: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
              sb(0, 6),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: CustomButton(
                  label: forgotPassword ? 'Send OTP' : 'Login',
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      Navigator.pushReplacementNamed(context, Routes.dashboard);
                    }
                  },
                  isSmall: false,
                  type: forgotPassword
                      ? ButtonType.outlined
                      : ButtonType.primary,
                ),
              ),
              sb(0, 1),
              buildToggleLink(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToggleLink(ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => setState(() => forgotPassword = !forgotPassword),
        style: TextButton.styleFrom(
          foregroundColor: theme.colorScheme.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Text(forgotPassword ? "Sign In" : "Forgot Password?"),
      ),
    );
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w]{2,}$';
    if (!RegExp(pattern).hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) return 'Password is required';
    return null;
  }
}
