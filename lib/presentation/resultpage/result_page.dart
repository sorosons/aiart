import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:complete_advanced_flutter/app/logger_settings.dart';
import 'package:complete_advanced_flutter/presentation/resultpage/result_page_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resultpage/result_singelton.dart';
import 'package:flutter/gestures.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_editor_plus/image_editor_plus.dart';

import 'package:scroll_page_view/pager/page_controller.dart';
import 'package:scroll_page_view/pager/scroll_page_view.dart';

import '../../app/di.dart';
import '../../domain/model/image_model.dart';
import '../resources/color_manager.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  ResultViewModel _resultViewModel = instance<ResultViewModel>();

  late ImageModel _images;
  int indexOf = 0;
  var singleton = SingletonImageList();
  @override
  void initState() {
    logger.wtf("wtf");

    _images = singleton.imageItems;
    //precache(_images);
    logger.wtf(singleton.imageItems.images.first.src);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (settings) {},
      title: 'Scroll Page View Demo',
      home: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              ///Indicator
              SliverPadding(
                padding: EdgeInsets.all(40),
                sliver: SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 3 / 5,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        child: ScrollPageView(
                          controller: ScrollPageController(),
                          delay: const Duration(seconds: 400),
                          indicatorAlign: Alignment.bottomRight,
                          indicatorPadding:
                              const EdgeInsets.only(bottom: 8, right: 16),
                          indicatorWidgetBuilder: (context, index, length) {
                            indexOf = index;
                            return _indicatorBuilder(context, index, length);
                          },
                          children: _images.images
                              .map((image) => _imageView(image.src))
                              .toList(),
                          pageSnapping: true,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.cancel_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        left: 0,
                        bottom: 10,
                        child: IconButton(
                          onPressed: () {
                            logger.i(indexOf);
                            _resultViewModel
                                .downloadImage(_images.images[indexOf].src);
                            Flushbar(
                              title: "Successful",
                              message: "Image Saved to Gallery",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          },
                          icon: Icon(
                            Icons.download_sharp,
                            size: 50,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                // fillOverscroll: true, // Set true to change overscroll behavior. Purely preference.
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 50.0, left: 23, right: 23),
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.createBtnColor,
                            shape: StadiumBorder()),
                        child: Text('Edit'),
                        onPressed: () async {
                          //Get the image from the URL and then convert it to Uint8List
                          print("Edit");
                          final ByteData imageData = await NetworkAssetBundle(
                                  Uri.parse(_images.images[indexOf].src))
                              .load("");
                          final Uint8List bytes =
                              imageData.buffer.asUint8List();

                          print("bytes" + bytes.toString());

                          Directory tempDir = await getTemporaryDirectory();
                          String tempPath = tempDir.path;

                          print("Temppath:$tempPath");
                          Directory appDocDir =
                              await getApplicationDocumentsDirectory();
                          String appDocPath = appDocDir.path;
                          print("appDocPath:$appDocPath");
                          final editedImage = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageEditor(
                                image: bytes, // <-- Uint8List of image
                                savePath: appDocDir,
                              ),
                            ),
                          );
                          final result = await ImageGallerySaver.saveImage(
                              Uint8List.fromList(editedImage),
                              quality: 60,
                              name: "hello");

                          if (result["isSuccess"] == true) {
                            Flushbar(
                              title: "Successful",
                              message: "Image Saved to Gallery",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          }
                          logger.i("result:" + result.toString());
                          print("editedt image:" + editedImage.toString());
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Image
  Widget _imageView(String image) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Image.network(image, fit: BoxFit.cover,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        return child;
      }, loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      }),
    );
  }

  ///[IndicatorWidgetBuilder]
  Widget? _indicatorBuilder(BuildContext context, int index, int length) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: const BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(48),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: RichText(
        text: TextSpan(
          text: '${index + 1}',
          style: const TextStyle(
              fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
          children: [
            const TextSpan(
              text: '/',
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
            TextSpan(
              text: '$length',
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> precache(ImageModel images) async {
    for (var image in images.images) {
      precacheImage(NetworkImage(image.src), context);
    }
  }
}
