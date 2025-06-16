
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/domain/interactor/blocs_provider_expert.dart';
import 'package:garnetbook/domain/services/message/socket_client.dart';
import 'package:provider/provider.dart';

@RoutePage()
class DashboardContainerExpertPage extends StatelessWidget {
  const DashboardContainerExpertPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocsProvider().providersExpert(),
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