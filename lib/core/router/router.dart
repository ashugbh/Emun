import 'package:go_router/go_router.dart';
import 'package:emun/core/navigation/navigation_service.dart';
import 'package:emun/core/presentation/main/main_screen.dart';
import 'package:emun/core/router/route_name.dart';
import 'package:emun/features/admin/presentation/pages/admin_dashboard_screen.dart';
import 'package:emun/features/auth/presentation/pages/login/login_screen.dart';
import 'package:emun/features/auth/presentation/pages/onboarding/onboarding_screen.dart';
import 'package:emun/features/auth/presentation/pages/registration/register_screen.dart';
import 'package:emun/features/listings/presentation/pages/detail/listing_detail_screen.dart';
import 'package:emun/features/messages/presentation/pages/chat/chat_screen.dart';

final router = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
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
