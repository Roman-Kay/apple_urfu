
part of 'profile_cubit.dart';

class ProfileExpertState{}

class ProfileExpertInitialState extends ProfileExpertState{}

class ProfileExpertLoadingState extends ProfileExpertState{}

class ProfileExpertLoadedState extends ProfileExpertState{
  ExpertProfileView? view;
  ProfileExpertLoadedState(this.view);
}

class ProfileExpertErrorState extends ProfileExpertState{}