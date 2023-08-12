import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
import 'package:xml/xml.dart';

import '../databases/databases.dart';

class WebScraper {
  int keyStore;
  int keySchema;
  String? _storeDomain;
  String? _storeToken;
  String? _storeCurrency;
  String? _priceSelectorA;
  String? _priceSelectorB;
  String? _discountSelector;
  String? _currency;
  num? _percentage;
  bool? _priceBeforeDiscount;

  WebScraper({required this.keyStore, required this.keySchema}) {
    _loadData();
  }

  void _loadData() async {
    dynamic box = await Hive.openBox<DBStores>("DBStores");
    box.values.forEach((element) {
      if (element.key == keyStore) {
        _storeDomain = element.storeDomain;
        _storeToken = element.storeToken;
        _storeCurrency = element.storeCurrency;
      }
    });
    await box.close();

    box = await Hive.openBox<DBSchemas>("DBSchemas");
    box.values.forEach((element) {
      if (element.key == keySchema) {
        _priceSelectorA = element.priceSelectorA;
        _priceSelectorB = element.priceSelectorB;
        _discountSelector = element.discountSelector;
        _currency = element.currency;
        _percentage = element.percentage;
        _priceBeforeDiscount = element.priceBeforeDiscount;
      }
    });
    await box.close();

    box = await Hive.openBox<DBProducts>("DBProducts");
    box.values.forEach((element) {
      if (element.key == keySchema) {
        _getSoup(element.url, element.id);
      }
    });
    await box.close();
  }

  void _getSoup(String url, int id) async {
    var response = await http.get(Uri.parse(url));
    var soup = html.parse(response.body);
    _calculations(id, int.parse(_findPrice(soup)!));
  }

  String? _findPrice(soup) {
    String? price;
    RegExp regex = RegExp(r'\d+');
    var priceSelectorA = soup.querySelector(_priceSelectorA);
    if (priceSelectorA != null) {
      regex
          .allMatches(priceSelectorA.text.trim().replaceAll(",", ""))
          .forEach((match) {
        price = match.group(0);
      });
    } else if (_priceSelectorB != null) {
      var priceSelectorB = soup.querySelector(_priceSelectorB);
      if (priceSelectorB != null) {
        if (_priceBeforeDiscount == false) {
          regex
              .allMatches(priceSelectorB.text.trim().replaceAll(",", ""))
              .forEach((match) {
            price = match.group(0);
          });
        } else {
          regex
              .allMatches(soup
                  .querySelector(_discountSelector)
                  .text
                  .trim()
                  .replaceAll(",", ""))
              .forEach((match) {
            price = match.group(0);
          });
        }
      }
    }
    return price;
  }

  void _calculations(int id, price) {
    if (_percentage != null) {
      price = price + (price * _percentage!);
    }
    price = price.toString();
    if (_storeCurrency == _currency) {
      _update(id, price);
    } else if (_storeCurrency == "Rial" && _currency == "Toman") {
      price = price + "0";
      _update(id, price);
    } else if (_storeCurrency == "Toman" && _currency == "Rial") {
      price = price.substring(0, price.length - 1);
      _update(id, price);
    }
  }

  void _update(int id, String price) async {
    final url =
        Uri.parse("https://$_storeDomain/api/products/$id?ws_key=$_storeToken");

    final response = await http.get(url);

    final document = XmlDocument.parse(response.body);

    final product = document.rootElement.findElements("product").first;

    product.findElements("manufacturer_name").first.remove();
    product.findElements("quantity").first.remove();
    product.findElements("price").first.innerText = price;

    final body = document.toXmlString();

    http.put(url, body: body).then((result) {
      print(result.statusCode);
    });
  }
}
