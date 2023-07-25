
# Mozo
_An app that creates tickets with products and prints it with a bluetooth thermal printer. Those products are read from a json database determined by the user._

# Usage ✅
_Althought the app has a specific use by one person, it's avalaible for proofs and use if u need :)_

# Funcionality ⚙️ 
_Mozo was completely builded with Flutter and this packages:_
* [Provider](https://pub.dev/packages/provider) - A state manager.
* [Bluetooth Print](https://pub.dev/packages/bluetooth_print) - To use bluetooth and connect the external device.
* [HTTP](https://pub.dev/packages/http) - This package allows you to make http requests and consume APIs.
* [Shared Preferences](https://pub.dev/packages/shared_preferences) - Used for data persistence.
* [Permission Handler](https://pub.dev/packages/permission_handler) - This package helped make the request for permission to use location and bluetooth explicit, which is required in Android 10+.

The first step is to enter a url that contains a json file with the data you want. If the url is valid, the application will save it in memory to be reused and make the http request to take the data, map it and display it in a grid list.

As you select the products they need, these are added to a list that will then be printed by the thermal printer. The application is designed to calculate the price according to the quantity and the promotions that the user defines in the json file.

When you need to print the ticket, the app searches for nearby bluetooth devices. Once selected and connected, the app prints the ticket with the products and the date and time at the time the request is made.
  
# Autors 🧍
* **Joaquín López**
