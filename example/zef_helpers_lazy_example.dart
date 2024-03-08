import 'package:zef_helpers_lazy/zef_helpers_lazy.dart';

class Config {
  final String data;

  Config(this.data);

  void display() {
    print("Config data: $data");
  }
}

void main() {
  Lazy<Config> lazyConfig = Lazy<Config>(
    factory: () => Config("Initial data loaded"),
    onCreate: (config) => print("Config created with data: ${config.data}"),
    shouldExpire: (config) => config.data == "Expired data",
    onDestroy: (config) =>
        print("Config with data '${config.data}' is being destroyed"),
    expiryDuration: Duration(seconds: 10), // Example expiry duration
  );

  // Access the lazy instance to trigger creation
  print("Accessing lazyConfig for the first time:");
  lazyConfig.value.display();

  // Access it again to show that it doesn't recreate the instance
  print("\nAccessing lazyConfig again:");
  lazyConfig.value.display();

  // Simulate expiry by waiting longer than the expiry duration
  Future.delayed(Duration(seconds: 15), () {
    print("\nAccessing lazyConfig after expiry:");
    lazyConfig.value.display(); // This should recreate the instance
  });

  // Resetting the lazy instance manually
  print("\nResetting lazyConfig:");
  lazyConfig.reset();

  // Accessing after reset to show it recreates the instance
  print("\nAccessing lazyConfig after reset:");
  lazyConfig.value.display();
}
