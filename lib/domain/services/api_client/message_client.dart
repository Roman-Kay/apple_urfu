
import 'package:dio/dio.dart';
import 'package:garnetbook/data/models/message/message_chat_models/file_models.dart';
import 'package:garnetbook/data/models/message/message_chat_models/list_chat_models.dart';
import 'package:garnetbook/data/models/message/message_chat_models/message_model.dart';
import 'package:garnetbook/data/models/message/message_user_models/create_user_model.dart';
import 'package:garnetbook/data/models/notificaton/push_list_model.dart';
import 'package:garnetbook/data/models/notificaton/push_model.dart';
import 'package:retrofit/retrofit.dart';

part "message_client.g.dart";

@RestApi()
abstract class RestMessageUserClient {
  factory RestMessageUserClient(Dio dio, {String baseUrl}) = _RestMessageUserClient;

  //user
  @POST("/user")
  Future<CreateUserResponse> createUser(@Body() CreateUserRequest request);

  @GET("/user/{id}")
  Future<UserDataResponse> getUserData(@Path("id") String id);

  @PATCH("/user/{id}")
  Future<CreateUserResponse> updateUser(@Path("id") String id, @Body() UpdateUserRequest request);

  //message
  @GET("/message/{id}")
  Future<Message> getMessageData(@Path("id") String id);

  //file
  @GET("/file/{id}")
  Future<MessageFileData> getDocument(@Path("id") String id);
}



@RestApi()
abstract class RestMessageClient {
  factory RestMessageClient(Dio dio, {String baseUrl}) = _RestMessageClient;

  @GET("/user/{id}/chats")
  Future<ListMessageChatModel> getMessagesList(@Path("id") String id);

  @POST("/user/set-token")
  Future<void> updateMessageClientToken(@Header("userid") String userId);

  @GET("/chat/{id}")
  Future<MessageChatModel> getChatData(@Path("id") String id);

  @POST("/chat/")
  Future<CreateChatModel> createNewChat(@Body() CreateNewChatModel users);

  @PATCH("/chat/{id}")
  Future<MessageChatModel> updateChat(@Body() List<String> users);

  @POST("/chat/{id}/file")
  Future<MessageFileResponse> sendDocument(@Path("id") String id, @Body() MessageFileModels request);

  @GET("/chat/{id}/messages")
  Future<List<Message>> getLastChatMessages(@Path("id") String id, @Body() LastMessagesRequest request);


  //message
  @POST("/message")
  Future<Message> createMessage(@Body() CreateMessage request);

  @PATCH("/message/{id}")
  Future<Message> updateMessage(@Body() UpdateMessage request);

  @DELETE("/message/{id}")
  Future<void> deleteMessage(@Path("id") String id);

  @PATCH("/messages/readed")
  Future<void> readMessage(@Body() MessageReadModel request);


  //push
  @POST("/push")
  Future<PushSendView> sendPush(@Body() PushSendModel model);

  @PATCH("/push/{id}")
  Future<PushSendView> readPush(@Path("id") String id, @Body() PushReadView view);

  @GET("/push/{id}")
  Future<PushSendView> getPush(@Path("id") String id);

  @GET("/push")
  Future<PushListView> getPushList();


  //file

// @PATCH("/file/{id}")
// Future<DocumentResponse> updateDocument(@Path("id") int id, @Body() DocumentRequest request);
//
// @DELETE("/file/{id}")
// Future<void> deleteDocument(@Path("id") int id);


}