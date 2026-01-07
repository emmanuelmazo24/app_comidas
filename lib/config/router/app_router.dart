import 'package:app_comidas/presentation/alta_comida.dart';
import 'package:app_comidas/presentation/home/home_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/', //Raiz
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/alta_comidas',
      builder: (context, state) => const AddComidas(),
    ),
  ],
);
