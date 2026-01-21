import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mars_workout_app/core/services/audio_service.dart';
import 'package:mars_workout_app/core/theme/app_theme.dart';
import 'package:mars_workout_app/presentation/screens/home_screen/home_page.dart';
import 'package:mars_workout_app/presentation/widgets/resume_workout_dialog.dart';
import 'package:path_provider/path_provider.dart';
import '../../logic/bloc/plan/plan_bloc.dart';
import '../../logic/bloc/workout_session/workout_session_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 2. MAKE SYSTEM BARS TRANSPARENT
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark, systemNavigationBarColor: Colors.transparent, systemNavigationBarIconBrightness: Brightness.dark));
  HydratedBloc.storage = await HydratedStorage.build(storageDirectory: await getApplicationDocumentsDirectory());
  await SoundService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PlanBloc()),
        BlocProvider(create: (_) => WorkoutSessionBloc()),
      ],
      child: MaterialApp(
        title: 'Workout Planner',
        darkTheme: AppTheme.lightTheme,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const HomePageWithResumeCheck(),
        // Define your routes for timer/details here...
      ),
    );
  }
}

/// Wrapper that checks for saved workout sessions on startup
class HomePageWithResumeCheck extends StatefulWidget {
  const HomePageWithResumeCheck({super.key});

  @override
  State<HomePageWithResumeCheck> createState() => _HomePageWithResumeCheckState();
}

class _HomePageWithResumeCheckState extends State<HomePageWithResumeCheck> {
  @override
  void initState() {
    super.initState();
    // Check for saved workout session after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForSavedWorkout();
    });
  }

  void _checkForSavedWorkout() {
    final sessionState = context.read<WorkoutSessionBloc>().state;
    if (sessionState.hasSession && sessionState.session != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ResumeWorkoutDialog(session: sessionState.session!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
