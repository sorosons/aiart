import 'package:auto_size_text/auto_size_text.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/main/main_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:complete_advanced_flutter/presentation/resultpage/result_page.dart';
import 'package:complete_advanced_flutter/presentation/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';

import '../../app/di.dart';
import '../../app/helpers/revenue_cat.dart';
import '../../app/logger_settings.dart';
import '../../domain/model/model.dart';
import '../resources/routes_manager.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  var _promptController = TextEditingController();

  MainViewModel _mainViewModel = instance<MainViewModel>();

  @override
  void initState() {
    _mainViewModel.start();
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _mainViewModel.dispose();
    super.dispose();
  }

  _bind() async {
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
        child: Scaffold(
          body: StreamBuilder<FlowState>(
              stream: _mainViewModel.outputState,
              builder: (context, snapshot) {
                return snapshot.data
                        ?.getScreenWidget(context, _getContentWidget(), () {
                      print("Hello Man");
                      Navigator.pop(context);
                    }) ??
                    _getContentWidget();
              }),
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              _appBar(context),
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 15),
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
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10),
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
                              size: 30,
                              color: Colors.black,
                            ),
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1.0)),
                                borderSide: BorderSide(color: Colors.blue)),
                            filled: true,
                            contentPadding: EdgeInsets.only(
                                bottom: 10.0, left: 10.0, right: 10.0),
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
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Container(
                  height: 30,
                  child: _myListView(context),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
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
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0, left: 15.0),
                child: Container(
                  height: 300,
                  child: _myGridStyles(context),
                ),
              ),
            ],
          ),
          _createArtButton(context)
        ],
      ),
    );
  }

  Widget _myListView(BuildContext context) {
    // backing data

    List<MyPrompts> _items = [
      MyPrompts("Pink Cat", ImageAssets.styleIcon1),
      MyPrompts("Foggy Forest", ImageAssets.styleIcon2),
      MyPrompts("Life Under Ground", ImageAssets.styleIcon3),
      MyPrompts("Mythological", ImageAssets.styleIcon1),
      MyPrompts("Fliyng Fish On Water", ImageAssets.styleIcon2),
      MyPrompts("on-gravity environment", ImageAssets.styleIcon3),
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return StreamBuilder<String>(
            stream: _mainViewModel.promptTextStream,
            builder: (context, snapshot) {
              return Container(
                  height: 100,
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
                            height: 15,
                            width: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 5),
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
          width: 20,
        );
      },
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
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 10.0,
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
                    print("Hello Eşit");
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
    );
  }

  Widget _createArtButton(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 20.0, left: 23, right: 23),
        child: Container(
          height: 50,
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
                            logger.i("Creat Art" + premium.toString());
                            if (premium) {
                              _mainViewModel.createArt();
                            } else {
                              Navigator.pushNamed(context, Routes.premiumPage);
                            }
                          });
                        }
                      : null,
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
        ));
  }

  Widget _appBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Text(
            "AI ART",
            style: TextStyle(fontSize: 20, color: Colors.black),
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
                            Navigator.of(context).pushNamed(Routes.premiumPage);
                          },
                          icon: Image.asset(
                            ImageAssets.proIcon,
                          ),
                          iconSize: 60,
                        )
                      : Container(),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(Routes.settingsPage);
                    },
                    icon: Icon(
                      Icons.settings,
                    ),
                    iconSize: 30,
                    color: ColorManager.createBtnColor,
                  ),
                ],
              );
            })
      ],
    );
  }
}
