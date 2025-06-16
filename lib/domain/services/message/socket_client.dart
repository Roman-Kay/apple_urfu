import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:flutter/material.dart';
import 'package:garnetbook/data/repository/shared_preference_data.dart';
import 'package:garnetbook/domain/config/environment.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_client/web_socket_client.dart';


class SocketService with ChangeNotifier{
  SocketService() : super() {
    _notifyStream.listen((value) {});
  }

  final WebSocket _channel = WebSocket(
      Uri.parse(Environment().config.apiMessageWebsocket),
      backoff: ConstantBackoff(Duration(seconds: 30))
  );

  late final BehaviorSubject<dynamic> _notifyStream = BehaviorSubject()..addStream(_channel.messages);

  Timer? _timer;
  Timer? _timer2;
  String userid = "";
  String secret = "";

  BehaviorSubject<dynamic> get notifyStream => _notifyStream;

  Connection get connection => _channel.connection;

  Future<void> init(String userid, String secret) async {
    await _channel.connection.firstWhere((state) => state is Connected).then((value) {
      subscribeToChannel(userid, secret);
      ping();
    });
  }

  void subscribeToChannel(String userid, String secret){
    if(userid != "" && secret != ""){
      final message = json.encode({
        "event": "subscribe",
        "data" : {
          "userid" : userid,
          "secret" : secret
        }
      });

      this.userid = userid;
      this.secret = secret;

      _channel.send(message);

      resubscribe();
    }
    else{
      getDataFromStorage();
    }
  }

  void resubscribe() {
    _timer2?.cancel();
    _timer2 = Timer.periodic(const Duration(minutes: 5), (timer) {

      if(this.userid != "" && this.secret != ""){
        final message = json.encode({
          "event": "subscribe",
          "data" : {
            "userid" : this.userid,
            "secret" : this.secret
          }
        });
        try {
          _channel.send(message);
        } catch (e) {
          timer.cancel();
        }
      }
      else{
        getDataFromStorage();
      }
    });
  }

  void ping() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 50), (timer) {
      final message = json.encode({
        "event": "ping",
        "data" : "ping"
      });
      try {
        _channel.send(message);
      } catch (e) {
        timer.cancel();
      }
    });
  }

  void closeChannel() {
    _timer?.cancel();
    _timer2?.cancel();
    _channel.close();
  }

  Future<void> getDataFromStorage() async{
    final storage = SharedPreferenceData.getInstance();
    final role = await storage.getItem(SharedPreferenceData.role);
    final storageSecret = await storage.getItem(SharedPreferenceData.secretKey);
    String userId = "";

    if(role == "1"){
      userId = await storage.getItem(SharedPreferenceData.clientIdKey);
    }
    else if(role == "2"){
      userId = await storage.getItem(SharedPreferenceData.expertIdKey);
    }

    if(userId != ""){
      this.userid = userId;
    }

    if(secret != ""){
      this.secret = storageSecret;
    }
  }
}




