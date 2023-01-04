import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataProvider extends ChangeNotifier {
  Database? database;
  Future<void> loadDatabase() async {
    database = await openDatabase(
      'glongya_data.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE glongya (id INTEGER PRIMARY KEY, medicine TEXT, hour INTEGER, minute INTEGER)');
        await db.insert('glongya', {'id': 1, 'medicine': 'empty', 'hour': 0, 'minute': 0});
        await db.insert('glongya', {'id': 2, 'medicine': 'empty', 'hour': 0, 'minute': 0});
        await db.insert('glongya', {'id': 3, 'medicine': 'empty', 'hour': 0, 'minute': 0});
      },
    );
    notifyListeners();
  }

  Future<void> modifyDatabase({int? id, String? medicine, int? hour, int? minute}) async {
    if (database == null) {
      return;
    }
    if (medicine != null) {
      await database!.rawUpdate("UPDATE glongya SET medicine = ? WHERE id = ?", [medicine, id]);
    }
    if (hour != null && minute != null) {
      await database!.execute("UPDATE glongya SET hour = ?, minute = ? WHERE id = ?", [hour, minute, id]);
    }
    await loadDatabase();
    notifyListeners();
  }
}
