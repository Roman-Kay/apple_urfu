
part of 'analysis_family_member_bloc.dart';

class AnalysisFamilyMemberEvent{}

class AnalysisFamilyMemberGetEvent extends AnalysisFamilyMemberEvent{
  int id;
  AnalysisFamilyMemberGetEvent(this.id);
}