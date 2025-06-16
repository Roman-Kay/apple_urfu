
part of "subscribe_bloc.dart";

class SubscribeState{}

class SubscribeInitialState extends SubscribeState{}

class SubscribeLoadingState extends SubscribeState{}

class SubscribeLoadedState extends SubscribeState{
  SubscribeStep? view;
  SubscribeLoadedState(this.view);
}

class SubscribeErrorState extends SubscribeState{}