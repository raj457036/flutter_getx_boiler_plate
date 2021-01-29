import 'package:get/get.dart';

import '../../controllers/global_controller.dart';
import '../../global/global.dart';

class DI {
  DI._();

  static DI _instance = DI._();
  static DI get instance => _instance;

  Future<void> _loadRepositories() async {
    // ? Load all the repositories here
    // Example: Get.lazyPut(() => MagicRepository(), fenix: true);
  }

  Future<void> _loadProviders() async {
    // ? Load all the providers here
    // Example: Get.lazyPut(() => MagicProvider(), fenix: true);
  }

  Future<void> _loadControllers() async {
    // ? Load all the controllers here
    // Example: Get.lazyPut(() => MagicController());

    Get.put<GlobalController>(GlobalController());
  }

  Future<void> _loadServices() async {
    // ? Load all the services here
    // Example: Get.put(() => MagicService());
  }

  Future<void> _loadExtra() async {
    // ? Load all the extra stuff here
    // Example: Something()..init() or Get.put(() => Something().important);;
    // Extra modules will be loaded after all other modules.
  }

  //? DO NOT PUT ANYTHING IN BELOW METHOD USE ABOVE AVAILABLE METHODS
  //? ACCORING TO THE CATEGORY
  void init() async {
    // Loading Global Modules
    await Modular.loadModules();
    await Future.microtask(_loadServices);
    await Future.microtask(_loadProviders);
    await Future.microtask(_loadRepositories);
    await Future.microtask(_loadControllers);

    await _loadExtra();
  }
}
