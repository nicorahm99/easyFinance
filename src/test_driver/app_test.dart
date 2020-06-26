import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('easyFinance App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    // final counterTextFinder = find.byValueKey('counter');
    // final buttonFinder = find.byValueKey('increment');
    SerializableFinder findTextField(String key){
      return find.byValueKey(key);
    }

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('starts at 0', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      await driver.tap(findTextField('username'));
      await driver.enterText('testName');
      await driver.tap(findTextField('setPassword'));
      await driver.enterText('password1234');
      await driver.tap(findTextField('confirmPassword'));
      await driver.enterText('password1234');
      await driver.tap(findTextField('logIn'));
      expect(driver.getText(find.text('Dashbord')), 'Dashboard');
    });

    // test('increments the counter', () async {
    //   // First, tap the button.
    //   await driver.tap(buttonFinder);

    //   // Then, verify the counter text is incremented by 1.
    //   expect(await driver.getText(counterTextFinder), "1");
    // });
  });
}