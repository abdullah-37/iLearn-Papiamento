import 'package:flutter/widgets.dart';
import 'package:ilearn_papiamento/Services/api_services.dart';
import 'package:ilearn_papiamento/models/data_model.dart';

class FetchDataProvider extends ChangeNotifier {
  ApiServices apiServices = ApiServices();
  CategoriesDataModel? categoriesData;
  bool isLoading = false;
  FetchDataProvider() {
    fetchCategories();
  }

  fetchCategories() async {
    isLoading = true;
    notifyListeners();
    try {
      var res = await apiServices.fetchData();
      if (res.success == true) {
        // print(res);
        categoriesData = res;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      // print('sssssssssssssssssssssssssssss$e');
    } finally {
      // isLoading = false;
      // notifyListeners();
    }
  }
}
