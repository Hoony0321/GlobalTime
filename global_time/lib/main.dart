import 'package:flutter/material.dart';
import 'package:global_time/features/home/provider/time_zone_provider.dart';
import 'package:global_time/features/home/home_screen.dart';
import 'package:global_time/features/home/provider/country_info_provider.dart';
import 'package:global_time/features/home/provider/selected_datetime_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TimeZoneProvider 초기화
  await TimeZoneProvider.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SelectedDatetimeProvider()),
    ChangeNotifierProvider(create: (context) => CountryInfoProvider()),
    ChangeNotifierProxyProvider(
        create: (context) => TimeZoneProvider(
            selectedDatetimeProvider: context.read<SelectedDatetimeProvider>()),
        update: (context, value, previous) => previous!)
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const textColor = Color.fromARGB(255, 227, 227, 227);
    const textColor2 = Color(0xFF4A4A4A);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GlobalTime',
      theme: ThemeData(
          useMaterial3: true,
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
                color: textColor,
                fontSize: 32,
                fontWeight: FontWeight.bold), // 메인 헤드라인
            headlineMedium: TextStyle(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.w600), // 부 헤드라인
            headlineSmall: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.w600), // 부 헤드라인
            bodyLarge: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.normal), // 일반 본문 텍스트
            bodyMedium: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.normal), // 보조 본문 텍스트
            bodySmall: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w300), // 캡션
            labelLarge: TextStyle(
                color: textColor2,
                fontSize: 16,
                fontWeight: FontWeight.w600), // 버튼 텍스트 (버튼 배경이 밝은 경우)
          ),
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color.fromARGB(255, 20, 20, 20),
            onPrimary: Color(0xFFbdbdbd),
            secondary: Color(0xFF4A4A4A),
            onSecondary: Color(0xFFbdbdbd),
            error: Color(0xFFff4d4f),
            onError: Color(0xFFbdbdbd),
            surface: Color.fromARGB(255, 34, 43, 62),
            onSurface: Color(0xFFbdbdbd),
          )),
      home: const HomeScreen(),
    );
  }
}
