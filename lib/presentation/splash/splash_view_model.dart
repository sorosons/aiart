import 'package:complete_advanced_flutter/domain/model/init_model.dart';
import 'package:complete_advanced_flutter/domain/usecase/inituser_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:rxdart/rxdart.dart';

import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';
import 'dart:ffi';

class SplashViewModel extends BaseViewModel
    with SplashViewModelInput, SplashViewModelOutput {
  InitUserUseCase _initUserUseCase;
  SplashViewModel(this._initUserUseCase);
  final dataStreamController = BehaviorSubject<InitModel>();

  @override
  void start() {
    // initUser();
  }

  @override
  void dispose() {
    dataStreamController.close();
    super.dispose();
  }

  @override
  initUser() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));

    (await _initUserUseCase.execute(Void)).fold((failure) {
      {
        inputState.add(ErrorState(
            StateRendererType.FULL_SCREEN_ERROR_STATE, failure.message));
      }
    }, (initData) {
      inputState.add(ContentState());
      inputHomeData.add(initData);
    });
  }

  @override
  Sink get inputHomeData => dataStreamController.sink;

  @override
  Stream<InitModel> get outputHomeData =>
      dataStreamController.stream.map((data) => data);

  @override
  // TODO: implement outPutSubscribeStatus
  Stream<String> get outPutSubscribeStatus => throw UnimplementedError();
}

abstract class SplashViewModelInput {
  Sink get inputHomeData;

  initUser();
}

abstract class SplashViewModelOutput {
  //Response Data
  Stream<InitModel> get outputHomeData;

  Stream<String> get outPutSubscribeStatus;
}
