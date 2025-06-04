import 'package:flutter/material.dart';
import 'package:tikzy/screens/dashboard/dashboard_screen.dart';
import 'package:tikzy/screens/profile/profile_screen.dart';
import 'package:tikzy/screens/projects/add_projects_screen.dart';
import 'package:tikzy/screens/projects/project_list_page.dart';
import 'package:tikzy/screens/tickets/createticketpage.dart';
import 'package:tikzy/screens/tickets/ticketDetailsScreen.dart';
import 'package:tikzy/screens/tickets/ticket_list_page.dart';
import 'package:tikzy/screens/users/add_user_page.dart';

import '../screens/signin/signin_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/users/user_list_page.dart';

class Routes {
  static const String splash = '/';
  static const String signin = 'signin';
  static const String dashboard = 'dashboard';
  static const String createticket = 'createticket';
  static const String createproject = 'createproject';
  static const String projectlist = 'projectlist';
  static const String ticketlistpage = 'ticketlistpage';
  static const String userlistpage = 'userlistpage';
  static const String adduserpage = 'adduserpage';
  static const String ticketdetailpage = 'ticketdetailpage';
  static const String profilepage = 'profilepage';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case ticketlistpage:
        return MaterialPageRoute(builder: (_) => TicketsListPage());
      case userlistpage:
        return MaterialPageRoute(builder: (_) => UserListPage());
      case adduserpage:
        return MaterialPageRoute(builder: (_) => AddUserPage());
      case profilepage:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case ticketdetailpage:
        return MaterialPageRoute(
          builder: (_) => TicketDetailPage(ticket: args?['ticket']),
        );
      case createticket:
        return MaterialPageRoute(builder: (_) => CreateTicketPage());
      case createproject:
        return MaterialPageRoute(builder: (_) => AddProjectPage());
      case projectlist:
        return MaterialPageRoute(builder: (_) => ProjectListPage());
      default:
        return MaterialPageRoute(builder: (_) => SigninScreen());
    }
  }
}
