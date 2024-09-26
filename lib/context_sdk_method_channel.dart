import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'context_sdk_platform_interface.dart';

/// An implementation of [ContextSdkPlatform] that uses method channels.
class MethodChannelContextSdk extends ContextSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('context_sdk');

  MethodChannelContextSdk() {
    methodChannel.setMethodCallHandler(_handleMethodCall);
  }

  var _callbackId = 0;
  final _callbacks = <int, Function>{};

  int _getCallbackId(Function callback) {
    _callbackId++;
    _callbacks[_callbackId] = callback;
    return _callbackId;
  }

  @override
  Future<String> getSDKVersion() async {
    final version = await methodChannel.invokeMethod<String>('getSDKVersion');
    return version ?? 'Unknown';
  }

  @override
  Future<bool> setup(String licenseKey) async {
    final result = await methodChannel.invokeMethod<bool>('setup', licenseKey);
    return result ?? false;
  }

  @override
  Future<void> trackEvent(String eventType, String eventName,
      Map<String, dynamic> customSignals) async {
    await methodChannel.invokeMethod<void>('trackEvent', <String, dynamic>{
      'eventType': eventType,
      'eventName': eventName,
      'customSignals': customSignals,
    });
  }

  @override
  Future<void> setGlobalCustomSignals(Map<String, dynamic> customSignals) {
    return methodChannel.invokeMethod<void>(
        'setGlobalCustomSignals', customSignals);
  }

  @override
  Future<void> releaseContext(int contextId) {
    return methodChannel.invokeMethod<void>('releaseContext', contextId);
  }

  @override
  void calibrate(
      String flowName,
      int? maxDelay,
      Map<String, dynamic>? customSignals,
      ValueSetter<int> onContextReady) async {
    final callbackId = _getCallbackId(onContextReady);
    methodChannel.invokeMethod<void>('calibrate', <String, dynamic>{
      'flowName': flowName,
      'maxDelay': maxDelay,
      'customSignals': customSignals,
      'callbackId': callbackId,
    });
  }

  @override
  void optimize(String flowName, int? maxDelay,
      Map<String, dynamic>? customSignals, ValueSetter<int> onGoodMoment) {
    final callbackId = _getCallbackId(onGoodMoment);
    methodChannel.invokeMethod<void>('optimize', <String, dynamic>{
      'flowName': flowName,
      'maxDelay': maxDelay,
      'customSignals': customSignals,
      'callbackId': callbackId,
    });
  }

  @override
  Future<int> fetchContext(String flowName, int duration,
      Map<String, dynamic>? customSignals) async {
    final contextId =
        await methodChannel.invokeMethod<int>('fetchContext', <String, dynamic>{
      'flowName': flowName,
      'duration': duration,
      'customSignals': customSignals,
    });
    return contextId ?? -1;
  }

  @override
  Future<int> instantContext(String flowName, int duration,
      Map<String, dynamic>? customSignals) async {
    final contextId = await methodChannel
        .invokeMethod<int>('instantContext', <String, dynamic>{
      'flowName': flowName,
      'duration': duration,
      'customSignals': customSignals,
    });
    return contextId ?? -1;
  }

  @override
  Future<int?> recentContext(String flowName) async {
    final contextId =
        await methodChannel.invokeMethod<int>('recentContext', flowName);
    if (contextId == -1) {
      return null;
    }
    return contextId;
  }

  @override
  Future<String> contextValidate(int contextId) async {
    final result =
        await methodChannel.invokeMethod<String>('contextValidate', contextId);
    return result ?? 'Unknown';
  }

  @override
  Future<bool> contextShouldUpsell(int contextId) async {
    final result = await methodChannel.invokeMethod<bool>(
        'contextShouldUpsell', contextId);
    return result ?? true; // Default to true to not break any apps.
  }

  @override
  Future<void> contextLog(int contextId, int outcome, bool alwaysLog) {
    return methodChannel.invokeMethod<void>('contextLog', <String, dynamic>{
      'contextId': contextId,
      'outcome': outcome,
      'alwaysLog': alwaysLog,
    });
  }

  @override
  Future<void> contextAppendOutcomeMetadata(
      int contextId, Map<String, dynamic> metadata) {
    return methodChannel
        .invokeMethod<void>('contextAppendOutcomeMetadata', <String, dynamic>{
      'contextId': contextId,
      'metadata': metadata,
    });
  }

  Future _handleMethodCall(MethodCall call) {
    if (call.method == 'callbackContext') {
      final callbackId = call.arguments['callbackId'] as int;
      final contextId = call.arguments['contextId'] as int;
      final callback = _callbacks.remove(callbackId);
      if (callback != null) {
        callback(contextId);
      }
    }
    return Future.value();
  }
}
