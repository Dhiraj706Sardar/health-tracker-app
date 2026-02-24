import 'package:get/get.dart';
import '../views/login_view.dart';
import '../views/dashboard_view.dart';
import '../views/graph_view.dart';
import '../views/activity_logs_view.dart';

class AppRoutes {
  AppRoutes._();

  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String graph = '/graph';
  static const String activityLogs = '/activity-logs';

  static List<GetPage> routes = [
    GetPage(name: login, page: () => const LoginView(), transition: Transition.fadeIn),
    GetPage(name: dashboard, page: () => const DashboardView(), transition: Transition.fadeIn),
    GetPage(name: graph, page: () => const GraphView(), transition: Transition.rightToLeft),
    GetPage(name: activityLogs, page: () => const ActivityLogsView(), transition: Transition.rightToLeft),
  ];
}
