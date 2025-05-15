import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ilearn_papiamento/config/config.dart';
import 'package:ilearn_papiamento/models/data_model.dart';
import 'package:ilearn_papiamento/models/premium_features_model.dart';

class ApiServices {
  Dio dio = Dio();

  ApiServices()
    : dio = Dio(
        BaseOptions(
          validateStatus: (status) => true,
          baseUrl: AppConfig.baseUrl,
          headers: {
            "Authorization":
                "Basic ${base64Encode(utf8.encode('${AppConfig.adminUserName}:${AppConfig.adminPassword}'))}",
          },
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

  Future<CategoriesDataModel> fetchData() async {
    try {
      var response = await dio.get(AppConfig.baseUrl);

      // Check if response and success field are valid
      if (response.data == null || response.data['success'] == null) {
        throw 'Invalid response: Missing success field';
      }

      // Handle success == true
      if (response.data['success'] == true) {
        // print(response.data);
        return CategoriesDataModel.fromJson(response.data);
      }

      // Handle success == false
      if (response.data['success'] == false) {
        throw 'Response success is false';
      }

      // Handle unexpected success value
      throw 'Unexpected response: success field is neither true nor false';
    } catch (e) {
      // print('Error fetching data: $e');
      rethrow; // Rethrow to let the caller handle the error
    }
  }

  // Fetch Premium Seices
  Future<PremiumFeaturesModel> fetchPremiumFeatures() async {
    try {
      var response = await dio.get(AppConfig.premiumfeaturesbaseUrl);

      // Check if response and success field are valid
      if (response.data == null || response.data['success'] == null) {
        throw 'Invalid response: Missing success field';
      }

      // Handle success == true
      if (response.data['success'] == true) {
        print(response.data);
        return PremiumFeaturesModel.fromJson(response.data);
      }

      // Handle success == false
      if (response.data['success'] == false) {
        throw 'Response success is false';
      }

      // Handle unexpected success value
      throw 'Unexpected response: success field is neither true nor false';
    } catch (e) {
      print('Error fetching data: $e');
      rethrow; // Rethrow to let the caller handle the error
    }
  }
}
