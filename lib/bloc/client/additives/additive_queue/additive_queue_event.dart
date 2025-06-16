
part of "additive_queue_bloc.dart";

class AdditiveQueueEvent{}

class AdditiveQueueGetEvent extends AdditiveQueueEvent{
  ClientListAdditivesRequest request;
  AdditiveQueueGetEvent(this.request);
}