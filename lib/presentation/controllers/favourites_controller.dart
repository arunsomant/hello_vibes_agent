import 'package:get/get.dart';

import '../../data/models/user.dart';

class FavouritesController extends GetxController {
  final users = User.users.obs;

  void onAudioCallPressed(int index) {}

  void onFavouritePressed(int index) {
    users.removeAt(index);
  }

  void onVideoCallPressed(int index) {}
}
