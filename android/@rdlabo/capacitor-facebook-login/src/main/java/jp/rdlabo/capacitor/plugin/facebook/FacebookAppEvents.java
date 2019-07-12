package jp.rdlabo.capacitor.plugin.facebook;

import android.content.Context;

import com.facebook.appevents.AppEventsConstants;
import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.facebook.appevents.AppEventsLogger;


@NativePlugin()
public class FacebookAppEvents extends Plugin {

    @PluginMethod()
    public void logEvent(PluginCall call) {
        String eventNameString = call.getString("message");

        if ( null == eventNameString || eventNameString.trim().isEmpty() ){
            call.reject("Invalid arguments. At least the event name is required");

            return;
        }

        Context c = getContext();
        AppEventsLogger logger = AppEventsLogger.newLogger(c);

        if (eventNameString.equals("purchased")) {
            //Correct way to log purchased event, but requires amount and other param
            //logger.logPurchase();
            logger.logEvent(AppEventsConstants.EVENT_NAME_PURCHASED);

        } else {
            logger.logEvent(eventNameString);
        }

        call.success();
    }

}