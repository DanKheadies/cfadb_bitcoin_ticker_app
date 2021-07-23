import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  int btcRate;
  int ethRate;
  int ltcRate;

  @override
  void initState() {
    super.initState();
    getCoinData(selectedCurrency);
  }

  Future<void> getCoinData(String currency) async {
    setState(() {
      btcRate = null;
      ethRate = null;
      ltcRate = null;
    });

    var btcData = await CoinData().getCoinData('BTC', currency);
    var ethData = await CoinData().getCoinData('ETH', currency);
    var ltcData = await CoinData().getCoinData('LTC', currency);

    double _btcRate = double.parse(btcData['rate'].toString());
    double _ethRate = double.parse(ethData['rate'].toString());
    double _ltcRate = double.parse(ltcData['rate'].toString());

    setState(() {
      btcRate = _btcRate.toInt();
      ethRate = _ethRate.toInt();
      ltcRate = _ltcRate.toInt();
    });
  }

  DropdownButton<String> getDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    // for (int i = 0; i < currenciesList.length; i++) {
    for (String currency in currenciesList) {
      // String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        getCoinData(value);
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> cupItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(
        currency,
        style: TextStyle(
          fontSize: 25,
        ),
      );
      cupItems.add(newItem);
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        getCoinData(currenciesList[selectedIndex]);
      },
      children: cupItems,
    );
  }

  Widget coinTracker(String coinType, int coinRate) {
    var _coinRate = coinRate == null ? '?' : coinRate;
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coinType = $_coinRate $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // getCoinData();
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              coinTracker(
                cryptoList[0],
                btcRate,
              ),
              coinTracker(
                cryptoList[1],
                ethRate,
              ),
              coinTracker(
                cryptoList[2],
                ltcRate,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? getDropdownButton() : iOSPicker(),
          ),
        ],
      ),
    );
  }
}
