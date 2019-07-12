package jp.rdlabo.capacitor.plugin.facebook;

import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;


@NativePlugin()
public class FacebookAppEvents extends Plugin {

    @PluginMethod()
    public void logEvent(PluginCall call) {
        String eventNameString = call.getString("message");

        if ( null == eventNameString || eventNameString.trim().isEmpty() ){
            call.reject("Invalid arguments. At least the event name is required");

            return;
        }

        call.success();
    }

    /**
    @objc func logEvent(_ call: CAPPluginCall) {
        guard let eventNameStr = call.options["name"] as? String else {
            call.reject("Invalid arguments. At least the event name is required")
            return
        }
    
        //Uses the string values defined in the official wrapper, it handles if is custom or AppEvent
        let eventName = AppEventName(rawValue: eventNameStr);
        let event = AppEvent(name: eventName!)

        AppEventsLogger.log(event);
        //TODO: add support to more complete method like
        //AppEventsLogger.log(<#T##eventName: String##String#>, parameters: <#T##AppEvent.ParametersDictionary#>, valueToSum: <#T##Double?#>, accessToken: <#T##AccessToken?#>)

        call.success()
    } 
    
    
    * 
     */
}