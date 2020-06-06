import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TransactionDTO {
  int id;
  int category;
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

class CategoryDTO{
  int id;
  String category;

  CategoryDTO({
    this.id,
    this.category
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'category': category
    };
  }
}

class DBController {
  openDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'transaction_database.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY AUTOINCREMENT, category INTEGER, type BINARY, amount DOUBLE, dateTime INTEGER, note TEXT,currentBalance DOUBLE, FOREIGN KEY(category) REFERENCES categories(id))",
        );
        db.execute(
          "CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT)",
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

  Future<void> insertCategory(String category) async{
    final Database db = await openDB();
    await db.insert(
      'categories',
      {'category':category},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );  
  }

  Future<List<CategoryDTO>> categories() async{
    final Database db = await openDB();

    final List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return CategoryDTO(
          id: maps[i]['id'],
          category: maps[i]['category']);
    }); 
  }

  Future<void> updateCategory(CategoryDTO category) async {
    final db = await openDB();

    await db.update(
      'categories',
      category.toMap(),
      where: "id = ?",
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int id) async {
    final db = await openDB();

    await db.delete(
      'transactions',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<CategoryDTO> getCategoryById(int id) async{
    if (id < 0){
      return CategoryDTO(id: -1, category: 'Please Choose');
    }
    
    final Database db = await openDB();
      
    List<Map<String, dynamic>> result = await db.query(
      'categories',
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isEmpty){
      throw new Exception();
    }
    return CategoryDTO(
      id: result[0]['id'],
      category: result[0]['category']);
  }

  void addBasicCategories(){
    final List<String> categoryNames = [
      'Miscellaneous',
      'Car', 
      'Food',
      'Household',
      'Pets',
      'Rent',
      'Toys',
      'Insurance',
      'Salary',
      'Presents',
      'Subscriptions',
      'Entertainment'
      ];
    
    categoryNames.forEach((element) {insertCategory(element);});
  }
}
