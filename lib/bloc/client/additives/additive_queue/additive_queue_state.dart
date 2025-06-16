
part of "additive_queue_bloc.dart";

class AdditiveQueueState{}

class AdditiveQueueInitialState extends AdditiveQueueState{}

class AdditiveQueueLoadingState extends AdditiveQueueState{}

class AdditiveQueueLoadedState extends AdditiveQueueState{
  Map<String, List<ClientAdditivesView>>? view;
  AdditiveQueueLoadedState(this.view);
}

class AdditiveQueueErrorState extends AdditiveQueueState{}