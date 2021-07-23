import 'dart:convert';

import 'package:http/http.dart' as http;

import './apis.dart';

const List<String> currenciesList = [
  'USD',
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinData(
    String typeOfCoin,
    String selectedCurrency,
  ) async {
    String url = 'rest.coinapi.io';
    String path = '/v1/exchangerate/' + typeOfCoin + '/';
    String apiKey = coinAPI2;

    Uri uri = Uri.https(url, path + selectedCurrency, {
      'apikey': '$apiKey',
    });

    http.Response response = await http.get(uri);

    if (response.statusCode == 200) {
      String data = response.body;
      return jsonDecode(data);
    } else {
      print(response.statusCode);
      return {'rate': '0'};
    }
  }
}
