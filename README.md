# zef_helpers_lazy

A Dart package providing a versatile implementation of lazy initialization, allowing deferred creation of objects with optional expiry and custom initialization and destruction callbacks.

## Features

- **Lazy Initialization**: Delay the creation of an object until it's actually needed.
- **Automatic Expiry**: Optionally set an expiry duration after which the object will be re-initialized upon next access.
- **Custom Expiry Conditions**: Define custom conditions to trigger object re-initialization.
- **Initialization and Destruction Callbacks**: Specify actions to be taken right after object creation and just before its destruction.
- **Reset Capability**: Manually reset the lazy instance, forcing re-initialization upon next access.

## Getting Started

To use `zef_helpers_lazy` in your Dart project, add it as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  zef_helpers_lazy: <latest_version>
```

Replace <latest_version> with the latest version of zef_helpers_lazy.

## Usage

Import `zef_helpers_lazy` into your Dart file:

```dart
import 'package:zef_helpers_lazy/zef_helpers_lazy.dart';
```

Create a lazy-initialized object:

```dart
Lazy<Config> lazyConfig = Lazy<Config>(
  factory: () => Config("Initial data loaded"),
  onCreate: (config) => print("Config created with data: ${config.data}"),
  onDestroy: (config) => print("Config with data '${config.data}' is being destroyed"),
  expiryDuration: Duration(seconds: 10),
);
```

Access the lazy-initialized object:

```dart
Config config = lazyConfig.value; // The Config object is created at this point if not already initialized.
```

## Contributing

Contributions are welcome! Please read our contributing guidelines and code of conduct before submitting pull requests or issues. Also every annotation or idea to improve is warmly appreciated.
