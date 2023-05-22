import 'package:http/http.dart';
import 'package:manga_easy_sdk/manga_easy_sdk.dart';

class ApiDownload {
  final dio = Client();

  ApiDownload();
  Future<Response> get(String url, String path) async {
    return await dio.get(
      Uri.parse(url),
      headers: Global.header,
    );
  }
}
