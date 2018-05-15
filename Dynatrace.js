'use strict';
/**
 * This exposes the native Dynatrace module as a JS module.
 *
 */
import { NativeModules } from 'react-native';
//module.exports = NativeModules.DynatraceUEM;

export default class Dynatrace {
    constructor() {
        this.counter = 0;
    }
  
    enterAction(name) {
        var key = this.getCounter();
        NativeModules.DynatraceUEM.enterAction(name, key);
        return key;
    }
  
    enterActionWithParent(name, parentKey) {
        var key = this.getCounter();
        NativeModules.DynatraceUEM.enterActionWithParent(name, key, parentKey);
        return key;
    }
  
    reportErrorInAction(key, errorName, errorCode) {
        NativeModules.DynatraceUEM.reportErrorInAction(key, errorName, errorCode);
    }
  
    leaveAction(key) {
        NativeModules.DynatraceUEM.leaveAction(key);
    }
  
    endVisit() {
        NativeModules.DynatraceUEM.endVisit();
    }

    identifyUser(user) {
        NativeModules.DynatraceUEM.identifyUser(user);
    }
  
    getCounter() {
        return this.counter++;
    }
  }