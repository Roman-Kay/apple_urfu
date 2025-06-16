
part of 'tariffs_bloc.dart';

class TariffsExpertEvent{}

class TariffsExpertAddEvent extends TariffsExpertEvent{
  ExpertTariffCreateRequest request;
  TariffsExpertAddEvent(this.request);
}

class TariffsExpertGetEvent extends TariffsExpertEvent{}