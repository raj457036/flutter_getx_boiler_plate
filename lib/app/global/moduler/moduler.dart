import 'module.dart';

class Moduler {
  Moduler._();
  static Moduler _instance = Moduler._();
  static Moduler get instance => _instance;
  static Moduler get I => instance;

  final Set<Module> _activeModule = {};

  load(List<Moduler> activeModules) {
    // _activeModule.addAll(activeModules);
  }
}
