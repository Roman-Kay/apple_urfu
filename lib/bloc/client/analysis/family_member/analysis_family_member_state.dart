
part of 'analysis_family_member_bloc.dart';

class AnalysisFamilyMemberState{}

class AnalysisFamilyMemberInitialState extends AnalysisFamilyMemberState{}

class AnalysisFamilyMemberLoadingState extends AnalysisFamilyMemberState{}

class AnalysisFamilyMemberLoadedState extends AnalysisFamilyMemberState{
  List<ClientTestShort>? view;
  AnalysisFamilyMemberLoadedState(this.view);
}

class AnalysisFamilyMemberErrorState extends AnalysisFamilyMemberState{}
