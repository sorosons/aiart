import 'package:auto_size_text/auto_size_text.dart';
import 'package:complete_advanced_flutter/presentation/common/state_renderer/state_render_impl.dart';
import 'package:complete_advanced_flutter/presentation/premium/premium_viewmodel.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/constant.dart';
import '../../app/di.dart';
import '../../app/helpers/revenue_cat.dart';
import '../../app/logger_settings.dart';
import '../../domain/model/model.dart';
import '../common/state_renderer/state_renderer.dart';
import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';

class PremiumView extends StatefulWidget {
  const PremiumView({Key? key}) : super(key: key);

  @override
  _PremiumViewState createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  SubscriptionViewModel _subscriptionViewModel =
      instance<SubscriptionViewModel>();
  RevenueCatHelper _revenueCatHelper = instance<RevenueCatHelper>();

  bool _purchasePending = false;
  Offerings? offerings;

  @override
  void initState() {
    //initPlatformState();
    _subscriptionViewModel.start();
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionViewModel.dispose();
    super.dispose();
  }

  _bind() async {
    await _revenueCatHelper.initRevenueCat();
    offerings = await _revenueCatHelper.getOfferings();
    _revenueCatHelper.getOfferings().then((value) {
      logger.w(value?.all.toString());
      setState(() {
        offerings = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stack = [];
    if (offerings != null) {
      stack.add(
        inappColumn(),
      );
    } else {
      stack.add(Center(
        child: CircularProgressIndicator(
          color: Colors.yellow,
        ),
      ));
    }

    if (_purchasePending) {
      stack.add(
        Stack(
          children: [
            Opacity(
              opacity: 0.3,
              child: const ModalBarrier(dismissible: true, color: Colors.grey),
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        body: StreamBuilder<FlowState>(
            stream: _subscriptionViewModel.outputState,
            builder: (context, snapshot) {
              return snapshot.data
                      ?.getScreenWidget(context, Stack(children: stack), () {
                    logger.w("I m info" +
                        snapshot.data!.getStateRendererType().toString());
                    if (snapshot.data?.getStateRendererType() ==
                        StateRendererType.CONTENT_SCREEN_STATE) {
                      logger.wtf("WTF::: OK");
                      _subscriptionViewModel.clickOkBtn();
                    } else if (snapshot.data?.getStateRendererType() ==
                        StateRendererType.POPUP_ERROR_STATE) {
                      Navigator.of(context).pop();
                    } else if (snapshot.data?.getStateRendererType() ==
                        StateRendererType.POPUP_SUCCESS) {
                      logger.w("I m info");
                      Phoenix.rebirth(context);
                    } else {
                      Phoenix.rebirth(context);
                      //  Navigator.pushReplacementNamed(context, Routes.mainPage);

                    }
                  }) ??
                  Container();
            }));
  }

  Widget inappColumn() {
    var myProductList = offerings!.current!.availablePackages;
    logger.i("myProductList:" + myProductList.length.toString());

    if (offerings == null) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.red,
      ));
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: new AssetImage(ImageAssets.premiumTop),
                    fit: BoxFit.fill,
                  ),
                ),
                foregroundDecoration: new BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white60,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    )),
              ),
              //restoreSub(),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: ColorManager.primary,
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: _featureOfPremium(),
            ),
          ),
        ),
        _packages(myProductList),
        bottomExplainPrice(myProductList)
      ],
    );
  }

  Align restoreSub() {
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () {
          logger.i("logger");
          _revenueCatHelper.restoreSubscription().then((purchaseInfo) async {
            if (purchaseInfo.activeSubscriptions.length > 0) {
              logger.i(purchaseInfo.activeSubscriptions.last);
              logger.i(purchaseInfo.latestExpirationDate);
              _subscriptionViewModel.showAlert("Succces");
            } else {
              _subscriptionViewModel.subScribeFail();
            }
          });
        },
        icon: Image.asset(
          ImageAssets.restore,
        ),
        iconSize: 80,
      ),
    );
  }

  Widget _featureOfPremium() {
    List<SettingsListTile> _listItems = [
      SettingsListTile(
          ImageAssets.checkPurple, Colors.red, "Fast Precessing", null),
      SettingsListTile(ImageAssets.checkGold, Colors.green,
          "UnLimited ArtWork Creation", null),
      SettingsListTile(
          ImageAssets.checkGreen, Colors.orange, "Get Multiple Result", null),
      SettingsListTile(ImageAssets.checkPink, Colors.blue, "Remove Ads", null),
    ];

    return ListView.separated(
      itemCount: _listItems.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            print(_listItems[index].tittle);
          },
          contentPadding: EdgeInsets.zero,
          leading: Image.asset(
            _listItems[index].imageAssets,
            color: _listItems[index].color,
          ),
          title: Text(_listItems[index].tittle),
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

  //first ite cyan,"Basic Package"
  Widget SubItems(
      Package myProductList, String productIdentify, String packageType) {
    return InkWell(
      onTap: () async {
        _subscriptionViewModel.clickOkBtn();
        showPendingUI();
        try {
          CustomerInfo purchaserInfo =
              await Purchases.purchasePackage(myProductList);
          // myProductList.firstWhere(
          //       (element) => element.product.identifier == productIdentify),
          appData.entitlementIsActive =
              purchaserInfo.entitlements.all[Constant.entitlementID]!.isActive;

          if (appData.entitlementIsActive == true) {
            logger.i(
                "SucccesXX:" + purchaserInfo.latestExpirationDate.toString());
            purchaserInfo.entitlements.active.forEach((key, value) {
              logger.i("Succces:" + value.expirationDate.toString());
            });

            _subscriptionViewModel.showAlert("Succes");

            // await _subscriptionViewModel.setSubScribe(
            //     productIdentify.toIdentifityToApi(),
            //     purchaserInfo.latestExpirationDate.toString());
          } else {
            _subscriptionViewModel.subScribeFail();
          }

          // setState(() {});
        } catch (e) {
          logger.i("catch:" + e.toString());
          _subscriptionViewModel.subScribeFail();

          setState(() {});
          _purchasePending = false;
        }

        setState(() {
          _purchasePending = false;
        });
      },
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black54, width: 2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Center(
                child: AutoSizeText(
                  myProductList.storeProduct.priceString + " / " + packageType,
                  maxLines: 1,
                  minFontSize: 10,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Container(
              child: Center(
                child: AutoSizeText(
                  "3 Days Free",
                  maxLines: 1,
                  minFontSize: 8,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded bottomExplainPrice(List<Package> list) {
    return Expanded(
      flex: 1,
      child: new ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: AutoSizeText(
              'Subscription Pricing and Terms:',
              style: TextStyle(
                fontSize: 5,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
              maxLines: 2,
            ),
          ),
          AutoSizeText(
            ' Subscription periods are  1 month and 6 months. Every  1 month and 6 months your subscription renews. ',
            style: TextStyle(fontSize: 3, color: Colors.black54),
            maxLines: 2,
          ),
          AutoSizeText(
            ' - Monthly   subscription price is ' +
                list
                    .firstWhere((element) =>
                        element.storeProduct.identifier == "s_monthly")
                    .storeProduct
                    .priceString +
                ',  6 Month subscription price is' +
                list
                    .firstWhere((element) =>
                        element.storeProduct.identifier == "s_yearly")
                    .storeProduct
                    .priceString,
            style: TextStyle(fontSize: 3, color: Colors.black54),
            maxLines: 2,
          ),
          AutoSizeText(
            ' - Payments will be charged to your iTunes Account Account at the confirmation of purchase',
            style: TextStyle(fontSize: 3, color: Colors.black54),
            maxLines: 2,
          ),
          AutoSizeText(
            ' - Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period ',
            style: TextStyle(fontSize: 3, color: Colors.black54),
            maxLines: 2,
          ),
          AutoSizeText(
            ' - You can manage your subscription and/or turn off auto-renewal by visiting your iTunes Account Settings after purchase ',
            style: TextStyle(fontSize: 3, color: Colors.black54),
            maxLines: 2,
          ),
          AutoSizeText(
            '  - Any unused portion of a free trial period, if offered, will be forfeited when the user purchases a subscription to that publication, where applicable. ',
            style: TextStyle(fontSize: 3, color: Colors.black54),
            maxLines: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "-Privacy Polciy",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Colors.blueAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        var url = Constant.privacyUrl;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "-Terms and conditions",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Colors.blueAccent),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        var url = Constant.termOfUsUrl;
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Widget _packages(List<Package> myProductList) {
    return Expanded(
      //flex: 2,
      flex: 1,
      child: Column(
        children: <Widget>[
         /* Expanded(
            child: SubItems(myProductList[1],
                myProductList[1].storeProduct.identifier, "6 Monht"),
          ),
*/
           for (int i = 0; i < myProductList.length; i++)
            Expanded(
              child: SubItems(
                  myProductList[i],
                  myProductList[i].storeProduct.identifier,
                  myProductList[i].storeProduct.identifier == "s_monthly"
                      ? "1 Month"
                      : "6 Monht"),
            ),
        ],
      ),
    );
  }
}
