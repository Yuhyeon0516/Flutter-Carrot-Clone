import 'package:flutter_riverpod/flutter_riverpod.dart';

class FloatingButtonState {
  bool isExpanded;
  bool isSmall;

  FloatingButtonState()
      : isExpanded = false,
        isSmall = false;
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

  void onTapButton() {
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
}
