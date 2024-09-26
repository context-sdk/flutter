import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'context_sdk_method_channel.dart';

abstract class ContextSdkPlatform extends PlatformInterface {
  /// Constructs a ContextSdkPlatform.
  ContextSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ContextSdkPlatform _instance = MethodChannelContextSdk();

  /// The default instance of [ContextSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelContextSdk].
  static ContextSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ContextSdkPlatform] when
  /// they register themselves.
  static set instance(ContextSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> getSDKVersion() {
    throw UnimplementedError('getSDKVersion() has not been implemented.');
  }

  Future<bool> setup(String licenseKey) {
    throw UnimplementedError('setup() has not been implemented.');
  }

  Future<void> trackEvent(String eventType, String eventName, Map<String, dynamic> customSignals) {
    throw UnimplementedError('trackEvent() has not been implemented.');
  }

  Future<void> setGlobalCustomSignals(Map<String, dynamic> customSignals) {
    throw UnimplementedError('setGlobalCustomSignals() has not been implemented.');
  }

  Future<void> releaseContext(int contextId) {
    throw UnimplementedError('releaseContext() has not been implemented.');
  }

  calibrate(String flowName, int? maxDelay, Map<String, dynamic>? customSignals, ValueSetter<int> onContextReady) {
    throw UnimplementedError('calibrate() has not been implemented.');
  }

  optimize(String flowName, int? maxDelay, Map<String, dynamic>? customSignals, ValueSetter<int> onGoodMoment) {
    throw UnimplementedError('optimize() has not been implemented.');
  }

  Future<int> fetchContext(String flowName, int duration, Map<String, dynamic>? customSignals) {
    throw UnimplementedError('fetchContext() has not been implemented.');
  }

  Future<int> instantContext(String flowName, int duration, Map<String, dynamic>? customSignals) {
    throw UnimplementedError('instantContext() has not been implemented.');
  }

  Future<int?> recentContext(String flowName) {
    throw UnimplementedError('recentContext() has not been implemented.');
  }

  Future<String> contextValidate(int contextId)  {
    throw UnimplementedError('contextValidate() has not been implemented.');
  }

  Future<bool> contextShouldUpsell(int contextId) {
    throw UnimplementedError('contextShouldUpsell() has not been implemented.');
  }

  Future<void> contextLog(int contextId, int outcome, bool alwaysLog) {
    throw UnimplementedError('contextLog() has not been implemented.');
  }

  Future<void> contextAppendOutcomeMetadata(int contextId, Map<String, dynamic> metadata) {
    throw UnimplementedError('contextAppendOutcomeMetadata() has not been implemented.');
  }
}
