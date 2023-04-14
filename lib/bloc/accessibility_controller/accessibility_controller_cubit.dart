import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'accessibility_controller_state.dart';

class AccessibilityControllerCubit
    extends HydratedCubit<AccessibilityControllerState> {
  AccessibilityControllerCubit() : super(const AccessibilityControllerState());

  void changeToNormalStyle() {
    emit(
      AccessibilityControllerState(
        status: AccessibilityControllerStatus.normal,
        blindness: state.blindness,
      ),
    );
  }

  void changeToBiggerStyle() {
    emit(
      AccessibilityControllerState(
        status: AccessibilityControllerStatus.big,
        blindness: state.blindness,
      ),
    );
  }

  void changeToBiggestStyle() {
    emit(
      AccessibilityControllerState(
        status: AccessibilityControllerStatus.biggest,
        blindness: state.blindness,
      ),
    );
  }

  void enableColorBlind() {
    emit(
      AccessibilityControllerState(
        status: state.status,
        blindness: AccessibilityControllerBlindness.blind,
      ),
    );
  }

  void disableColorBlind() {
    emit(
      AccessibilityControllerState(
        status: state.status,
        blindness: AccessibilityControllerBlindness.normal,
      ),
    );
  }

  @override
  AccessibilityControllerState? fromJson(Map<String, dynamic> json) {
    return AccessibilityControllerState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(AccessibilityControllerState state) {
    return state.toJson();
  }
}
