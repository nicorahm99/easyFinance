// import 'package:ef/persistence.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('easyFinance App', () {
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    SerializableFinder findByKey(String key){
      return find.byValueKey(key);
    }
    SerializableFinder findByText(String text){
      return find.text(text);
    }

    test('SignUp after first installation', () async {
      await driver.tap(findByKey('username'));
      await driver.enterText('testName');
      await driver.tap(findByKey('setPassword'));
      await driver.enterText('password1234');
      await driver.tap(findByKey('confirmPassword'));
      await driver.enterText('password1234');
      await driver.tap(findByKey('logInButton'));
      assert(find.text('Dashboard') != null);
    });

    test('Goto Diagrams', () async {
      await driver.tap(findByText('Diagrams'));
      assert(findByText('Expenditures, Earnings and Savings per month') != null);
    });

    test('Goto Transactions', () async {
      await driver.tap(findByText('Transactions'));
      assert(findByText('Transactions') != null);
    });

    test('Add Transaction', () async {
      await driver.tap(findByKey('AddTransactionButton'));
      await driver.tap(findByKey('amountTextfield'));
      await driver.enterText('815.42');
      await driver.tap(findByText('Income'));
      await driver.tap(findByText('Miscellaneous'));
      await driver.tap(findByText('Salary'));
      await driver.tap(findByKey('submitButton'));
      assert(findByText('815.42') != null);
    });

    test('Edit Transaction', () async {
      await driver.tap(findByText('S'));
      await driver.tap(findByText('Expense'));
      await driver.tap(findByKey('submitButton'));
      assert(findByText('-815.42') != null);
    });

    test('delete Transaction', () async {
      await driver.tap(findByText('S'));
      await driver.tap(findByKey('deleteButton'));
      assert(findByText('-815.42') == null);
    });

    test('Goto Settings', () async {
      await driver.tap(findByText('Settings'));
      assert(findByText('Settings') != null);
    });
    
    test('edit username', () async {
      await driver.tap(findByText('testName'));
      await driver.tap(findByKey('usernameInputField'));
      await driver.enterText('newUsername');
      await driver.tap(findByKey('saveButton'));
      assert(findByText('newUsername') != null);
    });

    test('Set Bank Balance', () async {
      await driver.tap(findByText('Set Bank-Balance'));
      await driver.tap(findByKey('balanceInputField'));
      await driver.enterText('42.48');
      await driver.tap(findByKey('saveButton'));
      await driver.tap(findByText('Home'));
      assert(findByText('42.48€') != null);

      await driver.tap(findByText('Settings'));
    });

    
    test('change Password', () async {
      await driver.tap(findByText('Change Password'));
      await driver.tap(findByKey('oldPasswordInputField'));
      await driver.enterText('password1234');
      await driver.tap(findByKey('newPasswordInputField'));
      await driver.enterText('newPassword1234');
      await driver.tap(findByKey('saveButton'));

      // var settingsDTO = await DBController().settings();
      // assert(settingsDTO[0].password == 'newPassword1234');

      assert(findByText('Settings') != null);
    });

    test('create and delete category', () async {
      await driver.tap(findByText('Create Categories'));
      await driver.tap(findByKey('categoryInputField'));
      await driver.enterText('newCategory');
      await driver.tap(findByKey('saveButton'));

      await driver.tap(findByText('Delete Categories'));
      await driver.scrollIntoView(findByText('newCategory'));
      await driver.tap(findByText('newCategory'));
      await driver.tap(findByKey('deleteButton'));

      assert(findByText('Settings') != null);
    });
  });
}