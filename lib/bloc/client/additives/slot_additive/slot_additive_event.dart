
part of 'slot_additive_bloc.dart';

class SlotAdditiveEvent{}

class SlotAdditiveInitialEvent extends SlotAdditiveEvent{}

class SlotAdditiveGetEvent extends SlotAdditiveEvent{
  int id;
  SlotAdditiveGetEvent(this.id);
}