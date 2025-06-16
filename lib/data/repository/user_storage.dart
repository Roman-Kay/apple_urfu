
import 'package:garnetbook/data/models/user/user_model.dart';

class UserService {
  static UserView? _user;

  UserView getUser() {
    return _user!;
  }
}
