import Flutter
import UIKit
import ContextSDK

public class ContextSdkPlugin: NSObject, FlutterPlugin {
    
    let channel: FlutterMethodChannel
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "context_sdk", binaryMessenger: registrar.messenger())
        let instance = ContextSdkPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getSDKVersion":
            result(ContextManager.sdkVersion())
            break
        case "setup":
            if let licenseKey = call.arguments as? String {
                result(ContextManager.setup(licenseKey))
            } else {
                print("[ContextSDK] Flutter Plugin Error: setup")
                result(false)
            }
            break
        case "trackEvent":
            if let args = call.arguments as? Dictionary<String, Any>,
               let eventType = args["eventType"] as? String,
               let eventName = args["eventName"] as? String,
               let customSignals = args["customSignals"] as? Dictionary<String, Any> {
                
                let customSignalsID = createCustomSignals(customSignals: customSignals)
                switch eventType {
                case "event":
                    contextSDK_trackEvent(eventName, customSignalsID)
                    break
                case "pageView":
                    contextSDK_trackPageView(eventName, customSignalsID)
                    break
                case "userAction":
                    contextSDK_trackUserAction(eventName, customSignalsID)
                    break
                default:
                    print("[ContextSDK] Flutter Plugin Error: Unknown event type \(eventType)")
                    contextSDK_trackEvent(eventName, customSignalsID)
                }
                
                contextSDK_releaseCustomSignals(customSignalsID)
            } else {
                print("[ContextSDK] Flutter Plugin Error: trackEvent")
            }
            
            result(nil)
            break
        case "setGlobalCustomSignals":
            if let customSignals = call.arguments as? Dictionary<String, Any> {
                for (stringKey, value) in customSignals {
                    if let intValue = value as? Int {
                        contextSDK_setGlobalCustomSignalInt(idC: stringKey, value: Int32(intValue))
                    } else if let doubleValue = value as? Double {
                        contextSDK_setGlobalCustomSignalFloat(idC: stringKey, value: Float(doubleValue))
                    } else if let stringValue = value as? String {
                        contextSDK_setGlobalCustomSignalString(idC: stringKey, valueC: stringValue)
                    } else if let boolValue = value as? Bool { // TODO: Bools fall into the Int clause - we should fix this
                        contextSDK_setGlobalCustomSignalBool(idC: stringKey, value: boolValue)
                    } else if value is NSNull {
                        ContextManager.setGlobalCustomSignal(id: stringKey, value: nil)
                    }
                }
            } else {
                print("[ContextSDK] Flutter Plugin Error: setGlobalCustomSignals")
            }
            
            result(nil)
        case "releaseContext":
            if let contextId = call.arguments as? Int32 {
                contextSDK_releaseContext(contextId)
            } else {
                print("[ContextSDK] Flutter Plugin Error: releaseContext")
            }
            result(nil)
            break
        case "calibrate":
            if let args = call.arguments as? Dictionary<String, Any>,
               let flowName = args["flowName"] as? String,
               let callbackId = args["callbackId"] as? Int32 {
                
                let maxDelay = args["maxDelay"] as? Int32 ?? 3
                let customSignals = args["customSignals"] as? Dictionary<String, Any> ?? [:]
                let customSignalsID = createCustomSignals(customSignals: customSignals)
                contextSDK_calibrate_rn(flowName: flowName, customSignalsID: customSignalsID, maxDelay: maxDelay) { contextId in
                    self.channel.invokeMethod("callbackContext", arguments: ["contextId": contextId, "callbackId": callbackId])
                }
            } else {
                print("[ContextSDK] Flutter Plugin Error: calibrate")
            }
            result(nil)
            break
        case "optimize":
            if let args = call.arguments as? Dictionary<String, Any>,
               let flowName = args["flowName"] as? String,
               let callbackId = args["callbackId"] as? Int32 {
                let maxDelay = args["maxDelay"] as? Int ?? 3
                let customSignals = args["customSignals"] as? Dictionary<String, Any> ?? [:]
                let customSignalsID = createCustomSignals(customSignals: customSignals)
                contextSDK_optimize_rn(flowName: flowName, maxDelay: maxDelay, customSignalsID: customSignalsID) { contextId in
                    self.channel.invokeMethod("callbackContext", arguments: ["contextId": contextId, "callbackId": callbackId])
                }
            } else {
                print("[ContextSDK] Flutter Plugin Error: optimize")
            }
            result(nil)
            break
        case "fetchContext":
            if let args = call.arguments as? Dictionary<String, Any>,
               let flowName = args["flowName"] as? String,
               let duration = args["duration"] as? Int32 {
                let customSignals = args["customSignals"] as? Dictionary<String, Any> ?? [:]
                let customSignalsID = createCustomSignals(customSignals: customSignals)
                contextSDK_fetchContext_rn(flowName: flowName, customSignalsID: customSignalsID, duration: duration) { contextId in
                    result(contextId)
                }
            } else {
                print("[ContextSDK] Flutter Plugin Error: fetchContext")
                result(-1)
            }
            break
        case "instantContext":
            if let args = call.arguments as? Dictionary<String, Any>,
               let flowName = args["flowName"] as? String,
               let duration = args["duration"] as? Int32 {
                let customSignals = args["customSignals"] as? Dictionary<String, Any> ?? [:]
                let customSignalsID = createCustomSignals(customSignals: customSignals)
                result(contextSDK_instantContext(flowName, customSignalsID, duration))
            } else {
                print("[ContextSDK] Flutter Plugin Error: instantContext")
                result(-1)
            }
            break
        case "recentContext":
            if let flowName = call.arguments as? String {
                result(contextSDK_recentContext(flowName))
            } else {
                print("[ContextSDK] Flutter Plugin Error: recentContext")
                result(-1)
            }
            break
        case "contextValidate":
            if let contextId = call.arguments as? Int32 {
                let string = contextSDK_context_validate(contextId)
                result(String(cString: string, encoding: .utf8))
            } else {
                print("[ContextSDK] Flutter Plugin Error: contextValidate")
                result("Error")
            }
        case "contextShouldUpsell":
            if let contextId = call.arguments as? Int32 {
                result(contextSDK_context_shouldUpsell(contextId))
            } else {
                print("[ContextSDK] Flutter Plugin Error: contextShouldUpsell")
                result(true)
            }
            break
        case "contextLog":
            if let args = call.arguments as? Dictionary<String, Any>,
               let contextId = args["contextId"] as? Int32,
               let outcome = args["outcome"] as? Int32,
               let alwaysLog = args["alwaysLog"] as? Bool {
                if (alwaysLog) {
                    contextSDK_context_log(contextID: contextId, outcome: outcome)
                } else {
                    contextSDK_context_logIfNotLoggedYet(contextId, outcome)
                }
            } else {
                print("[ContextSDK] Flutter Plugin Error: contextLog")
            }
            
            result(nil)
            break
        case "contextAppendOutcomeMetadata":
            if let args = call.arguments as? Dictionary<String, Any>,
               let contextId = args["contextId"] as? Int32,
               let outcomeMetadata = args["metadata"] as? Dictionary<String, Any> {
                for (stringKey, value) in outcomeMetadata {
                    if let intValue = value as? Int {
                        contextSDK_context_appendOutcomeMetadataInt(contextID: contextId, idC: stringKey, value: Int32(intValue))
                    } else if let doubleValue = value as? Double {
                        contextSDK_context_appendOutcomeMetadataFloat(contextID: contextId, idC: stringKey, value: Float(doubleValue))
                    } else if let stringValue = value as? String {
                        contextSDK_context_appendOutcomeMetadataString(contextID: contextId, idC: stringKey, valueC: stringValue)
                    } else if let boolValue = value as? Bool { // TODO: Bools fall into the Int clause - we should fix this
                        contextSDK_context_appendOutcomeMetadataBool(contextID: contextId, idC: stringKey, value: boolValue)
                    }
                }
            } else {
                print("[ContextSDK] Flutter Plugin Error: contextAppendOutcomeMetadata")
            }
            
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func createCustomSignals(customSignals: Dictionary<String, Any>) -> Int32 {
        let customSignalsID = contextSDK_getNextContextID()
        for (stringKey, value) in customSignals {
            if let intValue = value as? Int {
                contextSDK_context_addCustomSignalInt(contextID: customSignalsID, idC: stringKey, value: Int32(intValue))
            } else if let doubleValue = value as? Double {
                contextSDK_context_addCustomSignalFloat(contextID: customSignalsID, idC: stringKey, value: Float(doubleValue))
            } else if let stringValue = value as? String {
                contextSDK_context_addCustomSignalString(contextID: customSignalsID, idC: stringKey, valueC: stringValue)
            } else if let boolValue = value as? Bool { // TODO: Bools fall into the Int clause - we should fix this
                contextSDK_context_addCustomSignalBool(contextID: customSignalsID, idC: stringKey, value: boolValue)
            }
        }
        return customSignalsID
    }
}
