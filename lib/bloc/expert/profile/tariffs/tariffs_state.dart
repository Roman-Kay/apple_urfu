
part of 'tariffs_bloc.dart';

class TariffsExpertState{}

class TariffsExpertInitialState extends TariffsExpertState{}

class TariffsExpertLoadingState extends TariffsExpertState{}

class TariffsExpertLoadedState extends TariffsExpertState{
  List<ExpertTariffView>? view;
  TariffsExpertLoadedState(this.view);
}

class TariffsExpertErrorState extends TariffsExpertState{}