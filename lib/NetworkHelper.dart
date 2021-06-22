import 'package:http/http.dart' as http;
import 'dart:convert';
import 'coin_data.dart';


class NetworkHelper {


  Future getData(String currency) async {
    Map<String, String> cryptoPrices = {};

    for(String crypto in  cryptoList) {
      String url = '$coinAPIURL/$crypto/$currency/$apiKey';
      http.Response response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        //Create a new key value pair, with the key being the crypto symbol and the value being the lastPrice of that crypto currency.
        cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }

    }

    return cryptoPrices;

  }


}

