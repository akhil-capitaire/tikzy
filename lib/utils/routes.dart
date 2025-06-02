import 'package:flutter/material.dart';
import 'package:tikzy/screens/addticket/createticketpage.dart';
import 'package:tikzy/screens/adduser/add_user_page.dart';
import 'package:tikzy/screens/dashboard/dashboard_screen.dart';
import 'package:tikzy/screens/tickets/ticketDetailsScreen.dart';
import 'package:tikzy/screens/tickets/ticket_list_page.dart';

import '../screens/signin/signin_screen.dart';
import '../screens/splash/splash_screen.dart';

class Routes {
  static const String splash = '/';
  static const String signin = 'signin';
  static const String dashboard = 'dashboard';
  static const String createticket = 'createticket';
  static const String ticketlistpage = 'ticketlistpage';
  static const String adduserpage = 'adduserpage';
  static const String ticketdetailpage = 'ticketdetailpage';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>?;
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case ticketlistpage:
        return MaterialPageRoute(builder: (_) => TicketsListPage());
      case adduserpage:
        return MaterialPageRoute(builder: (_) => AddUserPage());
      case ticketdetailpage:
        return MaterialPageRoute(
          builder: (_) => TicketDetailPage(ticket: args?['ticket']),
        );
      case createticket:
        return MaterialPageRoute(builder: (_) => CreateTicketPage());
      default:
        return MaterialPageRoute(builder: (_) => SigninScreen());
    }
  }
}
