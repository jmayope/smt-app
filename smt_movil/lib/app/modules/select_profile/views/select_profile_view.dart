import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/select_profile_controller.dart';

class SelectProfileView extends GetView<SelectProfileController> {
  const SelectProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SelectProfileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SelectProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
