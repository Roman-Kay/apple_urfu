
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_health_fit/flutter_health_fit.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/controllers/health/health_controller.dart';
import 'package:garnetbook/domain/services/health/health_service.dart';
import 'package:permission_handler/permission_handler.dart';
part 'health_main_state.dart';

class HealthMainCubit extends Cubit<HealthMainState>{
  HealthMainCubit() : super(HealthMainInitialState());

  HealthService healthService = HealthService();
  HealthServiceController healthController = HealthServiceController();


  check() async{
    final storage = SharedPreferenceData.getInstance();
    final isRegister = await storage.getItem(SharedPreferenceData.isRegisterGoogleFit);

    if(isRegister == ""){

      final isHealthFitAuth = await healthService.isAuthHealthFit();

      if(!isHealthFitAuth){
        final isHealthAuth = await healthService.isAuthHealth();

        if(isHealthAuth){
          await FlutterHealthFit().authorize();
        }
      }

      var status = await Permission.activityRecognition.status;
      if (status != PermissionStatus.granted) {
        Permission.activityRecognition.request();
      }

      await storage.setItem(SharedPreferenceData.isRegisterGoogleFit, "true");
    }

  }

}
