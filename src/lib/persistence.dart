import 'dart:async';
import 'dart:ffi';
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

class BankbalanceDTO{
  int id;
  double currentbalance;

  BankbalanceDTO({
    this.id,
    this.currentbalance
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'currentbalance': currentbalance
    };
  }
}

class SettingDTO{
  int id;
  String password;
  String username;

  SettingDTO({
    this.id,
    this.password,
    this.username,
  });

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'password': password,
      'username': username,
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
          "CREATE TABLE bankbalance(id INTEGER PRIMARY KEY AUTOINCREMENT, currentbalance DOUBLE)",
        );
        db.execute(
          "CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, category TEXT)",
        );
        db.execute(
          "CREATE TABLE settings(id INTEGER PRIMARY KEY AUTOINCREMENT, password TEXT, username TEXT)",
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
      'categories',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<CategoryDTO> getCategoryById(int id) async{
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

  Future<void> insertbankbalance(BankbalanceDTO bankbalance) async {
    final Database db = await openDB();
    await db.insert(
      'bankbalance',
      bankbalance.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<BankbalanceDTO>> bankbalance() async{
    final Database db = await openDB();

    final List<Map<String, dynamic>> maps = await db.query('bankbalance');

    return List.generate(maps.length, (i) {
      return BankbalanceDTO(
          id: maps[i]['id'],
          currentbalance: maps[i]['currentbalance']);
    }); 
  }

  Future<void> updatebankbalance(BankbalanceDTO bankbalance) async {
    final db = await openDB();

    await db.update(
      'bankbalance',
      bankbalance.toMap(),
      where: "id = ?",
      whereArgs: [bankbalance.id],
    );
  }

  Future<void> deletebankbalance(int id) async {
    final db = await openDB();

    await db.delete(
      'bankbalance',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  void initalbankbalance(){
    BankbalanceDTO _initbalance;
    _initbalance.currentbalance = 0.00;
    insertbankbalance(_initbalance);
  }

  Future<BankbalanceDTO> getBankbalanceById(int id) async{
    final Database db = await openDB();
      
    List<Map<String, dynamic>> result = await db.query(
      'bankbalance',
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isEmpty){
      throw new Exception();
    }
    return BankbalanceDTO(
      id: result[0]['id'],
      currentbalance: result[0]["currentbalance"]);
  }


Future<void> insertSettings(SettingDTO setting) async {
    final Database db = await openDB();
    await db.insert(
      'settings',
      setting.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SettingDTO>> settings() async{
    final Database db = await openDB();

    final List<Map<String, dynamic>> maps = await db.query('settings');

    return List.generate(maps.length, (i) {
      return SettingDTO(
          id: maps[i]['id'],
          password: maps[i]['password'],
          username: maps[i]['username']);
    }); 
  }

  Future<void> updateSettings(SettingDTO setting) async {
    final db = await openDB();

    await db.update(
      'settings',
      setting.toMap(),
      where: "id = ?",
      whereArgs: [setting.id],
    );
  }

  Future<void> deleteSettings(int id) async {
    final db = await openDB();

    await db.delete(
      'settings',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  void initalsettings(){
    SettingDTO _initsetting;
    _initsetting.username = "initial";
    _initsetting.password = "1234";
    insertSettings(_initsetting);
  }

  Future<SettingDTO> getSettingById(int id) async{
    final Database db = await openDB();
      
    List<Map<String, dynamic>> result = await db.query(
      'settings',
      where: "id = ?",
      whereArgs: [id],
    );

    if (result.isEmpty){
      throw new Exception();
    }
    return SettingDTO(
      id: result[0]['id'],
      username: result[0]["username"],
      password: result[0]["password"]);
  }
}
