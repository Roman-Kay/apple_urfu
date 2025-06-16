
part of 'slot_additive_bloc.dart';

class SlotAdditiveState{}

class SlotAdditiveInitialState extends SlotAdditiveState{}

class SlotAdditiveLoadingState extends SlotAdditiveState{}

class SlotAdditiveLoadedState extends SlotAdditiveState{
  List<AdditiveSlotsView>? slots;
  SlotAdditiveLoadedState(this.slots);
}

class SlotAdditiveErrorState extends SlotAdditiveState{}