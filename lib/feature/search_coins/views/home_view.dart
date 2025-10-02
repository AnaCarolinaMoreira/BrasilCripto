import 'package:brasil_cripto/feature/coin_details/views/coin_details_view.dart';
import 'package:brasil_cripto/feature/favorites_coins/views/favorites_coins_view.dart';
import 'package:brasil_cripto/utils/models/cryptocoin.dart';
import 'package:brasil_cripto/feature/search_coins/viewmodels/search_service.dart';
import 'package:brasil_cripto/utils/db/db_helper.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _controller = TextEditingController();
  final CoinService _coinService = CoinService();
  final DBHelper _dbHelper = DBHelper();
  List<CryptoCoin> _coins = [];

  void _searchCoins() async {
    final listOfFavorites = await _coinService.fetchCoins(_controller.text);
    print('Tamanho da lista ${listOfFavorites.length}');
    final coins = await _coinService.fetchCoins(_controller.text);
    setState(() {
      _coins = coins;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BrasilCripto App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesCoinsView()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Pesquisar criptomoedas ',
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: _searchCoins,
            child: const Text("Pesquisar"),
          ),
          Expanded(
            child: _coins.isEmpty
                ? const Center(child: Text('Nenhuma criptomoeda encontrada'))
                : ListView.builder(
                    itemCount: _coins.length,
                    itemBuilder: (context, index) {
                      final coin = _coins[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        elevation: 5,
                        child: ListTile(
                          leading: Image.network(coin.thumb),
                          title: Text(coin.name),
                          subtitle: Text(coin.symbol),
                          trailing: IconButton(
                            icon: Icon(
                              coin.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            onPressed: () async {
                              setState(() {
                                coin.isFavorite = !coin.isFavorite;
                              });
                              if (coin.isFavorite) {
                                await _dbHelper.deleteFavorite(coin.idCoin);
                              } else {
                                await _dbHelper.insertFavorite(
                                  CryptoCoin(
                                    id: coin.id,
                                    idCoin: coin.idCoin,
                                    name: coin.name,
                                    apiSymbol: coin.apiSymbol,
                                    symbol: coin.symbol,
                                    marketCapRank: coin.marketCapRank,
                                    thumb: coin.thumb,
                                    large: coin.large,
                                    isFavorite: coin.isFavorite,
                                  ),
                                );
                              }
                            },
                          ),

                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CoinDetailsView(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
