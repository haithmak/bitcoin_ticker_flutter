import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dart:io' show Platform;

import 'NetworkHelper.dart';
import 'coin_data.dart';
import 'package:http/http.dart' as http;
import 'crypto_card.dart';
class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'USD' ;


  Map<String, String> coinValues = {};
  bool isWaiting = false;


  String rateTextBTC = '1 BTC = ? USD';

  String bitcoinValue = '?';

  void getRateData(String currency) async{
    isWaiting = true;

    try{

        NetworkHelper networkHelper = NetworkHelper() ;
        var dataRate = await networkHelper.getData(currency) ;
        isWaiting = false;
        setState(() {
          coinValues = dataRate;
        });


        print(dataRate) ;


    } catch (e) {
      print(e);
    }
  }
  
  
  
  
  DropdownButton androidDropdownButton() {

    List<DropdownMenuItem<String>> dropdownMenuItem = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownMenuItem.add(newItem) ;
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownMenuItem,
      onChanged: (value){
        setState(() {
          selectedCurrency = value!;
          getRateData(selectedCurrency);
        });
      },
    ) ;

  }


  CupertinoPicker iosPicker(){


    List<Text> pickerItems =[] ;
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency)) ;
    }


    return CupertinoPicker(children:pickerItems ,backgroundColor: Colors.lightBlue,itemExtent: 32 , scrollController: FixedExtentScrollController(initialItem: 19),onSelectedItemChanged: (value){
      setState(() {
        selectedCurrency = pickerItems[value].data.toString() ;
        print(selectedCurrency);
       getRateData(selectedCurrency);
      });


    },) ;

  }

  @override
  void initState() {
    super.initState();
    getRateData(selectedCurrency);
  }
  @override
  Widget build(BuildContext context) {
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
              CryptoCard(
                cryptoCurrency: 'BTC',
                //7. Finally, we use a ternary operator to check if we are waiting and if so, we'll display a '?' otherwise we'll show the actual price data.
                value: isWaiting ? '?' : coinValues['BTC'],
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'ETH',
                value: isWaiting ? '?' : coinValues['ETH'],
                selectedCurrency: selectedCurrency,
              ),
              CryptoCard(
                cryptoCurrency: 'LTC',
                value: isWaiting ? '?' : coinValues['LTC'],
                selectedCurrency: selectedCurrency,
              ),
            ],
          ),

          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? iosPicker() :  androidDropdownButton()    ,
          ),
        ],
      ),
    );
  }
}
