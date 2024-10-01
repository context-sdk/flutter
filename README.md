# context_sdk

ContextSDK for Flutter

## Supported Platforms

- iOS - 14.0 and higher
- Android - Coming Soon

## Overview

- **Step 1**: Add ContextSDK to your app
- **Step 2**: Track conversion events
- **Step 3**: Ship an App Store update with ContextSDK

## Installation

**Step 1:** Add `context_sdk` to your `pubspec.yaml`

**Step 2:** Ensure minimum Deployment Target

ContextSDK requires a minimum deployment target of iOS 14.0, be sure to update your `ios/Podfile` to specify 14.0 or higher:

```ruby
platform :ios, '14.0'
```

### Activating ContextSDK

After you installed ContextSDK, you need to add your license key. [Register here](https://console.contextsdk.com/register) to get started. Call this on app start.

```dart
import 'package:context_sdk/context_sdk.dart';

final _contextSdkPlugin = ContextSdk();

_contextSdkPlugin.setup("YOUR_LICENSE_KEY_HERE");
```

## Track conversion Events

To get the most use out of ContextSDK make sure to log data for all your upsell prompts. For more details check out the [documentation](https://docs.insights.contextsdk.com/)

```dart
import 'package:context_sdk/context_sdk.dart';

final _contextSdkPlugin = ContextSdk();

// Make sure to call this immediately before showing the prompt to the user.
_contextSdkPlugin.optimize("upsell", null, null, (context) async {
  // Show the upgrade prompt here right after fetching the context
  // Once you know if the user purchased or dismissed the upsell, log the outcome:
  context.log(Outcome.positive);
});
```

## Go Live

Now all that's left is to ship your update to the App Store to start gaining context insights. Continue to the [release page](https://docs.insights.contextsdk.com/release/) for a final check before shipping, as well as other deployment tips.
