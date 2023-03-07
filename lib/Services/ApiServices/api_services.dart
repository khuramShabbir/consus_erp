import 'dart:convert';

import 'package:http/http.dart' as http;

import '/utils/info_controller.dart';
import 'api_urls.dart';

class ApiServices {
  static Future<String> getMethodApi(String feedUrl) async {
    http.Request request = await http.Request('GET', Uri.parse(ApiUrls.BASE_URL + feedUrl));

    http.StreamedResponse response = await request.send();
    String res = await response.stream.bytesToString();
    logger.i(response.contentLength);

    if (response.statusCode == 200 || response.statusCode == 201) {

      return res;
    } else {
      logger.e(res);
      Info.error("Something Went Wrong, try again later");
      return "";
    }
  }

  static Future<String> postRawMethodApi(Map<String, String> body, String feedUrl) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(ApiUrls.BASE_URL + feedUrl));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    logger.i(response.contentLength);
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      return "";
    }
  }

  static Future<String> postRawMethodApiForLocal(List<dynamic> body, String feedUrl) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse(ApiUrls.BASE_URL + feedUrl));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    logger.i(response.statusCode);
    if (response.statusCode == 200) {
      String res = await response.stream.bytesToString();
      logger.i(res);
      return res;
    } else {
      return "";
    }
  }

  static Future<String> postSyncMethodApi(Map<String, dynamic> body, String feedUrl) async {
    String res = "";
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('POST', Uri.parse(ApiUrls.BASE_URL + feedUrl));
      request.body = json.encode(body);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      logger.i(response.statusCode);
      if (response.statusCode == 200) {
        res = await response.stream.bytesToString();
      } else {
        res = "";
      }
    } catch (e) {
      Info.stopProgress();
      print(e);
    }
    return res;
  }

  static Future<String> deleteMethodApi(String feedUrl) async {
    String res = "";
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('DELETE', Uri.parse(ApiUrls.BASE_URL + feedUrl));
      //request.body = json.encode(id);
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      logger.i(response.statusCode);
      if (response.statusCode == 200) {
        res = await response.stream.bytesToString();
      } else {
        res = "";
      }
    } catch (e) {
      Info.stopProgress();
      print(e);
    }
    return res;
  }

  static Future<String> deleteAlbum(String id) async {
    final http.Response response = await http.delete(
      Uri.parse("https://kbi.consuserp.com/webapi/api/Visits/DeleteVisits?pVisitID=$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete visit.');
    }
  }

  // static Future<String> postMethodApi(
  //     {Map<String, String>? fields, String? files, required String feedUrl}) async {
  //   Map<String, String> headers = {'Content-Type': 'application/json'};
  //   AppConst.startProgress();
  //   http.MultipartRequest request =
  //       http.MultipartRequest('POST', Uri.parse(ApiUrls.BASE_URL + feedUrl));
  //   if (fields != null) request.fields.addAll(fields);
  //   if (files != null) request.files.add(await http.MultipartFile.fromPath('ImageURL', files));
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   AppConst.stopProgress();
  //
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     String result = await response.stream.bytesToString();
  //     logger.i(result);
  //     return result;
  //   } else {
  //     String result = await response.stream.bytesToString();
  //     dynamic parsed = jsonDecode(result);
  //     await AppConst.errorSnackBar("${response.statusCode} ${parsed["message"]}");
  //
  //     logger.e(parsed);
  //
  //     return "";
  //   }
  // }
}
