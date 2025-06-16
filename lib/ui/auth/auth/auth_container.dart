
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:garnetbook/bloc/client/target/target_bloc.dart';

@RoutePage()
class AuthContainerPage extends StatelessWidget {
  const AuthContainerPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TargetBloc(),
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return const Scaffold(
              body: AutoRouter(),
            );
          }
      ),
    );
  }
}