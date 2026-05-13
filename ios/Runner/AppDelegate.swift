import Flutter
import UIKit
import Firebase
import flutter_local_notifications
import PushKit
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {

  private var voipRegistry: PKPushRegistry?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    // Register for VoIP push notifications
    registerForVoIPPushes()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - VoIP Push Registration
  private func registerForVoIPPushes() {
    voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
    voipRegistry?.delegate = self
    voipRegistry?.desiredPushTypes = [.voIP]
  }

  // MARK: - PKPushRegistryDelegate

  // Called when VoIP token is received/updated
  func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
    guard type == .voIP else { return }

    let token = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
    print("VoIP Token: \(token)")

    // Pass VoIP token to Flutter via flutter_callkit_incoming
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
  }

  // Called when VoIP push notification is received
  func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
    guard type == .voIP else {
      completion()
      return
    }

    let data = payload.dictionaryPayload
    print("VoIP Push Received: \(data)")

    // Extract call data from payload and show incoming call UI
    let id = data["uuid"] as? String ?? UUID().uuidString
    let callerName = data["caller_name"] as? String ?? data["customer_name"] as? String ?? "Unknown"
    let handle = data["handle"] as? String ?? ""
    let isVideo = (data["call_type"] as? String) == "video"

    let callKitData = flutter_callkit_incoming.Data(id: id, nameCaller: callerName, handle: handle, type: isVideo ? 1 : 0)
    callKitData.extra = data as NSDictionary
    callKitData.appName = "Mingle Talk"

    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(callKitData, fromPushKit: true)

    completion()
  }

  // Called when VoIP token is invalidated
  func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
    print("VoIP Push Token Invalidated for type: \(type)")
  }
}
