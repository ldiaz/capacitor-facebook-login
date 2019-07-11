import Foundation
import Capacitor
import FacebookCore
import FacebookLogin

@objc(FacebookLogin)
public class FacebookLogin: CAPPlugin {
    private let loginManager = LoginManager()
    
    private let dateFormatter = ISO8601DateFormatter()
    
    override public func load() {
        if #available(iOS 11, *) {
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        } else {
            dateFormatter.formatOptions = [.withInternetDateTime]
        }
        
    }

    private func dateToJS(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    @objc func login(_ call: CAPPluginCall) {
        guard let permissions = call.getArray("permissions", String.self) else {
            call.error("Missing permissions argument")
            return;
        }
        
        let perm = permissions.map { ReadPermission.custom($0) }
        
        DispatchQueue.main.async {
            self.loginManager.logOut()
            self.loginManager.logIn(readPermissions: perm, viewController: self.bridge.viewController) { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                    call.reject("LoginManager.logIn failed", error)
                    
                case .cancelled:
                    print("User cancelled login")
                    call.success()
                    
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("Logged in")
                    return self.getCurrentAccessToken(call)
                }
            }
        }
    }
    
    @objc func logout(_ call: CAPPluginCall) {
        loginManager.logOut()
        
        call.success()
    }
    
    private func accessTokenToJson(_ accessToken: AccessToken) -> [String: Any?] {
        return [
            "applicationId": accessToken.appId,
            /*declinedPermissions: accessToken.declinedPermissions,*/
            "expires": dateToJS(accessToken.expirationDate),
            "lastRefresh": dateToJS(accessToken.refreshDate),
            /*permissions: accessToken.grantedPermissions,*/
            "token": accessToken.authenticationToken,
            "userId": accessToken.userId
        ]
    }
    
    @objc func getCurrentAccessToken(_ call: CAPPluginCall) {
        guard let accessToken = AccessToken.current else {
            call.success()
            return
        }
        
        call.success([ "accessToken": accessTokenToJson(accessToken) ])
    }
}

@objc(FacebookAppEvents)
public class FacebookAppEvents: CAPPlugin {
    @objc func logEvent(_ call: CAPPluginCall) {
        guard let eventName = call.options["name"] as? String else {
            call.reject("Invalid arguments. At least the event name is required")
            return
        }
    
        AppEventsLogger.log(eventName)
        //TODO: add support to more complete method like
        //AppEventsLogger.log(eventName: String, parameters: AppEvent.ParametersDictionary, valueToSum: Double?>, accessToken: AccessToken?)

        call.success()
    }
}



//Reference from cordova-facebook4
/**
 - (void)logEvent:(CDVInvokedUrlCommand *)command {
 if ([command.arguments count] == 0) {
 // Not enough arguments
 CDVPluginResult *res = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Invalid arguments"];
 [self.commandDelegate sendPluginResult:res callbackId:command.callbackId];
 return;
 }
 
 [self.commandDelegate runInBackground:^{
 // For more verbose output on logging uncomment the following:
 // [FBSettings setLoggingBehavior:[NSSet setWithObject:FBLoggingBehaviorAppEvents]];
 NSString *eventName = [command.arguments objectAtIndex:0];
 CDVPluginResult *res;
 NSDictionary *params;
 double value;
 
 if ([command.arguments count] == 1) {
 [FBSDKAppEvents logEvent:eventName];
 
 } else {
 // argument count is not 0 or 1, must be 2 or more
 params = [command.arguments objectAtIndex:1];
 if ([command.arguments count] == 2) {
 // If count is 2 we will just send params
 [FBSDKAppEvents logEvent:eventName parameters:params];
 }
 
 if ([command.arguments count] >= 3) {
 // If count is 3 we will send params and a value to sum
 value = [[command.arguments objectAtIndex:2] doubleValue];
 [FBSDKAppEvents logEvent:eventName valueToSum:value parameters:params];
 }
 }
 res = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
 [self.commandDelegate sendPluginResult:res callbackId:command.callbackId];
 }];
 }
 
 
 
 */
