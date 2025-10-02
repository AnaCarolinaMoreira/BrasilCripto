import 'dart:convert';
import 'package:brasil_cripto/utils/models/cryptocoin.dart';
import 'package:http/http.dart' as http;

class CoinService {
  final String apiKey = "CG-qsVrEK31Adef4m8fcC8mriq";
  final String api = 'https://api.coingecko.com/api/v3/';

 Future<List<CryptoCoin>> fetchCoins(String searchQuery) async {
   final response = await http.get(
     Uri.parse('https://api.coingecko.com/api/v3/search_coins?x_cg_demo_api_key=${apiKey}9&query=$searchQuery'),
   );
   if (response.statusCode == 200) {

     List<dynamic> coinJson = jsonDecode(response.body)['coins'];

      return coinJson.map((json) => CryptoCoin.fromMap(json)).toList();
   }
   else {
     throw Exception('Falha ao carregar criptomoedas');
   }
  }
}