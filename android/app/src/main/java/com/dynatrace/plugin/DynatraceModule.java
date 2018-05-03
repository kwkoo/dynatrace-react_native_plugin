package com.dynatrace.plugin;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactMethod;

import java.util.Hashtable;

import com.dynatrace.android.agent.Dynatrace;
import com.dynatrace.android.agent.DTXAction;
import com.dynatrace.android.agent.WebRequestTiming;

/**
 * Created by Koo Kin-Wai on 2018-09-08.
 */

public class DynatraceModule extends ReactContextBaseJavaModule {
    private Hashtable<Integer,DTXAction> actions;

    public DynatraceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        actions = new Hashtable<Integer,DTXAction>();
    }

    @Override
    public String getName() {
        return "DynatraceUEM";
    }

    // Expects a key which is generated in JS. This is to circumvent the async callback system.
    //
    @ReactMethod
    public void enterAction(String name, int key) {
        try {
            newAction(name, key, null);
        } catch (Exception e) {}
    }

    @ReactMethod
    public void enterActionWithParent(String name, int key, int parentKey) {
        try {
            newAction(name, key, getAction(parentKey));
        } catch (Exception e) {}
    }

    @ReactMethod
    public void leaveAction(int key) {
        DTXAction action = getAction(key);
        if (action != null) action.leaveAction();
        actions.remove(Integer.valueOf(key));
    }

    @ReactMethod
    public void endVisit() {
        Dynatrace.endVisit();
    }

    @ReactMethod
    public void reportError(String errorName, int errorCode) {
        Dynatrace.reportError(errorName, errorCode);
    }

    @ReactMethod
    public void reportErrorInAction(int key, String errorName, int errorCode) {
        DTXAction action = getAction(key);
        if (action == null) return;
        action.reportError(errorName, errorCode);
    }

    @ReactMethod
    public void reportValue(int key, String valueName, String value) {
        DTXAction action = getAction(key);
        if (action == null) return;
        action.reportValue(valueName, value);
    }

    @ReactMethod
    public void getRequestTag(Promise promise) {
        promise.resolve(Dynatrace.getRequestTagHeader());
    }

    private void newAction(String name, int key, DTXAction parent) throws Exception {
        if (name == null) throw new Exception("action name is null");

        actions.put(Integer.valueOf(key), Dynatrace.enterAction(name, parent));
    }

    private DTXAction getAction(int key) {
        return actions.get(Integer.valueOf(key));
    }
}
