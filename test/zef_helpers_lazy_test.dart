import 'package:test/test.dart';
import 'package:zef_helpers_lazy/zef_helpers_lazy.dart';

void main() {
  group('Lazy<T> Initialization', () {
    late Lazy<int> lazyValue;

    setUp(() {
      lazyValue = Lazy<int>(factory: () => 42);
    });

    test('is not initialized on creation', () {
      expect(lazyValue.isInitialized, isFalse);
    });

    test('initializes after first value access', () async {
      var _ = await lazyValue.value; // Act by accessing the value.
      expect(lazyValue.isInitialized, isTrue);
    });
  });

  group('Lazy<T> Reset Functionality', () {
    late Lazy<int> lazyValue;

    setUp(() async {
      lazyValue = Lazy<int>(factory: () => 42);
      var _ = await lazyValue.value; // Force initialization before each test.
    });

    test('becomes uninitialized after reset', () {
      lazyValue.reset(); // Act by resetting.
      expect(lazyValue.isInitialized, isFalse);
    });

    test('re-initializes after reset and subsequent access', () async {
      lazyValue.reset(); // Reset the instance.
      var _ = await lazyValue.value; // Force re-initialization.
      expect(lazyValue.isInitialized, isTrue);
    });
  });

  group('Lazy<T> Expiry Functionality', () {
    late Lazy<int> lazyValueWithExpiry;

    setUp(() {
      lazyValueWithExpiry = Lazy<int>(
        factory: () => 42,
        expiryDuration: Duration(milliseconds: 100),
      );
    });

    test('re-initializes after expiry duration', () async {
      var initialValue =
          await lazyValueWithExpiry.value; // Force initial value creation.
      await Future.delayed(Duration(milliseconds: 150)); // Wait for expiry.
      var newValue =
          await lazyValueWithExpiry.value; // Access value again after expiry.

      expect(initialValue,
          equals(newValue)); // Assuming factory returns the same value.
      expect(lazyValueWithExpiry.isInitialized, isTrue);
    });
  });
}
