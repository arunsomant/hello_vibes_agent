import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/landing_controller.dart';
import '../../widgets/index.dart';
import 'calls_tab.dart';
import 'profile_tab.dart';
import 'transactions_tab.dart';

class LandingPage extends GetView<LandingController> {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Align(
          alignment: Alignment.bottomCenter,
          child: Obx(() {
            return MTAppBar(
              user: controller.user,
              onOnlineStatusChanged: (value) {
                controller.onOnlineStatusChanged.call(value);
              },
            );
          }),
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: [CallsTab(), TransactionsTab(), ProfileTab()],
      ),
      bottomNavigationBar: Obx(() {
        return MTAppBottomBar(
          activeTabIndex: controller.activeTabIndex.value,
          onTabClicked: controller.onTabClicked,
        );
      }),
    );
  }
}
