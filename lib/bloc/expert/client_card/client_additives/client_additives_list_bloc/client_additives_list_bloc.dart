
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garnetbook/data/models/client/additives/additives_model.dart';
import 'package:garnetbook/data/models/item/item_model.dart';

part 'client_additives_list_state.dart';
part 'client_additives_lists_event.dart';

class ClientAdditivesListBloc extends Bloc<ClientAdditivesListEvent, ClientAdditivesListState>{
  ClientAdditivesListBloc() : super(ClientAdditivesListState([
    AdditiveQueue(queue: [], queueName: '1 очередь', queueNum: 1),
    AdditiveQueue(queue: [], queueName: '2 очередь', queueNum: 2),
    AdditiveQueue(queue: [], queueName: '3 очередь', queueNum: 3),
    AdditiveQueue(queue: [], queueName: '4 очередь', queueNum: 4),
    AdditiveQueue(queue: [], queueName: '5 очередь', queueNum: 5),
    AdditiveQueue(queue: [], queueName: '6 очередь', queueNum: 6),
  ])){
    on<ClientAdditivesListGetEvent>(_get);
    on<ClientAdditivesListInitialEvent>(_initial);
    on<ClientAdditivesListDeleteEvent>(_delete);
  }

  List<AdditiveQueue> queueList = [
    AdditiveQueue(queue: [], queueName: '1 очередь', queueNum: 1),
    AdditiveQueue(queue: [], queueName: '2 очередь', queueNum: 2),
    AdditiveQueue(queue: [], queueName: '3 очередь', queueNum: 3),
    AdditiveQueue(queue: [], queueName: '4 очередь', queueNum: 4),
    AdditiveQueue(queue: [], queueName: '5 очередь', queueNum: 5),
    AdditiveQueue(queue: [], queueName: '6 очередь', queueNum: 6),
  ];

  Future<void> _get(ClientAdditivesListGetEvent event, Emitter<ClientAdditivesListState> emit) async{
    final add = event.add;

    queueList.forEach((element) {
      if(element.queue.isEmpty && element.queueName.contains("(")){
        element.queueName = "${element.queueNum} очередь";
      }
      if (element.queueNum == add.queueNum) {
        element.queue.add(add);
        if(add.queueName != null){
          element.queueName = add.queueName!;
        }
      }
      if(element.isOpen){
        element.isOpen = false;
      }
    });

    emit(ClientAdditivesListState(queueList));
  }


  Future<void> _initial(ClientAdditivesListInitialEvent event, Emitter<ClientAdditivesListState> emit) async{
    queueList = event.queueList ??  [
      AdditiveQueue(queue: [], queueName: '1 очередь', queueNum: 1),
      AdditiveQueue(queue: [], queueName: '2 очередь', queueNum: 2),
      AdditiveQueue(queue: [], queueName: '3 очередь', queueNum: 3),
      AdditiveQueue(queue: [], queueName: '4 очередь', queueNum: 4),
      AdditiveQueue(queue: [], queueName: '5 очередь', queueNum: 5),
      AdditiveQueue(queue: [], queueName: '6 очередь', queueNum: 6),
    ];

    emit(ClientAdditivesListState(queueList));
  }


  Future<void> _delete(ClientAdditivesListDeleteEvent event, Emitter<ClientAdditivesListState> emit) async{

    queueList.forEach((element){
      if(element.queue.contains(event.queue)){
        element.queue.remove(event.queue);
      }
    });

    emit(ClientAdditivesListState(queueList));
  }
}