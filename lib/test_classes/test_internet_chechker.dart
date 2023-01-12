import 'package:complete_advanced_flutter/domain/model/image_model.dart';
import 'package:complete_advanced_flutter/presentation/resultpage/result_singelton.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

main() async {
  var xx = Peoples();
  xx.name = "AA";
  xx.id = 1;

  print(xx.name);
}
