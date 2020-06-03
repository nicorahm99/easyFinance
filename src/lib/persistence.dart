import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionDTO {
  int id;
  String category;
  String type;
  double amount;
  int dateTime;
  String note;
  double currentBalance;

  TransactionDTO(
      {this.id,
      this.category,
      this.amount,
      this.note,
      this.type,
      this.currentBalance,
      this.dateTime
      });

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'category': category,
      'type': type,
      'amount': amount,
      'dateTime': dateTime,
      'note': note,
      'currentBalance': currentBalance
    };
  }

  String getGermanDateTimeString() {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(this.dateTime);
    int year = date.year;
    int month = date.month;
    int day = date.day;
    return '$day.$month.$year';
    }
}

class DBController {
  openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'transaction_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT, type BINARY, amount DOUBLE, dateTime INTEGER, note TEXT,currentBalance DOUBLE)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertTransaction(TransactionDTO transaction) async {
    final Database db = await openDB();
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TransactionDTO>> transactions() async {
    final Database db = await openDB();

    final List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (i) {
      return TransactionDTO(
          id: maps[i]['id'],
          category: maps[i]['category'],
          type: maps[i]['type'],
          amount: maps[i]['amount'],
          dateTime: maps[i]['dateTime'],
          note: maps[i]['note'],
          currentBalance: maps[i]['currentBalance']);
    });
  }

  Future<void> updateTransaction(TransactionDTO transaction) async {
    final db = await openDB();

    await db.update(
      'transactions',
      transaction.toMap(),
      where: "id = ?",
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await openDB();

    await db.delete(
      'transactions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  TransactionDTO createTransaction(object) {
    var transaction = TransactionDTO(
        id: object['id'],
        category: object['category'],
        type: object['type'],
        amount: object['amount'],
        dateTime: object['dateTime'],
        note: object['note'],
        currentBalance: object['currentBalance']);
    return transaction;
  }
}
