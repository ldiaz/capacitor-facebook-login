package jp.rdlabo.capacitor.plugin.facebook;

import android.content.Context;

import com.getcapacitor.NativePlugin;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.facebook.appevents.AppEventsLogger;

import org.json.JSONException;
import org.json.JSONObject;

import java.math.BigDecimal;
import java.util.Currency;


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
            //Default values
            Double amount = 0.0;
            String currency = "USD";

            JSONObject params = call.getObject("params", null);
            if (params != null && params.length() >= 2) { //must contain both params
                try {
                    amount = Double.valueOf( params.getDouble("amount") );
                    currency = params.getString("Currency");
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            //Correct way to log purchased event, but requires amount and other param
            logger.logPurchase(BigDecimal.valueOf(amount), Currency.getInstance(currency));

        } else {
            logger.logEvent(eventNameString);
        }

        call.success();
    }

}