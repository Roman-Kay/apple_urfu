
import 'package:garnetbook/data/models/client/additives/additives_model.dart';

class Item {
  String imageName;
  String text;
  bool isChoose;

  Item({
    required this.imageName,
    required this.text,
    required this.isChoose
  });
}


class ItemWithPush {
  final String text;
  final push;
  final String? subText;

  ItemWithPush({
    required this.text,
    required this.push,
    this.subText
  });
}

class ItemWithTap {
  final String text;
  final Function() onTap;

  ItemWithTap({
    required this.text,
    required this.onTap,
  });
}


class MessageItem{
  MessageItem({
    required this.date,
    this.chatId,
    this.text,
    this.timestamp,
    this.authorId,
    this.type
});

  DateTime date;
  String? authorId;
  String? chatId;
  String? type;
  String? text;
  int? timestamp;
}


class AdditiveQueue {
  bool isOpen;
  List<ClientAdditivesView> queue;
  int queueNum;
  String queueName;

  AdditiveQueue({
    required this.queue,
    this.isOpen = false,
    required this.queueName,
    required this.queueNum
  });
}

class SlotAddsItem{
  SlotAddsItem({
    required this.date,
    required this.iChecked,
    required this.id,
    required this.numOfDay,
    required this.firstDate
  });

  int numOfDay;
  DateTime firstDate;
  DateTime date;
  bool iChecked;
  int id;
}


class SlotItem{
  SlotItem({
    required this.date,
    required this.iChecked,
    required this.id,
    required this.dayNumber,
    required this.currentMonth
  });

  DateTime date;
  bool iChecked;
  int id;
  int dayNumber;
  int currentMonth;
}
