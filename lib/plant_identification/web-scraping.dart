import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart';

class WebScraping {
  Future<String> getHTMLDoc(String query) async {
    final url = 'https://www.google.com/search?q=$query&source=lnms&tbm=isch';
    final headers = {
      'Accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'User-Agent':
      "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/43.0.2357.134 Safari/537.36"
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      print("Error fetching HTML: $e");
    }
    return '';
  }

  Future<String> getImageFromWeb(String query) async {
    final html = await getHTMLDoc(query);
    if (html.isNotEmpty) {
      final bs = BeautifulSoup(html);
      final imgTag = bs.find('img', class_: 'yWs4tf');
      if (imgTag != null) {
        return imgTag['src']!;
      }
    }
    return '';
  }
}