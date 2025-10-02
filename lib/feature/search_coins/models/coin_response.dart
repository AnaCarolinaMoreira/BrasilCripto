import 'package:brasil_cripto/utils/models/cryptocoin.dart';
import 'package:equatable/equatable.dart';

class CoinResponse extends Equatable {
   List<CryptoCoin>? cryptoCoinList;

  CoinResponse({
    required this.cryptoCoinList,
  });
  @override
  List<Object> get props => [];

  Map<String, dynamic> toMap() {
    return {
      "coins": cryptoCoinList !=null ? cryptoCoinList!.map((e) => e.toMap()).toList():[] ,
    };
  }

  static CoinResponse fromMap(Map<String, dynamic> map) {
    return CoinResponse(
      cryptoCoinList: map['coins'] !=null ? List.from(map['coins'] as List).map((e) => CryptoCoin.fromMap(e)).toList() :[],
    );
  }
}


