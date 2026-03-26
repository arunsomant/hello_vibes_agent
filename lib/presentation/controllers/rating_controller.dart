import 'package:get/get.dart';

class RatingController extends GetxController {
  final rating = 0.0.obs;

  var addedToFavourite = false.obs;

  final reportOptions = <String>[
    'Inappropriate behaviour',
    'Fake profile',
    'Spam',
    'Harassment',
    'Other',
  ];

  final selectedReportOption = (-1).obs;

  bool get showReportCommentInput =>
      selectedReportOption.value >= reportOptions.length - 1;

  void askForCallingExperience() {}

  void onRatingPressed(double value) {
    if (value < 3) {
      addedToFavourite(false);
    } else {
      selectedReportOption(-1);
    }
    rating(value);
  }

  void onSubmitPressed() {
    Get.back();
  }

  void onAddToFavouritePressed() {
    addedToFavourite.toggle();
  }

  void onReportItemPressed(int index) {
    selectedReportOption(index);
  }
}

class ReportOption {
  final String title;
  final selected = false.obs;

  ReportOption(this.title);
}
