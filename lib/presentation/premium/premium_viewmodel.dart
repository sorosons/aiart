import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:rxdart/rxdart.dart';

import '../../app/logger_settings.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';
import '../resources/strings_manager.dart';

class SubscriptionViewModel extends BaseViewModel
    with SubscriptionViewModeInput, SubscriptionViewModeOutput {
  // SetSubScribeUseCase _setSubScribeUseCase;
  //SubscriptionViewModel(this._setSubScribeUseCase);

  final _setSubscribeController = BehaviorSubject<bool>();

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _setSubscribeController.close();
    super.dispose();
  }

  @override
  Stream<bool> get isSetSubScribeSuccess =>
      _setSubscribeController.stream.map((isSuccess) => isSuccess);

  /* @override
  setSubScribe(String status, String subscriptionEndDate) async {
  inputState.add(
  LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));

  (await _setSubScribeUseCase
      .execute(SetSubScribeUseCaseInput(status, subscriptionEndDate)))
      .fold((failure) {
  inputSubscribe.add(false);
  inputState.add(
  ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message));
  }, (success) {
  inputState.add(ContentState());
  inputSubscribe.add(true);
  inputState.add(SuccessState(AppStrings.success));
  });
  }*/

  @override
  subScribeFail() {
    logger.wtf("subScribeFail");

    inputState.add(
        ErrorState(StateRendererType.POPUP_ERROR_STATE, "Subscribe Failed"));
  }

  @override
  clickOkBtn() {
    logger.wtf("Clicked");
    inputState.add(ContentState());
  }

  @override
  showProgresBar() {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
  }

  @override
  showAlert(String message) {
    inputState.add(SuccessState(message));
  }

  @override
  // TODO: implement inputSubscribe
  Sink get inputSubscribe => _setSubscribeController.sink;
}

abstract class SubscriptionViewModeInput {
  //setSubScribe(String status, String subscriptionEndDate);
  subScribeFail();
  clickOkBtn();
  showProgresBar();
  showAlert(String message);
  Sink get inputSubscribe;
}

abstract class SubscriptionViewModeOutput {
  Stream<bool> get isSetSubScribeSuccess;
}
