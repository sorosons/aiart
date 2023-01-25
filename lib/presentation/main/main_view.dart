import 'package:auto_size_text/auto_size_text.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/main/main_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:kartal/kartal.dart';
import 'package:layout_simulator/layout_simulator.dart';

import '../../app/di.dart';
import '../../app/helpers/firebase_remote.dart';
import '../../app/helpers/revenue_cat.dart';
import '../../app/logger_settings.dart';
import '../../domain/model/model.dart';
import '../resources/routes_manager.dart';
import 'package:sizer/sizer.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var _promptController = TextEditingController();

  MainViewModel _mainViewModel = instance<MainViewModel>();
  FiBaseRemoteConfig _fiBaseRemoteConfig = instance<FiBaseRemoteConfig>();

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _mainViewModel.dispose();
    super.dispose();
  }

  _bind() async {
    _mainViewModel.start();
    _promptController.addListener(() {
      _mainViewModel.setPrompText(_promptController.text);
    });

    _mainViewModel.isUserclickedCreateArtBtn.stream.listen((event) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(Routes.resultPage);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: LayoutSimulator(
          enable: false,
          child: Scaffold(
            body: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Container(
                height: context.height,
                child: StreamBuilder<FlowState>(
                    stream: _mainViewModel.outputState,
                    builder: (context, snapshot) {
                      return snapshot.data?.getScreenWidget(
                              context, _getContentWidget(), () {
                            Navigator.pop(context);
                          }) ??
                          _getContentWidget();
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return Sizer(builder: (context, orientation, deviceType) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              children: [
                _appBar(context),
                _drawSomething(),
                _editBox(),
                _myListView(context),
                _selectStyleText(),
                _myGridStyles(context),
              ],
            ),
          ),
          _createArtButton(context),
        ],
      );
    });
  }

  Padding _selectStyleText() {
    return Padding(
      padding: EdgeInsets.only(left: 2.h),
      child: Container(
        height: 7.h,
        child: Align(
          alignment: Alignment.centerLeft,
          child: RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(text: 'Select '),
                new TextSpan(
                    text: 'Style',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _editBox() {
    return Padding(
      padding: EdgeInsets.only(left: 2.h, right: 15, top: 10),
      child: Container(
        height: 10.h,
        child: StreamBuilder<bool>(
            stream: _mainViewModel.isTextPromptEmpty,
            builder: (context, snapshot) {
              return TextFormField(
                controller: _promptController,
                autocorrect: false,
                style: TextStyle(color: Colors.black),
                decoration: new InputDecoration(
                    prefixIcon: Icon(
                      Icons.add,
                      size: 4.h,
                      color: Colors.black,
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(1.0)),
                        borderSide: BorderSide(color: Colors.blue)),
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 2.h, right: 10.0),
                    labelText: "Art",
                    hintText: "Type Something",
                    suffixIcon: snapshot.data == true
                        ? IconButton(
                            onPressed: () {
                              _promptController.clear();
                              _mainViewModel.setPrompText("");
                            },
                            icon: Icon(Icons.clear),
                          )
                        : null),
              );
            }),
      ),
    );
  }

  Padding _drawSomething() {
    return Padding(
      padding: EdgeInsets.only(top: 0, left: 2.h),
      child: Container(
        height: 5.h,
        child: Align(
          alignment: Alignment.centerLeft,
          child: new RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
              children: <TextSpan>[
                new TextSpan(
                  text: 'Draw ',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                  ),
                ),
                new TextSpan(
                    text: 'Something',
                    style: new TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    // backing data

    List<MyPrompts> _items = [
      MyPrompts("A Lighthouse Above The Sea", ImageAssets.styleIcon3),
      MyPrompts("Pink Cat", ImageAssets.styleIcon1),
      MyPrompts("Foggy Forest", ImageAssets.styleIcon2),
      MyPrompts("Life Under Ground", ImageAssets.styleIcon3),
      MyPrompts("Mythological", ImageAssets.styleIcon1),
      MyPrompts("Fliyng Fish On Water", ImageAssets.styleIcon2),
      MyPrompts("on-gravity environment", ImageAssets.styleIcon3),
    ];

    return Padding(
      padding: EdgeInsets.only(left: 2.h, right: 15.0),
      child: Container(
          height: 6.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return StreamBuilder<String>(
                  stream: _mainViewModel.promptTextStream,
                  builder: (context, snapshot) {
                    return Container(
                        decoration: BoxDecoration(
                          color: snapshot.data == _items[index].prompts
                              ? Colors.pink.shade50
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                          border: snapshot.data == _items[index].prompts
                              ? Border.all(
                                  color: Colors.pink,
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: InkWell(
                          onTap: () {
                            _mainViewModel.setPrompText(_items[index].prompts);
                            _promptController.text = _items[index].prompts;
                            if (_items[index].prompts == snapshot.data) {
                              _mainViewModel.setPrompText("");
                              _promptController.clear();
                              _promptController.text = "";
                            }
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  _items[index].logo,
                                  height: 15.h,
                                  width: 2.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 5),
                                  child: AutoSizeText(
                                    _items[index].prompts,
                                    minFontSize: 10,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ));
                  });
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 1.h,
              );
            },
          )),
    );
  }

  Widget _myGridStyles(BuildContext context) {
    List<GridListItems> _items = [
      GridListItems("No Style", ImageAssets.noStyle),
      GridListItems("Cinematic", ImageAssets.cinematic),
      GridListItems("Magic", ImageAssets.magic),
      GridListItems("PenInk", ImageAssets.penInk),
      GridListItems("Mythological", ImageAssets.mythological),
      GridListItems("Novelistic", ImageAssets.novelistic),
      GridListItems("Photo", ImageAssets.photo),
    ];

    return Padding(
      padding: EdgeInsets.only(right: 15.0, left: 2.h),
      child: Container(
        height: 30.h,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0.1.h,
            crossAxisSpacing: 0.1.h,
          ),
          itemCount: _items.length,
          itemBuilder: (context, index) {
            return StreamBuilder<String>(
                stream: _mainViewModel.styleTextStream,
                builder: (context, snapshot) {
                  return InkWell(
                    onTap: () {
                      print(_items[index].title);

                      _mainViewModel.setStyleText(_items[index].title);

                      if (_items[index].title == snapshot.data) {
                        _mainViewModel.setStyleText("");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: snapshot.data == _items[index].title
                            ? Colors.pink.shade50
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                        border: snapshot.data == _items[index].title
                            ? Border.all(
                                color: Colors.pink,
                                width: 1.5,
                              )
                            : null,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Image.asset(
                              _items[index].image,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: AutoSizeText(
                                _items[index].title,
                                minFontSize: 10,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Widget _createArtButton(BuildContext context) {
    return Container(
      height: 12.h,
      child: Padding(
          padding: EdgeInsets.only(bottom: 1.h, left: 2.h, right: 2.h),
          child: Container(
            child: StreamBuilder<bool>(
                stream: _mainViewModel.isAllInputValid,
                builder: (context, snapshot) {
                  print("Snapshot:" + snapshot.data.toString());
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: snapshot.data == true
                            ? ColorManager.createBtnColor
                            : ColorManager.createBtnColor.withAlpha(50),
                        shape: StadiumBorder()),
                    onPressed: snapshot.data == true
                        ? () {
                            _mainViewModel.isPremium.listen((premium) {
                              if (premium) {
                                try {
                                  _fiBaseRemoteConfig.getValue().then((value) {
                                    logger.e("value:" + value.toString());
                                    if (value == false) {
                                      _mainViewModel.createQualityArt();
                                    } else {
                                      _mainViewModel.createArt();
                                    }
                                  });
                                } on FormatException catch (ex) {
                                  logger.e("catchccc");
                                  logger.e(ex);
                                  _mainViewModel.createQualityArt();
                                }
                              } else {
                                Navigator.pushNamed(
                                    context, Routes.premiumPage);
                              }
                            });
                          }
                        : () {
                            Navigator.pushNamed(context, Routes.premiumPage);
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText("Create",
                            minFontSize: 10, style: TextStyle(fontSize: 20)),
                        Icon(Icons.arrow_forward)
                      ],
                    ),
                  );
                }),
          )),
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
        height: 10.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 2.h),
              child: Text(
                "AI ART",
                style: TextStyle(fontSize: 3.h, color: Colors.black),
              ),
            ),
            StreamBuilder<bool>(
                stream: _mainViewModel.isPremium,
                builder: (context, snapshot) {
                  return Row(
                    children: [
                      snapshot.data == false
                          ? IconButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(Routes.premiumPage);
                              },
                              icon: Image.asset(
                                ImageAssets.proIcon,
                              ),
                              iconSize: 8.h,
                            )
                          : Container(),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(Routes.settingsPage);
                        },
                        icon: Icon(
                          Icons.settings,
                        ),
                        iconSize: 5.h,
                        color: ColorManager.createBtnColor,
                      ),
                    ],
                  );
                })
          ],
        ));
  }
}
