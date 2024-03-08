/// A class that provides lazy initialization for a value of type [T].
/// The value is created by a factory function the first time it is needed.
/// Optionally, the value can expire based on a duration or a custom condition,
/// which will trigger the recreation of the value upon the next access.
class Lazy<T> {
  T? _instance;
  DateTime? _lastInitializedTime;

  final T Function() _factory;
  final void Function(T instance)? _onCreate;
  final Duration? _expiryDuration;
  final bool Function(T instance)? _shouldExpire;
  final void Function(T instance)? _onDestroy;

  /// Constructs an instance of `Lazy<T>` with the required factory function
  /// and optional callbacks for creation, expiry, and destruction of the value.
  ///
  /// Parameters:
  /// - [factory]: A function that returns an instance of [T] when invoked.
  /// - [onCreate]: An optional callback that is invoked after the value is created.
  /// - [expiryDuration]: An optional duration after which the value is considered expired and needs to be recreated.
  /// - [shouldExpire]: An optional condition that, if returns true, will mark the value as expired and trigger its recreation.
  /// - [onDestroy]: An optional callback that is invoked before the value is reset or recreated, useful for cleanup.
  Lazy({
    required T Function() factory,
    void Function(T instance)? onCreate,
    Duration? expiryDuration,
    bool Function(T instance)? shouldExpire,
    void Function(T instance)? onDestroy,
  })  : _factory = factory,
        _onCreate = onCreate,
        _expiryDuration = expiryDuration,
        _shouldExpire = shouldExpire,
        _onDestroy = onDestroy;

  /// Returns `true` if the value has been initialized, otherwise `false`.
  bool get isInitialized => _instance != null;

  /// Returns the current value, creating it if necessary. If the value is determined to be expired
  /// either by time or a custom condition, it is recreated. This check happens each time the value is accessed.
  T get value {
    final now = DateTime.now().toUtc();

    // Check if the value has expired based on time or a custom condition.
    final isTimeBasedExpired = _expiryDuration != null &&
        _lastInitializedTime != null &&
        now.difference(_lastInitializedTime!) > _expiryDuration!;
    final isExpired =
        (_instance != null && (_shouldExpire?.call(_instance as T) ?? false)) ||
            isTimeBasedExpired;

    if (isExpired) {
      reset(); // Reset if expired, ensuring onDestroy is called if provided.
    }

    if (_instance == null) {
      _instance = _factory();
      _lastInitializedTime = now;
      _onCreate?.call(_instance as T); // Invoke onCreate callback after creation.
    }
    return _instance!;
  }

  /// Resets the value, causing it to be re-created upon next access.
  /// If a destruction callback is provided, it is invoked with the current value before resetting.
  void reset() {
    if (_instance != null) {
      // Invoke onDestroy callback before resetting.
      _onDestroy?.call(_instance as T);
      _instance = null;
    }
  }
}
