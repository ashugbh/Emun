import 'package:go_router/go_router.dart';
import 'package:emun/core/router/route_name.dart';
import 'package:emun/features/auth/presentation/onboarding_screen.dart';
import 'package:emun/features/auth/presentation/login_screen.dart';
import 'package:emun/features/auth/presentation/register_screen.dart';
import 'package:emun/features/main/presentation/main_screen.dart';
import 'package:emun/features/listings/presentation/listing_detail_screen.dart';
import 'package:emun/features/messages/presentation/chat_screen.dart';
import 'package:emun/features/admin/presentation/admin_dashboard_screen.dart';

final router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      name: RouteName.onboarding,
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      name: RouteName.login,
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: RouteName.register,
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      name: RouteName.main,
      path: '/main',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      name: RouteName.listingDetail,
      path: '/listing/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return ListingDetailScreen(listingId: id);
      },
    ),
    GoRoute(
      name: RouteName.chat,
      path: '/chat/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        final listingTitle = state.extra as String?;
        return ChatScreen(conversationId: id, listingTitle: listingTitle);
      },
    ),
    GoRoute(
      name: RouteName.admin,
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
  ],
);
