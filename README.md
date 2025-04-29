# ContextSDK for Flutter

[![pub version](https://img.shields.io/pub/v/context_sdk)](https://pub.dev/packages/context_sdk)
[![Changelog](https://img.shields.io/badge/changelog-latest-blue)](https://docs.contextsdk.com/other/changelog)
[![Documentation](https://img.shields.io/badge/documentation-latest-blue)](https://docs.contextsdk.com/)
[![Issues](https://img.shields.io/github/issues/context-sdk/flutter)](https://github.com/context-sdk/flutter/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/context-sdk/flutter)](https://github.com/context-sdk/flutter/pulls)

ContextSDK is a powerful tool that brings real-world context and insights directly into your Flutter app through on-device signals, empowering you to boost conversions and engagement, enhance user experiences, and reduce churn — all with privacy in mind, as no personally identifiable information (PII) is ever collected.

Our SDK supports iOS and will soon support Android, making it easy to integrate into your cross-platform Flutter projects.

## Getting Started

This repository is dedicated to managing releases of ContextSDK for Flutter, distributed via [pub.dev](https://pub.dev/packages/context_sdk). For other platforms, such as Swift and Android, or alternative installation methods like CocoaPods, please see our [official documentation](https://docs.contextsdk.com/).

To integrate ContextSDK into your Flutter project, follow these steps:

### Installation

1. Add `context_sdk` to your `pubspec.yaml` file:

```yaml
dependencies:
  context_sdk: ^latest_version
```

2. Ensure the minimum deployment target for iOS is set to `14.0` or higher in your `ios/Podfile`:

```ruby
platform :ios, '14.0'
```

### Setup

After installing ContextSDK, initialize it with your license key at app startup. You can [sign up here](https://console.contextsdk.com/register) to receive your license key.

```dart
import 'package:context_sdk/context_sdk.dart';

final _contextSdkPlugin = ContextSdk();

_contextSdkPlugin.setup("YOUR_LICENSE_KEY_HERE");
```

## Using ContextSDK

### Tracking Conversion Events

To maximize the value of ContextSDK, ensure you log data for all upsell prompts or other critical events. Here’s an example:

```dart
import 'package:context_sdk/context_sdk.dart';

final _contextSdkPlugin = ContextSdk();

// Call this immediately before showing the prompt to the user.
_contextSdkPlugin.optimize("upsell", null, null, (context) async {
  // Display the upgrade prompt here after fetching the context
  // Log the outcome after user interaction:
  context.log(Outcome.positive); // or Outcome.negative
});
```

### Going Live

Once integrated, you're ready to ship your app update to the App Store and start leveraging real-world context insights.  Continue to the [release page](https://docs.contextsdk.com/context-decision/release-checklist) for a final check before shipping, as well as other deployment tips.

## Documentation

For detailed setup instructions, usage examples, and advanced usage scenarios, visit our [official documentation](https://docs.contextsdk.com/).

## Not using ContextSDK yet?

If you’re interested in adding real-world context insights to your app, you can [sign up here](https://dashboard.contextsdk.com/register) to receive your license key and access. For more information about how ContextSDK can enhance your app’s user experience, visit our [website](https://contextsdk.com) or reach out to our team at support@contextsdk.com.

## Support

For any questions or technical support, please don’t hesitate to reach out to our team — we’re eager to help!

Thank you for choosing ContextSDK! 🚀 We’re excited to support you in building context-aware experiences for your users.
