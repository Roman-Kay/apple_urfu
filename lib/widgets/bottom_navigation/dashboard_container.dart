
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/domain/interactor/blocs_provider.dart';
import 'package:garnetbook/domain/services/message/socket_client.dart';
import 'package:provider/provider.dart';

@RoutePage()
class DashboardContainerPage extends StatelessWidget {
  const DashboardContainerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: BlocsProvider().providersClient(),
        child: ScreenUtilInit(
            designSize: const Size(375, 812),
            builder: (context, child) {
            return const Scaffold(
              resizeToAvoidBottomInset: false,
              body: AutoRouter(),
            );
          }
        ),
    );
  }
}