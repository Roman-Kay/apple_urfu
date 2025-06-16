import 'package:flutter_bloc/flutter_bloc.dart';

class VersionCubit extends Cubit<bool> {
  VersionCubit() : super(false);

  void toogle() {
    emit(!state);
  }
}
