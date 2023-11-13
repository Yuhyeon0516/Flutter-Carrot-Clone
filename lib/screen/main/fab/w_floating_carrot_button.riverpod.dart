import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingButtonState {
  bool isExpanded;
  bool isSmall;
  bool isHided;

  FloatingButtonState()
      : isExpanded = false,
        isSmall = false,
        isHided = false;
}

final floatingButtonStateProvider =
    StateNotifierProvider<FloatingButtonStateNorifier, FloatingButtonState>(
  (ref) => FloatingButtonStateNorifier(
    FloatingButtonState(),
  ),
);

class FloatingButtonStateNorifier extends StateNotifier<FloatingButtonState> {
  FloatingButtonStateNorifier(super.state);

  bool needToMakeButtonBigger = false;

  @override
  bool updateShouldNotify(
      FloatingButtonState old, FloatingButtonState current) {
    return true;
  }

  void toggleMenu() {
    final oldIsExpanded = state.isExpanded;
    final oldIsSmall = state.isSmall;

    state.isExpanded = !state.isExpanded;
    state.isSmall = needToMakeButtonBigger ? false : true;
    state = state;

    if (needToMakeButtonBigger) {
      needToMakeButtonBigger = false;
    }

    if (!oldIsSmall && !oldIsExpanded) {
      needToMakeButtonBigger = true;
    }
  }

  void changeButtonSize(bool isSmall) {
    if (state.isExpanded) {
      return;
    }
    state.isSmall = isSmall;

    state = state;
  }

  void hideButton() {
    state.isHided = true;
    state = state;
  }

  void showButton() {
    state.isHided = false;
    state = state;
  }
}
