import 'package:brasil_cripto/feature/coin_details/views/coin_details_view.dart';
import 'package:brasil_cripto/utils/db/db_helper.dart';
import 'package:brasil_cripto/utils/models/cryptocoin.dart';
import 'package:flutter/material.dart';

class FavoritesCoinsView extends StatefulWidget {
  FavoritesCoinsView({super.key});

  @override
  State<FavoritesCoinsView> createState() => _FavoritesCoinsViewState();
}

class _FavoritesCoinsViewState extends State<FavoritesCoinsView> {
  final DBHelper _dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criptomoedas Favoritas')),
      body: FutureBuilder<List<CryptoCoin>>(
        future: _dbHelper.getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma criptomoeda encontrada'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final coin = snapshot.data![index];
              return ListTile(
                leading: Image.network(coin.thumb),
                title: Text(coin.name),
                subtitle: Text(coin.symbol),
                trailing: IconButton(
                  icon: Icon(
                    coin.isFavorite ? Icons.favorite : Icons.favorite_border,
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
                    MaterialPageRoute(builder: (context) => CoinDetailsView()),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
