part of 'accessibility_controller_cubit.dart';

enum AccessibilityControllerStatus { normal, big, biggest }

enum AccessibilityControllerBlindness { normal, blind }

class AccessibilityControllerState extends Equatable {
  final AccessibilityControllerStatus status;
  final AccessibilityControllerBlindness blindness;

  const AccessibilityControllerState({
    this.status = AccessibilityControllerStatus.normal,
    this.blindness = AccessibilityControllerBlindness.normal,
  });

  factory AccessibilityControllerState.fromJson(Map<String, dynamic> json) {
    return AccessibilityControllerState(
      status: AccessibilityControllerStatus.values.firstWhere(
        (element) => element.name.toString() == json['status'],
      ),
      blindness: AccessibilityControllerBlindness.values.firstWhere(
        (element) => element.name.toString() == json['blindness'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'blindness': blindness.name,
    };
  }

  @override
  List<Object> get props => [status, blindness];
}
