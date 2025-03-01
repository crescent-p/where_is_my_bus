import 'package:rive/rive.dart';

class RiveUtils {
  static StateMachineController getStateMachineController(Artboard artboard,
      {String stateMachineName = "State Machine 1"}) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);
    artboard.addController(controller!);
    return controller;
  }
}
