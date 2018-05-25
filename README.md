# Dynatrace React Native Plugin Notes

## For Android
Copy the following files into the project:

* Copy the plugin Java files to: `android/app/src/main/java/com/dynatrace/plugin/`
* Add `Dynatrace.js` and `dynafetch.js` to the project directory (the same directory as `index.android.js`.

If you are using gradle to instrument your app, insert the following into `android/app/build.gradle`:

````
dependencies {
  compile dynatrace.agent()
}
````

Please note that the snippet above applies to gradle version 2.x. If you are using gradle 3.0 and above, use `implementation` instead of `compile`.

If you are using the command line to instrument your app, copy `Dynatrace.jar` from the ADK to `android/app/libs/`.

Modify `android/app/src/main/java/.../MainApplication.java` to load `com.dynatrace.plugin.DynatraceReactPackage`:

```
...
@Override
protected List<ReactPackage> getPackages() {
  return Arrays.<ReactPackage>asList(
    new MainReactPackage(),
    new com.dynatrace.plugin.DynatraceReactPackage());
}
...
```

### Modify the React Native Javascript files

Add the following to `index.android.js`:

```
import Dynatrace from './Dynatrace.js';
import dynafetch from './dynafetch.js';

...
global.dt = new Dynatrace();
```

This instantiates a new `Dynatrace` object and makes it accessible via `global.dt`.

In your code, whenever you want to start a user action:

```
var action = global.dt.enterAction('Touch on Settings');
```

`enterAction()` returns an integer.

When you want to stop the user action:

```
global.dt.leaveAction(action);
```

In order to get visibility of web requests, we have created a wrapper for `fetch()` called `dynafetch()`. All the wrapper does is to create a user action around the `fetch()` call. To make use of the wrapper, just call `dynafetch()` wherever you use `fetch()` in your app.

Here is an example:

```
componentDidMount() {
  return dynafetch(SERVERURL)
    .then((response) => response.json())
    .then((responseJson) => {
      this.setState({
        response: responseJson
      });
    })
    .catch((error) => {
      this.setState({
        error: error.message
      });
    });
}
```

Follow the instructions on [help.dynatrace.com](https://help.dynatrace.com/user-experience-monitoring/mobile-apps/how-do-i-enable-user-experience-monitoring-for-android-apps/) to instrument the Android app.

## For iOS

Copy the following files to `ios/APPNAME` (the same directory as `AppDelegate.h` and `AppDelegate.m`) and add them to the XCode project:

* `Dynatrace.h`
* `DynatraceModule.h`
* `DynatraceModule.m`

Follow the instructions [here](https://www.dynatrace.com/support/doc/appmon/user-experience-management/mobile-uem/how-to-instrument-an-ios-app/ios-manual-setup/) to:

* Add `Dynatrace.framework` from the ADK to Embedded Binaries.
* Add the required frameworks and libraries.
* You can skip the step on setting Other Linker Flags since React Native already sets it.
* Set Strip Style to Debugging Symbols.

Dynatrace uses different keys from App Mon in the `Info.plist`. To get the values for the keys in Dynatrace, create a new mobile application and select Apple iOS. It should show you the values for `DTXAgentEnvironment` and `DTXApplicationID`.

While you're editing `Info.plist`, it may also be a good idea to set the following keys:

* `DTXLogLevel` to `ALL` (note that this only applies to non-production apps - you should use a less verbose setting for production apps)
* `DTXSendEmptyAutoAction` to `YES`

Copy the `Dynatrace.js` and `dynafetch.js` files to the project directory if you haven't already done so.

Continue by following the instructions detailed in the *Modify the React Native Javascript files* section above.
