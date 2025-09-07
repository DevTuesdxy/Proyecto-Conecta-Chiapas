import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // <- puedes quitarlo por ahora
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/candidate_dashboard.dart';
import 'screens/company_dashboard.dart';
import 'screens/vacancy_list.dart';
import 'screens/vacancy_detail.dart';

void main() {
  runApp(const ConectaChiapasApp());
}

class ConectaChiapasApp extends StatelessWidget {
  const ConectaChiapasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conecta Chiapas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      routes: {
        '/': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/candidate': (_) => const CandidateDashboard(),
        '/company': (_) => const CompanyDashboard(),
        '/vacancies': (_) => const VacancyListScreen(),
        '/vacancy': (_) => const VacancyDetailScreen(),
      },
      initialRoute: '/',
    );
  }
}