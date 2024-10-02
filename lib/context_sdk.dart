// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'package:context_sdk/real_world_context.dart';
import 'package:flutter/foundation.dart';

import 'context_sdk_platform_interface.dart';

class ContextSdk {
  Future<String> getSDKVersion() {
    return ContextSdkPlatform.instance.getSDKVersion();
  }

  /// Call this once right at the app start.
  Future<bool> setup(String licenseKey) {
    return ContextSdkPlatform.instance.setup(licenseKey);
  }

  /// Call this method to track a generic event. Using this allows us to provide you with insights on how your app behaves in the real-world context
  Future<void> trackEvent(
      String eventName, Map<String, dynamic> customSignals) {
    return ContextSdkPlatform.instance
        .trackEvent('event', eventName, customSignals);
  }

  /// Call this method to track a generic page view. Using this allows us to provide you with insights on how your app behaves in the real-world context
  Future<void> trackPageView(
      String pageName, Map<String, dynamic> customSignals) {
    return ContextSdkPlatform.instance
        .trackEvent('pageView', pageName, customSignals);
  }

  /// Call this method to track a generic user action. Using this allows us to provide you with insights on how your app behaves in the real-world context
  Future<void> trackUserAction(
      String actionName, Map<String, dynamic> customSignals) {
    return ContextSdkPlatform.instance
        .trackEvent('userAction', actionName, customSignals);
  }

  /// Set custom signals that will be used for all ContextSDK events on this instance.
  /// We recommend using this to provide generic information that's applicable to all calls, like any AB test information, or other data that may be relevant to calculate the likelihood of an event.
  /// Please be sure to not include any PII or other potentially sensitive information.
  /// You can overwrite values by using the same key again, and remove them by setting them to null.
  Future<void> setGlobalCustomSignals(Map<String, dynamic> customSignals) {
    return ContextSdkPlatform.instance.setGlobalCustomSignals(customSignals);
  }

  void calibrate(
    String flowName,
    ValueSetter<RealWorldContext> onContextReady, {
    int? maxDelay,
    Map<String, dynamic>? customSignals,
  }) async {
    ContextSdkPlatform.instance.calibrate(flowName, maxDelay, customSignals,
        (contextId) {
      onContextReady(RealWorldContext(ContextIdHolder(contextId)));
    });
  }

  /// Call this method to obtain a context for the given flow name.
  /// By default the callback will operate in calibration mode and always be called asynchronously within in 3 seconds (or sooner if the app has already been running for more than 3 seconds)
  /// Once a custom model has been created for a flow the callback will only be called if ContextSDK determined it to be a good moment, otherwise this method will simply do nothing, and your callback will not be invoked
  ///
  /// [onGoodMoment] Will only be called if ContextSDK deems it a good moment, meaning it might never be called.
  void optimize(
    String flowName,
    ValueSetter<RealWorldContext> onGoodMoment, {
    int? maxDelay,
    Map<String, dynamic>? customSignals,
  }) {
    ContextSdkPlatform.instance.optimize(flowName, maxDelay, customSignals,
        (contextId) {
      onGoodMoment(RealWorldContext(ContextIdHolder(contextId)));
    });
  }

  ///  Get the current context asynchronously. ContextSDK will automatically figure out, if a context object can be generated immediately (in that case, your callback is instantly executed), or if it needs to run for a little while, until it's ready to execute your callback. The callback will be excuted on the main thread.
  /// - [flowName] A unique name of the upsell flow you want to use ContextSDK for
  /// - [duration] By default, we recommend setting this to 3. The duration of accelerometer data that should be used for the current context. This value has to be within (inclusive) 2 and 7 seconds. **Important:** Once you've decided for a specific `duration`, you need to stick with it: Your custom model will be trained and provided for the specific `duration` you've chosen. If you change the `duration` later, you'll need to re-train your custom model.
  /// - [customSignals] A map of custom signals you want to add to the context
  /// Returns: A Future that resolves to a [RealWorldContext] object. If ContextSDK wasn't running this might take upto [duration] seconds to resolve, otherwise this will resolve instantly.
  Future<RealWorldContext> fetchContext(String flowName, int duration,
      {Map<String, dynamic>? customSignals}) async {
    final contextId = await ContextSdkPlatform.instance
        .fetchContext(flowName, duration, customSignals);
    return RealWorldContext(ContextIdHolder(contextId));
  }

  ///  Get the current context synchronously. The signal may not include all the information, if the duration wasn't reached.
  /// Be sure that the majority of the times when calling this method, the SDK has already had enough time to reach the duration you've set.
  /// - [flowName] A unique name of the upsell flow you want to use ContextSDK for
  /// - [duration] By default, we recommend setting this to 3. The duration of accelerometer data that should be used for the current context. This value has to be within (inclusive) 2 and 7 seconds. **Important:** Once you've decided for a specific `duration`, you need to stick with it: Your custom model will be trained and provided for the specific `duration` you've chosen. If you change the `duration` later, you'll need to re-train your custom model.
  /// - [customSignals] A map of custom signals you want to add to the context
  /// Returns: A [RealWorldContext] object. This will always resolve instantly, but might lead to an incomplete context object if the duration wasn't reached.
  Future<RealWorldContext> instantContext(String flowName, int duration,
      {Map<String, dynamic>? customSignals}) async {
    final contextId = await ContextSdkPlatform.instance
        .instantContext(flowName, duration, customSignals);
    return RealWorldContext(ContextIdHolder(contextId));
  }

  ///  Fetch the most recently generated Context for a given flowName. Will be null if there is no recent context.
  Future<RealWorldContext?> recentContext(String flowName) async {
    final contextId = await ContextSdkPlatform.instance.recentContext(flowName);
    if (contextId == null) {
      return null;
    }
    return RealWorldContext(ContextIdHolder(contextId));
  }
}
