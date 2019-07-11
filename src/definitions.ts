declare module "@capacitor/core" {
  interface PluginRegistry {
    FacebookLogin: FacebookLoginPlugin,
    FacebookAppEvents: FacebookAppEventsPlugin;
  }
}

export interface AccessToken {
  applicationId?: string;
  declinedPermissions?: string[];
  expires?: string;
  isExpired?: boolean;
  lastRefresh?: string;
  permissions?: string[];
  token: string;
  userId?: string;
}

export interface FacebookLoginResponse {
  accessToken: AccessToken | null;
  recentlyGrantedPermissions?: string[];
  recentlyDeniedPermissions?: string[];
}

export interface FacebookCurrentAccessTokenResponse {
  accessToken: AccessToken | null;
}

export interface FacebookLoginPlugin {
  login(options: { permissions: string[] }): Promise<FacebookLoginResponse>;
  logout(): Promise<void>;
  getCurrentAccessToken(): Promise<FacebookCurrentAccessTokenResponse>;
}

export interface FacebookAppEventsPlugin {
    /**
     * Register app events, initial documentation 
     * https://developers.facebook.com/docs/app-events/getting-started-app-events-ios/
     *
     * @param {string}  name Name of the event
     * @param {Object}  [params] An object containing extra data to log with the event
     * @param {number}  [valueToSum] any value to be added to added to a sum on each event
     * @returns {Promise<any>}
     */
    logEvent(name: string, params?: Object, valueToSum?: number): Promise<any>;
}