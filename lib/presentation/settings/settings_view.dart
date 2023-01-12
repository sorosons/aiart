import 'package:auto_size_text/auto_size_text.dart';
import 'package:complete_advanced_flutter/app/di.dart';
import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/presentation/resources/color_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/routes_manager.dart';
import 'package:complete_advanced_flutter/presentation/settings/settings_viewmodel.dart';
import 'package:flutter/material.dart';

import '../resources/assets_manager.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  SettingsViewModel _settingsViewModel = instance<SettingsViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace_outlined, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorManager.grad1,
                    ColorManager.grad2,
                    ColorManager.grad3,
                    ColorManager.grad4,
                    ColorManager.grad5,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, left: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Air Art",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                          _premiumFeatures("Fast Processing"),
                          SizedBox(height: 5),
                          _premiumFeatures("Remove Ads"),
                          SizedBox(height: 5),
                          _premiumFeatures("Unlimited artwork Creation"),
                          SizedBox(height: 10),
                          _tryProNow(context),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _stackedImage(),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorManager.primary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: _listTile(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _listTile() {
    List<SettingsListTile> _listItems = [
      SettingsListTile(
          ImageAssets.listTileIcon, Colors.red, "Share Me", Icons.star_rate),
      SettingsListTile(ImageAssets.listTileIcon, Colors.green, "Like Rate Us",
          Icons.settings),
      SettingsListTile(ImageAssets.listTileIcon, Colors.orange, "Term Of Us",
          Icons.info_outline),
      SettingsListTile(ImageAssets.listTileIcon, Colors.blue, "Privacy Policy",
          Icons.work_outlined),
      SettingsListTile(
          ImageAssets.listTileIcon, Colors.blue, "E-Mail Support", Icons.email),
    ];

    return ListView.separated(
      itemCount: _listItems.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            print(_listItems[index].tittle);

            switch (index) {
              case 0:
                {
                  _settingsViewModel.shareAiArt();
                }
                break;
              case 1:
                {
                  _settingsViewModel.likeRateUs();
                }
                break;
              case 2:
                {
                  _settingsViewModel.termOfUs();
                }
                break;
              case 3:
                {
                  _settingsViewModel.privacyPolicy();
                }
                break;
              case 4:
                {
                  _settingsViewModel.sendEmail();
                }
                break;
            }
          },
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            _listItems[index].imageAssets,
            color: _listItems[index].color,
          ),
          title: Text(_listItems[index].tittle),
          trailing: Icon(_listItems[index].iconData),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: ColorManager.borderColor, // Custom style
        );
      },
    );
  }

  Widget _stackedImage() {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.topStart, // <-- SEE HERE

          child: Image.asset(
            ImageAssets.magic,
            height: 125,
            width: 125,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Image.asset(
            ImageAssets.novelistic,
            height: 150,
            width: 150,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset(
              ImageAssets.penInk,
              height: 100,
              width: 100,
            ),
          ),
        )
      ],
    );
  }

  Widget _tryProNow(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.createBtnColor,
          shape: StadiumBorder(),
        ),
        onPressed: () {
          Navigator.pushNamed(context, Routes.premiumPage);
        },
        child: AutoSizeText("Try Pro Now",
            maxLines: 1,
            minFontSize: 10,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _premiumFeatures(String feature) {
    return Row(
      children: [
        Icon(
          Icons.check_rounded,
          color: Colors.white,
        ),
        Expanded(
          child: AutoSizeText(
            feature,
            maxLines: 2,
            minFontSize: 10,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
