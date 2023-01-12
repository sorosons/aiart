import 'dart:async';

import 'package:complete_advanced_flutter/app/logger_settings.dart';
import 'package:complete_advanced_flutter/domain/model/image_model.dart';
import 'package:complete_advanced_flutter/domain/usecase/create_art_usecase.dart';
import 'package:complete_advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:complete_advanced_flutter/presentation/common/freezed_data_classes.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../app/helpers/revenue_cat.dart';
import '../common/state_renderer/state_render_impl.dart';
import '../common/state_renderer/state_renderer.dart';
import '../resources/strings_manager.dart';
import '../resultpage/result_singelton.dart';

class MainViewModel extends BaseViewModel
    with MainViewModelInputs, MainViewModelOutputs {
  RevenueCatHelper _revenueCatHelper;

  var inputObject = InputObject("", "");
  var singleton = SingletonImageList();
  CreateArtUseCase _createArtUseCase;
  MainViewModel(this._createArtUseCase, this._revenueCatHelper);

  StreamController _imageListData = BehaviorSubject<ImageModel>();
  StreamController _prompTextStreamController =
      StreamController<String>.broadcast();
  StreamController _styleTextStreamController =
      StreamController<String>.broadcast();

  StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  StreamController isUserclickedCreateArtBtn =
      StreamController<String>.broadcast();

  StreamController _isUserPremiumStream = BehaviorSubject<bool>();

  @override
  void start() async {
    await _revenueCatHelper.initRevenueCat();
    _revenueCatHelper.restoreSubscription().then((value) {
      logger.i("Restore:" + value.activeSubscriptions.length.toString());
      if (value.activeSubscriptions.length > 0) {
        inputPremium.add(true);
      } else {
        inputPremium.add(false);
      }
      _isUserPremiumStream.stream.listen((event) {
        // logger.i("input Premium:" + event);
      });
    });
  }

  @override
  void dispose() {
    _prompTextStreamController.close();
    _styleTextStreamController.close();
    _isAllInputValidStreamController.close();
    isUserclickedCreateArtBtn.close();
    _isUserPremiumStream.close();
    super.dispose();
  }

  @override
  createArt() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _createArtUseCase
            .execute(inputObject.promptValue + " " + inputObject.styleValue))
        .fold((failure) {
      inputState.add(
          ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message));
    }, (success) {
      logger.i("messageSCS");

      //inputState.add(ContentState());
      inputImageData.add(success);
      isUserclickedCreateArtBtn.add("Succes");
      logger.i("messageSCS");
      singleton.imageItems = success;
    });
  }

  @override
  Stream<bool> get isStyleTextEmpty =>
      _styleTextStreamController.stream.map((style) => _isStyleNotEmpty(style));

  @override
  Stream<bool> get isTextPromptEmpty => _prompTextStreamController.stream
      .map((prompt) => _isPrompNotEmpty(prompt));
  @override
  Stream<String> get styleTextStream =>
      _styleTextStreamController.stream.map((styleText) => styleText);

  @override
  Stream<String> get promptTextStream =>
      _prompTextStreamController.stream.map((promptText) => promptText);

  @override
  Stream<bool> get isAllInputValid =>
      _isAllInputValidStreamController.stream.map((_) => _isAllInputNotEmpty());

  @override
  Sink get promptText => _prompTextStreamController.sink;

  @override
  Sink get styleText => _styleTextStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  setPrompText(String prompt) {
    promptText.add(prompt);
    inputObject = inputObject.copyWith(promptValue: prompt);
    _validate();
  }

  @override
  setStyleText(String style) {
    styleText.add(style);
    inputObject = inputObject.copyWith(styleValue: style);
    _validate();
  }

  bool _isPrompNotEmpty(String prompt) {
    return prompt.isNotEmpty;
  }

  bool _isStyleNotEmpty(String style) {
    return style.isNotEmpty;
  }

  bool _isAllInputNotEmpty() {
    print("Input Prompt:" + inputObject.promptValue);
    print("Input Style:" + inputObject.styleValue);
    return _isPrompNotEmpty(inputObject.promptValue) &&
        _isStyleNotEmpty(inputObject.styleValue);
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }

  @override
  Stream<ImageModel> get outPutImageData =>
      _imageListData.stream.map((imageData) => imageData);

  @override
  Sink get inputImageData => _imageListData.sink;

  @override
  Stream<bool> get isPremium =>
      _isUserPremiumStream.stream.map((premium) => premium);

  @override
  Sink get inputPremium => _isUserPremiumStream.sink;
}

abstract class MainViewModelInputs {
  createArt();
  setPrompText(String prompt);
  setStyleText(String style);
  Sink get promptText;
  Sink get styleText;
  Sink get inputIsAllInputValid;
  Sink get inputImageData;
  Sink get inputPremium;
}

abstract class MainViewModelOutputs {
  Stream<ImageModel> get outPutImageData;
  Stream<bool> get isTextPromptEmpty;
  Stream<bool> get isStyleTextEmpty;
  Stream<bool> get isAllInputValid;
  Stream<bool> get isPremium;
  Stream<String> get styleTextStream;
  Stream<String> get promptTextStream;
}
