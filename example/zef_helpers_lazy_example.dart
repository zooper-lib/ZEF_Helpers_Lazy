import 'package:zef_helpers_lazy/zef_helpers_lazy.dart';

class Config {
  final String data;

  Config(this.data);

  void display() {
    print("Config data: $data");
  }
}

void main() async {
  Lazy<Config> lazyConfig = Lazy<Config>(
    factory: () => Config("Initial data loaded"),
    onCreate: (config) => print("Config created with data: ${config.data}"),
    shouldExpire: (config) => config.data == "Expired data",
    onDestroy: (config) =>
        print("Config with data '${config.data}' is being destroyed"),
    expiryDuration: Duration(milliseconds: 10), // Example expiry duration
  );

  // Access the lazy instance to trigger creation
  print("Accessing lazyConfig for the first time:");
  final accessOne = await lazyConfig.value;
  accessOne.display();

  // Access it again to show that it doesn't recreate the instance
  print("\nAccessing lazyConfig again:");
  final accessTwo = await lazyConfig.value;
  accessTwo.display();

  // Simulate expiry by waiting longer than the expiry duration
  Future.delayed(Duration(milliseconds: 20), () async {
    print("\nAccessing lazyConfig after expiry:");
    final accessThree = await lazyConfig.value;
    accessThree.display(); // This should recreate the instance
  });

  // Resetting the lazy instance manually
  print("\nResetting lazyConfig:");
  lazyConfig.reset();

  // Accessing after reset to show it recreates the instance
  print("\nAccessing lazyConfig after reset:");
  final accessFour = await lazyConfig.value;
  accessFour.display();
}
