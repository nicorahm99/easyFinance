import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Transaction {
  final int id;
  final String category;
  final double amount;
  final String note;
  final String type;
  final double currentBalance;

  Transaction(
      {this.id,
      this.category,
      this.amount,
      this.note,
      this.type,
      this.currentBalance});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'amount': amount,
      'note': note,
      'type': type,
      'currentBalance': currentBalance
    };
  }
}

void main() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'transaction_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE transactions(id INTEGER PRIMARY KEY, category TEXT, amount DOUBLE, note TEXT, type TEXT,currentBalance DOUBLE)",
      );
    },
    version: 1,
  );

  Future<void> insertTransaction(Transaction transaction) async {
    final Database db = await database;
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Transaction>> transactions() async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('transactions');

    return List.generate(maps.length, (i) {
      return Transaction(
          id: maps[i]['id'],
          category: maps[i]['category'],
          amount: maps[i]['amount'],
          note: maps[i]['note'],
          type: maps[i]['type'],
          currentBalance: maps[i]['currentBalance']);
    });
  }

  Future<void> updateDog(Transaction transaction) async {
    final db = await database;

    await db.update(
      'transactions',
      transaction.toMap(),
      where: "id = ?",
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;

    await db.delete(
      'transactions',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
