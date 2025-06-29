#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint context_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'context_sdk'
  s.version          = '1.1.0'
  s.summary          = 'A Flutter plugin for ContextSDK.'
  s.description      = <<-DESC
A Flutter plugin for ContextSDK.
                       DESC
  s.homepage         = 'https://contextsdk.com/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'ContextSDK' => 'support@contextsdk.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  s.resource_bundles = {'context_sdk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
  s.dependency("ContextSDK", '5.5.0')
end
