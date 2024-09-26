import 'package:context_sdk/context_sdk_platform_interface.dart';

/// /// Represents a full context event in a moment in time. Use [RealWorldContext.log] to log an event.
class RealWorldContext {
  // Keeps the finalizer itself reachable, otherwise it might be disposed
  // before the finalizer callback gets a chance to run.
  static final Finalizer<ContextIdHolder> _finalizer =
      Finalizer((context) => context._dispose());

  final ContextIdHolder _contextId;

  RealWorldContext(this._contextId) {
    _finalizer.attach(this, _contextId);
  }

  /// Check if you now is a good time to show an upsell prompt. During calibration phase, this will always be `true`.
  Future<bool> shouldUpsell() {
    if (!_contextId.isValid()) {
      return Future.value(true);
    }

    return ContextSdkPlatform.instance
        .contextShouldUpsell(_contextId.contextId);
  }

  /// Call this method to do a local validation of your ContextSDK setup
  Future<String> validate() {
    if (!_contextId.isValid()) {
      return Future.value(
          '[ContextSDK] Invalid context received, please contact support@contextsdk.com');
    }

    return ContextSdkPlatform.instance.contextValidate(_contextId.contextId);
  }

  /// Use this method to log an outcome and send the context event to the backend
  Future<void> log(Outcome outcome) {
    if (!_contextId.isValid()) {
      print(
          "[ContextSDK] Invalid context received, please contact support@contextsdk.com");
      return Future.value();
    }

    return ContextSdkPlatform.instance
        .contextLog(_contextId.contextId, outcome.value, true);
  }

  /// Use this function to log an outcome only if this particular context object hasn't been logged yet
  Future<void> logIfNotLoggedYet(Outcome outcome) {
    if (!_contextId.isValid()) {
      print(
          "[ContextSDK] Invalid context received, please contact support@contextsdk.com");
      return Future.value();
    }

    return ContextSdkPlatform.instance
        .contextLog(_contextId.contextId, outcome.value, false);
  }

  /// This method allows you to append custom outcomes to that specific outcome
  /// We recommend using this method to provide information like the selected price tier / plan, or other relevant info about the type of product or action the user has selected
  /// Using the same ID multiple times will replace the previous entries with that ID.
  Future<void> appendOutcomeMetadata(Map<String, dynamic> metadata) {
    if (!_contextId.isValid()) {
      print(
          "[ContextSDK] Invalid context received, please contact support@contextsdk.com");
      return Future.value();
    }

    return ContextSdkPlatform.instance
        .contextAppendOutcomeMetadata(_contextId.contextId, metadata);
  }

  void _dispose() {
    _contextId._dispose();
    _finalizer.detach(_contextId);
  }
}

class ContextIdHolder {
  final int _contextId;

  ContextIdHolder(this._contextId);

  int get contextId => _contextId;

  bool isValid() {
    return _contextId != -1;
  }

  void _dispose() {
    ContextSdkPlatform.instance.releaseContext(_contextId);
  }
}

enum Outcome {
  /// Optional outcome: The user has tapped on the ad, and followed any external link provided.
  positiveAdTapped(4),

  /// Optional outcome: The user ended up successfully purchasing the product (all the way through the payment flow)
  positiveConverted(3),

  /// Optional outcome: The user has tapped on the banner, and started the purchase flow, or read more about the offer
  positiveInteracted(2),

  //---------------------------------------------------------------------------------------------------------
  // The default signals
  //---------------------------------------------------------------------------------------------------------

  /// A generic, positive signal. Use this for the basic ContextSDK integration, e.g. when showing an upsell prompt.
  positive(1),

  /// Log this when ContextSDK has recommended to skip showing an upsell prompt (`.shouldUpsell` is false). Logging this explicitly is not required if you use `ContextManager.optimize()` or `ContextManager.calibrate()` as it will be handled by ContextSDK automatically.
  skipped(0),

  /// A generic, negative signal. Use this for the basic ContextSDK integration, on a user e.g. declining or dismissing an upsell prompt
  negative(-1),

  //---------------------------------------------------------------------------------------------------------
  // Optionally, you can provide additionally depth by using the enums below instead of only using .negative
  //---------------------------------------------------------------------------------------------------------

  /// Optional outcome: Use this as a negative signal of a user not interacting with e.g. a banner. Depending on your app, we may recommend to log this when the app is put into the background, and hasn't interacted with a banner in any way. This can be done using the `logIfNotLoggedYet` method
  negativeNotInteracted(-2),

  /// Optional outcome: The user has actively dismissed the banner (e.g. using a close button)
  negativeDismissed(-3),

  //---------------------------------------------------------------------------------------------------------
  // All ATT related outcomes
  //---------------------------------------------------------------------------------------------------------
  // Available outcomes taken from AppTrackingTransparency framework `AuthorizationStatus`
  attNotDetermined(20),
  attRestricted(21),
  attDenied(22),
  attAuthorized(23),
  attUnsupportedValue(19);

  const Outcome(this.value);
  final int value;
}
