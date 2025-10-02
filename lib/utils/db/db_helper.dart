import 'package:brasil_cripto/utils/models/cryptocoin.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'coins.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  //idCoin id local
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites_coins (
        idCoin INTEGER PRIMARY KEY AUTOINCREMENT,
        id TEXT,
        name TEXT, 
        apiSymbol TEXT, 
        poster TEXT, 
        symbol TEXT,
        marketCapRank TEXT, 
        thumb TEXT, 
        large TEXT,
        isFavorite TEXT
      )
    ''');
  }

  Future<void> insertFavorite(CryptoCoin coin) async {
    final db = await database;
    await db.insert(
      'favorites_coins',
      coin.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CryptoCoin>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites_coins');

    return List.generate(maps.length, (i) {
      return CryptoCoin(
        id: maps[i]['id'],
        idCoin: maps[i]['idCoin'],
        name: maps[i]['name'],
        apiSymbol: maps[i]['apiSymbol'],
        symbol: maps[i]['symbol'],
        marketCapRank: maps[i]['marketCapRank'],
        thumb: maps[i]['thumb'],
        large: maps[i]['large'],
        isFavorite: maps[i]['isFavorite'],
      );
    });
  }

  Future<bool> deleteFavorite(int idCoin) async {
    final db = await database;
    final int count = await db.delete(
      'favorites_coins',
      where: 'idCoin = ?',
      whereArgs: [idCoin.toString()],
    );

    return count > 0;
  }

  Future<bool> isFavorite(int idCoin) async {
    final db = await database; // Gets the database instance.
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites_coins',
      where: 'idCoin = ?',
      whereArgs: [idCoin.toString()],
    );
    return maps.isNotEmpty;
  }

  Future<List<CryptoCoin>> listOfFavorites() async {
    final db = await database;

    final List<Map<String, Object?>> isFavoriteMaps = await db.query('favorites_coins');
    return [
      for (final {
            'idCoin': idCoin as int,
            'id': id as String,
            'name': name as String,
            'apiSymbol': apiSymbol as String,
            'symbol': symbol as String,
            'marketCapRank': marketCapRank as int,
            'thumb': thumb as String,
            'large': large as String,
            'isFavorite': isFavorite as bool,
          }
          in isFavoriteMaps)
        CryptoCoin(
          idCoin: idCoin,
          id: id,
          name: name,
          apiSymbol: apiSymbol,
          symbol: symbol,
          marketCapRank: marketCapRank,
          thumb: thumb,
          large: large,
          isFavorite: isFavorite,
        ),
    ];
  }
}
