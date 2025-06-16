

part of 'user_data_cubit.dart';

class UserDataState{}

class UserDataInitialState extends UserDataState{}

class UserDataLoadingState extends UserDataState{}

class UserDataLoadedState extends UserDataState{
  UserView? user;
  UserDataLoadedState(this.user);
}

class UserDataErrorState extends UserDataState{}
