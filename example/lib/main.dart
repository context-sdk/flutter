import 'package:context_sdk/real_world_context.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:context_sdk/context_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _sdkVersion = 'Unknown';
  final _contextSdkPlugin = ContextSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _contextSdkPlugin
        .setup(
            "ddf1949adb3751a25c71cb106b4201eaba9960cbc57e814ffd97ce7d381b0e24c07955a4cdd612f90854198ea600bc15939c182f72308159974b88d5107fe310")
        .then((value) => {print("Setup result: $value")});

    _contextSdkPlugin.setGlobalCustomSignals({
      'string': 'string',
      'int': 12,
      'bool': true,
      'float': 1.124
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String sdkVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      sdkVersion =
          await _contextSdkPlugin.getSDKVersion() ?? 'Unknown SDK version';
    } on PlatformException {
      sdkVersion = 'Failed to get SDK version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            Text('ContextSDK: $_sdkVersion\n'),
            ElevatedButton(
                onPressed: () => {
                      _contextSdkPlugin.trackEvent("my-event", {
                        'string': 'string',
                        'int': 12,
                        'bool': true,
                        'float': 1.124
                      })
                    },
                child: const Text('Track Event')),
                ElevatedButton(
                onPressed: () => {
                      _contextSdkPlugin.trackPageView("my-page", {
                        'string': 'string',
                        'int': 13,
                        'bool': true,
                        'float': 1.124
                      })
                    },
                child: const Text('Track Page View')),
                ElevatedButton(
                onPressed: () => {
                      _contextSdkPlugin.trackUserAction("my-action", {
                        'string': 'string',
                        'int': 14,
                        'bool': true,
                        'float': 1.124
                      })
                    },
                child: const Text('Track User Action')),
                ElevatedButton(
                onPressed: () async => {
                       _contextSdkPlugin.calibrate("my_flow", 4, {
                        'string': 'string',
                        'int': 14,
                        'bool': true,
                        'float': 1.124
                      }, (value) async {
                        print("Calibrated context: ${await value.validate()}");
                        value.appendOutcomeMetadata({
                          'string': 'string',
                          'int': 14,
                          'bool': true,
                          'float': 1.124
                        });
                        value.log(Outcome.positive);
                      })
                    },
                child: const Text('Calibrate')),
                ElevatedButton(
                onPressed: () async => {
                       _contextSdkPlugin.optimize("my_flow", 4, {
                        'string': 'string',
                        'int': 14,
                        'bool': true,
                        'float': 1.124
                      }, (value) async {
                        print("Optimized context: ${await value.validate()}");
                        value.appendOutcomeMetadata({
                          'string': 'string',
                          'int': 14,
                          'bool': true,
                          'float': 1.124
                        });
                        value.log(Outcome.positive);
                      })
                    },
                child: const Text('Optimize')),
                ElevatedButton(
                onPressed: () async => {
                       _contextSdkPlugin.fetchContext("my_flow", 4, {
                        'string': 'string',
                        'int': 14,
                        'bool': true,
                        'float': 1.124
                      }).then((value) async {
                        print("Fetch context: ${await value.validate()}");
                        value.appendOutcomeMetadata({
                          'string': 'string',
                          'int': 14,
                          'bool': true,
                          'float': 1.124
                        });
                        value.log(Outcome.positive);
                      })
                    },
                child: const Text('Fetch Context')),
                ElevatedButton(
                onPressed: () async => {
                       _contextSdkPlugin.fetchContext("my_flow", 4, {
                        'string': 'string',
                        'int': 14,
                        'bool': true,
                        'float': 1.124
                      }).then((value) async {
                        print("Instant context: ${await value.validate()}");
                        value.appendOutcomeMetadata({
                          'string': 'string',
                          'int': 14,
                          'bool': true,
                          'float': 1.124
                        });
                        value.log(Outcome.positive);
                      })
                    },
                child: const Text('Instant Context')),
                ElevatedButton(
                onPressed: () async => {
                       _contextSdkPlugin.recentContext("my_flow").then((value) async {
                        print("Recent context: ${await value?.validate() ?? "No Context Found"}");
                      })
                    },
                child: const Text('Recent Context')),
          ],
        )),
      ),
    );
  }
}
