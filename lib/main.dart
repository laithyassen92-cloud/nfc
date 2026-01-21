import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/students/presentation/screens/NfcHomePage.dart';
import 'core/app_theme.dart';
import 'core/service_locator.dart';
import 'features/auth/presentation/cubits/auth_cubit.dart';
import 'features/students/presentation/cubits/students_cubit.dart';
import 'features/wallet/presentation/cubits/wallet_cubit.dart';
import 'features/wallet/presentation/cubits/transactions_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/wallet/presentation/screens/cash_in_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize service locator for dependency injection
  final serviceLocator = ServiceLocator();
  serviceLocator.initialize();

  runApp(NfcReaderApp(serviceLocator: serviceLocator));
}

/// Main application widget
class NfcReaderApp extends StatelessWidget {
  final ServiceLocator serviceLocator;

  const NfcReaderApp({super.key, required this.serviceLocator});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => serviceLocator.authCubit),
        BlocProvider<StudentsCubit>(
          create: (context) => serviceLocator.studentsCubit,
        ),
        BlocProvider<WalletCubit>(
          create: (context) => serviceLocator.walletCubit,
        ),
        BlocProvider<TransactionsCubit>(
          create: (context) => serviceLocator.transactionsCubit,
        ),
      ],
      child: MaterialApp(
        title: 'NFC Reader',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              // Store auth token in service locator for API calls
              serviceLocator.setAuthToken(state.token);
              return const NfcHomePage();
            }

            return const CashInPage();
          },
        ),
      ),
    );
  }
}
