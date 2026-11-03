import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/route_active_controller.dart';

class RouteActiveView extends GetView<RouteActiveController> {
  const RouteActiveView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RouteActiveView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RouteActiveView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
