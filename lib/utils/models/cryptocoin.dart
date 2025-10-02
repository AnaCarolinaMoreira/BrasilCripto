import 'package:equatable/equatable.dart';

class CryptoCoin extends Equatable {
  final int idCoin; //id local do db
  final String id;
  final String name;
  final String apiSymbol;
  final String symbol;
  final int marketCapRank;
  final String thumb;
  final String large;
  bool isFavorite;

  CryptoCoin({
    required this.idCoin,
    required this.id,
    required this.name,
    required this.apiSymbol,
    required this.symbol,
    required this.marketCapRank,
    required this.thumb,
    required this.large,
    required this.isFavorite,
  });

  @override
  List<Object> get props => [];

  Map<String, dynamic> toMap() {
    return {
      'idCoin': idCoin,
      'id': id,
      'name': name,
      'api_symbol': apiSymbol,
      'symbol': symbol,
      'market_cap_rank': marketCapRank,
      'thumb': thumb,
      'large': large,
      'isFavorite': isFavorite,
    };
  }

  static CryptoCoin fromMap(Map<String, dynamic> map) {
    return CryptoCoin(
      idCoin: map['idCoin'] ?? 0,
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      apiSymbol: map['api_symbol'] ?? '',
      symbol: map['symbol'] ?? '',
      marketCapRank: map['market_cap_rank'] ?? 0,
      thumb: map['thumb'] ?? '',
      large: map['large'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
    );
  }
}
