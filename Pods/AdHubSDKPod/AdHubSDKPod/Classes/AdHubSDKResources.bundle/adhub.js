/*
 * Copyright © 2017 Hubcloud.com.cn. All rights reserved.
 * AdRequest.java
 * AdHubSDK
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 */
(function () {

    if ((typeof window.adhub) !== "undefined") {
        return;
    }

    // constants
    var DEBUG = false;
    var VERSION_NO = "1.0";
    var ADHUB_PROTOCOL = "adhub:";
    var SDKJS_PROTOCOL = "sdkjs:";
    var WINDOW_NAME_PREFIX = "adhub_";
    var CALL_INIT = "init";
    var CALL_GOTOPAGE ="GotoPage";
    var CALL_SENDMSG = "SendMsg";
    var CALL_CALLNO = "CallNo";
    var CALL_CLOSEPAGE = "ClosePage";
    var CALL_DOWNLOAD = "Download";
    var CALL_MAYDEEPLINK = "MayDeepLink";
    var CALL_DEEPLINK = "DeepLink";
    var CALL_EXTERNALBROWSER = "ExternalBrowser";
    var CALL_INTERNALBROWSER = "InternalBrowser";
    var CALL_RECORDEVENT = "RecordEvent";
    var CALL_DISPATCHAPPEVENT = "DispatchAppEvent";
    var CALL_GETVERSION = "GetVersion";
    var CALL_GETDEVICEID = "GetDeviceID";
    var CALL_READY = "ready";
    var CALL_RESULT = "result";
    var CALL_MRAID = "mraid";
    var MRAID_EVENT_PREFIX = "mraid_";

    var MRAID_STATE = "state";
    var MRAID_PLACEMENT_TYPE = "placementType";
    var MRAID_VIEWABLE = "viewable";
    var MRAID_EXPAND_PROPERTIES = "expandProperties";
    var MRAID_RESIZE_PROPERTIES = "resizeProperties";
    var MRAID_ORIENTATION_PROPERTIES = "orientationProperties";
    var MRAID_SCREEN_SIZE = "screenSize";
    var MRAID_MAX_SIZE = "maxSize";
    var MRAID_DEFAULT_POSITION = "defaultPosition";
    var MRAID_CURRENT_POSITION = "currentPosition";

    // public window variables
    var adhub = window.adhub = {};
    var mraid = null;
    // for ready event
    adhub.ready = false;

    // internal ADHUB variables
    var listeners = []; // event listeners
    var callbacks = []; // function callbacks
    var callbacksCounter = Math.ceil(Math.random() * 1e+10);
    var isIFrame = window !== window.top; // determine the context

    // mraid shell variables
    var mraidProperties = [];
    // supports is an array so handle it separately
    var mraidSupports = [];

    // -----
    // ----- HELPER FUNCTIONS -----
    // -----

    // Pair Object
    adhub.pair = function (first, second) {
        this.first = first;
        this.second = second;
    }

    // Convenient logging with flag
    adhub.anlog = function (message) {
        if (DEBUG) console.log(message);
    }

    // Cross-window communication helper
    adhub.postMessageToTop = function (message) {
        if (typeof message !== "string") {
            return;
        }
        window.top.postMessage(message, "*");
    };

    // Protocol definition
    adhub.constructMessage = function (command, paramsList) {
        var params = "";
        for (var i = 0; i < paramsList.length; i++) {
            var paramToAdd = paramsList[i].first + "=" + paramsList[i].second;
            if (i == 0) {
                params = paramToAdd;
            } else {
                params = params + "&" + paramToAdd;
            }
        }

        return ADHUB_PROTOCOL + command + "?" + params;
    }

    adhub.fireMessage = function (command, paramsList) {
        adhub.postMessageToTop(adhub.constructMessage(command, paramsList));
    };

    // -----
    // ----- INTERNAL SETUP -----
    // -----

    // window event listener to receive messages from SDKJS
    adhub.listener = function (event) {
        // accept all event.origin values, filter based on protocol

        // use anchor element for convenient parsing
        var a = document.createElement("a");
        a.href = event.data;

        if (a.protocol === SDKJS_PROTOCOL) {
            adhub.anlog("ADHUB received: " + event.data);

            // use pathname because host doesn't work
            var path = a.pathname;
            var search = a.search.substr(1); // drop the '?' at the front
            var query = search.split("&");
            var queryParameters = {};
            var length = query.length;
            for (var i = 0; i < length; i++) {
                var values = query[i].split("=");
                queryParameters[values[0]] = decodeURIComponent(values[1]);
            }

            if (path === CALL_READY) {
                adhub.onReadyEvent();
            } else if (path === CALL_RESULT) {
                adhub.onResult(queryParameters);
            } else if (path === CALL_MRAID) {
                adhub.onMraidCall(queryParameters);
            }

        }
    }

    adhub.fireInit = function () {
        adhub.fireMessage(CALL_INIT, [new adhub.pair("name", window.name)]);
    };

    // create mraid shell if necessary
    adhub.setupMraid = function () {
        if (!isIFrame) {
            return;
        }

        adhub.anlog("Creating Mraid shell");
        mraid = window.mraid = {};

        //set default values for properties
        mraidProperties[MRAID_STATE] = "loading";
        mraidProperties[MRAID_PLACEMENT_TYPE] = "inline";
        mraidProperties[MRAID_VIEWABLE] = false;
        mraidProperties[MRAID_EXPAND_PROPERTIES] = {
            width: -1,
            height: -1,
            useCustomClose: false,
            isModal: true
        };
        mraidProperties[MRAID_RESIZE_PROPERTIES] = {
            customClosePosition: 'top-right',
            allowOffscreen: true
        };
        mraidProperties[MRAID_ORIENTATION_PROPERTIES] = {
            allowOrientationChange: true,
            forceOrientation: "none"
        };
        mraidProperties[MRAID_SCREEN_SIZE] = {};
        mraidProperties[MRAID_MAX_SIZE] = {};
        mraidProperties[MRAID_DEFAULT_POSITION] = {};
        mraidProperties[MRAID_CURRENT_POSITION] = {};

        // mraid event listeners

        mraid.addEventListener = function (eventName, method) {
            adhub.addEventListener(MRAID_EVENT_PREFIX + eventName, method);
        }

        mraid.removeEventListener = function (eventName, method) {
            adhub.removeEventListener(MRAID_EVENT_PREFIX + eventName,
                method);
        }

        // mraid methods with return values

        mraid.getVersion = function () {
            return "2.0";
        }

        mraid.getVendor = function () {
            return "adhub";
        }

        mraid.getState = function () {
            return mraidProperties[MRAID_STATE];
        }

        mraid.getPlacementType = function () {
            return mraidProperties[MRAID_PLACEMENT_TYPE];
        }

        mraid.isViewable = function () {
            return mraidProperties[MRAID_VIEWABLE];
        }

        mraid.getExpandProperties = function () {
            return mraidProperties[MRAID_EXPAND_PROPERTIES];
        }

        mraid.getResizeProperties = function () {
            return mraidProperties[MRAID_RESIZE_PROPERTIES];
        }

        mraid.getOrientationProperties = function () {
            return mraidProperties[MRAID_ORIENTATION_PROPERTIES];
        }

        mraid.supports = function (feature) {
            if (typeof mraidSupports[feature] !== "boolean") {
                return false;
            }
            return mraidSupports[feature];
        }

        mraid.getScreenSize = function () {
            return mraidProperties[MRAID_SCREEN_SIZE];
        }

        mraid.getMaxSize = function () {
            return mraidProperties[MRAID_MAX_SIZE];
        }

        mraid.getDefaultPosition = function () {
            return mraidProperties[MRAID_DEFAULT_POSITION];
        }

        mraid.getCurrentPosition = function () {
            return mraidProperties[MRAID_CURRENT_POSITION];
        }

        // mraid methods that need to be forwarded to main

        mraid.forward = function (method, args) {
            var paramsList = [new adhub.pair("method", method)];
            var length = args.length;

            for (var i = 0; i < length; i++) {
                paramsList.push(new adhub.pair("p" + i, encodeURIComponent(
                    JSON.stringify(args[i]))));
            }

            adhub.fireMessage(CALL_MRAID, paramsList);
        }

        mraid.open = function () {
            mraid.forward("open", arguments);
        }

        mraid.close = function () {
            mraid.forward("close", arguments);
        }

        mraid.expand = function () {
            mraid.forward("expand", arguments);
        }

        mraid.setExpandProperties = function () {
            mraid.forward("setExpandProperties", arguments);
        }

        mraid.resize = function () {
            mraid.forward("resize", arguments);
        }

        mraid.setResizeProperties = function () {
            mraid.forward("setResizeProperties", arguments);
        }

        mraid.setOrientationProperties = function () {
            mraid.forward("setOrientationProperties", arguments);
        }

        mraid.createCalendarEvent = function (event) {
            mraid.forward("createCalendarEvent", arguments);
        }

        mraid.playVideo = function (uri) {
            mraid.forward("playVideo", arguments);
        }

        mraid.storePicture = function (uri) {
            mraid.forward("storePicture", arguments);
        }

        mraid.useCustomClose = function (value) {
            mraid.forward("useCustomClose", arguments);
        }

        mraid.enable = function () {
            mraid.forward("enable", arguments);
        }

        mraid.enable();
    }

    // Initial setup on first load on adhub.js
    adhub.setup = function () {
        adhub.setupMraid();

        // if the window doesn't have a name, give a unique name
        if (typeof window.name !== "string" || window.name === "") {
            var time = new Date().getTime();
            window.name = WINDOW_NAME_PREFIX + time;
        }

        // register a window listener
        if (window.addEventListener) {
            window.addEventListener("message", adhub.listener, false);
        } else {
            window.attachEvent("onmessage", adhub.listener);
        }

        adhub.anlog("ADHUB instance created: name(" + window.name +
            "), counter(" + callbacksCounter + "), IFrame(" + isIFrame +
            ")");

        // register this window in SDKJS
        adhub.fireInit();
    }

    // call setup()
     setTimeout(adhub.setup, 0);

    // -----
    // ----- INTERNAL API UTILITY FUNCTIONS -----
    // -----

    adhub.fireEvent = function (eventName) {
        var eventListeners = listeners[eventName];
        if (eventListeners) {
            var args = Array.prototype.slice.call(arguments);
            args.shift();
            var length = eventListeners.length;
            for (var i = 0; i < length; i++) {
                if ((typeof eventListeners[i]) === "function") {
                    eventListeners[i].apply(null, args);
                }
            }
        }
    }

    adhub.onReadyEvent = function () {
        // only fire the ready event once
        if (!adhub.ready) {
            adhub.ready = true;
            adhub.fireEvent(CALL_READY);
        }
    }

    adhub.onResult = function (queryParameters) {
        var cb = -1;
        if (queryParameters.cb) {
            cb = parseInt(queryParameters.cb);
        }

        // remove the cb param
        queryParameters.cb = null;
        if ((cb > -1) && (typeof callbacks[cb] === "function")) {
            // invoke the callback, then release it
            callbacks[cb](queryParameters);
            callbacks[cb] = null;
        }
    }

    adhub.onMraidCall = function (params) {
        // forward all mraid events to adhub-mraid listeners
        if (params.event) {
            adhub.fireEvent(MRAID_EVENT_PREFIX + params.event, params.p0,
                params.p1);
            return;
        } else if (params.method) {
            if (params.method === "updateProperty") {
                mraidProperties[params.propertyName] = JSON.parse(
                    decodeURIComponent(params.value));
            } else if (params.method === "updateSupports") {
                mraidSupports[params.feature] = params.value;
            }
        }

    }

    adhub.addCallback = function (callback) {
        callbacksCounter++;
        callbacks[callbacksCounter] = callback;
    }

    adhub.validateInt = function(n) {
      return ((typeof n) === "number");
    }

    adhub.validateString = function (s) {
        return (s && ((typeof s) === "string"));
    }

    adhub.validateHttpString = function (url) {
        return (((typeof url) === "string")
            && (url.lastIndexOf("http", 0) === 0));
    }

    // -----
    // ----- PUBLIC API FUNCTIONS -----
    // -----

    adhub.addEventListener = function (eventName, method) {
        adhub.anlog("adding listener on " + eventName + " for method: " +
            method)

        listeners[eventName] = listeners[eventName] || [];

        var length = listeners[eventName].length;
        for (var i = 0; i < length; i++) {
            if (listeners[eventName][i] == method) {
                adhub.anlog("Already added");
                return;
            }
        }

        listeners[eventName].push(method);
    }

    adhub.removeEventListener = function (eventName, method) {
        adhub.anlog("remove listener on " + eventName + " for method: " +
            method)
        var eventListeners = listeners[eventName];
        if (eventListeners) {
            var index = eventListeners.indexOf(method);
            if (index > -1) {
                eventListeners[index] = null;
            }
        }
    }

    // required: index, callback
    adhub.toNext = function (index, callback) {
        callback = callback || function(result) { console.log(result) };
        if (typeof callback !== "function") {
            adhub.anlog("GotoPage error: callback parameter should be a function");
            return;
        }
        adhub.addCallback(callback);

        if (!adhub.validateInt(index)) {
            adhub.anlog("GotoPage error: index should be a number");
            // call the callback function for failure
            var failureResult = {};
            failureResult.caller = CALL_GOTOPAGE;
            failureResult.cb = callbacksCounter;
            failureResult.success = false;
            adhub.onResult(failureResult);
            return;
        }

        adhub.fireMessage(CALL_GOTOPAGE, [new adhub.pair(
            "cb", callbacksCounter), new adhub.pair("index",
            index)]);
    }

    // required: receiver, msg, callback
    adhub.sendShortMessage = function (receiver, msg, callback) {
        callback = callback || function(result) { console.log(result) };
        if (typeof callback !== "function") {
            adhub.anlog("SendMsg error: callback parameter should be a function");
            return;
        }
        adhub.addCallback(callback);

        if (!adhub.validateString(receiver) || adhub.validateString(msg)) {
            adhub.anlog("SendMsg error: receiver and msg should be a string");
            // call the callback function for failure
            var failureResult = {};
            failureResult.caller = CALL_SENDMSG;
            failureResult.cb = callbacksCounter;
            failureResult.success = false;
            adhub.onResult(failureResult);
            return;
        }

        adhub.fireMessage(CALL_SENDMSG, [new adhub.pair(
            "cb", callbacksCounter), new adhub.pair("receiver",
            encodeURIComponent(receiver), new adhub.pair("msg",
            encodeURIComponent(msg)))]);
    }

    // required: receiver, callback
    adhub.makeCall = function (receiver, callback) {
        callback = callback || function(result) { console.log(result) };
        if (typeof callback !== "function") {
            adhub.anlog("CallNo error: callback parameter should be a function");
            return;
        }
        adhub.addCallback(callback);

        if (!adhub.validateString(receiver)) {
            adhub.anlog("CallNo error: receiver should be a string");
            // call the callback function for failure
            var failureResult = {};
            failureResult.caller = CALL_CALLNO;
            failureResult.cb = callbacksCounter;
            failureResult.success = false;
            adhub.onResult(failureResult);
            return;
        }

        adhub.fireMessage(CALL_CALLNO, [new adhub.pair(
            "cb", callbacksCounter), new adhub.pair("receiver",
            encodeURIComponent(receiver))]);
    }

    // required: callback
    adhub.shutdown = function (callback) {
        callback = callback || function(result) { console.log(result) };
        if (typeof callback !== "function") {
            adhub.anlog("CallNo error: callback parameter should be a function");
            return;
        }
        adhub.addCallback(callback);

        adhub.fireMessage(CALL_CLOSEPAGE, [new adhub.pair(
            "cb", callbacksCounter)]);
    }

    // Alias for adhub.ExternalBrowser
    // required: url
    adhub.openurl = function(url) {
        adhub.ExternalBrowser(url);
    }

    // required: url, callback
    adhub.download = function(url, callback) {
        callback = callback || function(result) { console.log(result) };
        if (typeof callback !== "function") {
            adhub.anlog("Download error: callback parameter should be a function");
            return;
        }
        adhub.addCallback(callback);

        if (!adhub.validateString(url)) {
            adhub.anlog("Download error: url should be a string");
            // call the callback function for failure
            var failureResult = {};
            failureResult.caller = CALL_DOWNLOAD;
            failureResult.cb = callbacksCounter;
            failureResult.mayDeepLink = false;
            adhub.onResult(failureResult);
            return;
        }

        adhub.fireMessage(CALL_DOWNLOAD, [new adhub.pair(
            "cb", callbacksCounter), new adhub.pair("url",
            encodeURIComponent(url))]);
    }

    // required: url, callback
    adhub.MayDeepLink = function (url, callback) {
        if (typeof callback !== "function") {
            adhub.anlog("MayDeepLink error: callback parameter should be a function");
            return;
        }
        adhub.addCallback(callback);

        if (!adhub.validateString(url)) {
            adhub.anlog("MayDeepLink error: url should be a string");
            // call the callback function for failure
            var failureResult = {};
            failureResult.caller = CALL_MAYDEEPLINK;
            failureResult.cb = callbacksCounter;
            failureResult.mayDeepLink = false;
            adhub.onResult(failureResult);
            return;
        }

        adhub.fireMessage(CALL_MAYDEEPLINK, [new adhub.pair(
            "cb", callbacksCounter), new adhub.pair("url",
            encodeURIComponent(url))]);
    }

    // required: url, optional: callback
    adhub.DeepLink = function (url, callback) {
        var index = -1;
        if (typeof callback === "function") {
            adhub.addCallback(callback);
            index = callbacksCounter;
        }

        if (!adhub.validateString(url)) {
            adhub.anlog("DeepLink error: url should be a string");
            // call the callback function for failure
            if (index > -1) {
                var failureResult = {};
                failureResult.caller = CALL_DEEPLINK;
                failureResult.cb = callbacksCounter;
                adhub.onResult(failureResult);
            }
            return;
        }

        adhub.fireMessage(CALL_DEEPLINK, [new adhub.pair(
            "cb", index), new adhub.pair("url",
            encodeURIComponent(url))]);
    }

    // required: url
    adhub.ExternalBrowser = function (url) {
        if (!adhub.validateHttpString(url)) {
            adhub.anlog("ExternalBrowser error: url should be a string");
            return;
        }

        adhub.fireMessage(CALL_EXTERNALBROWSER, [new adhub.pair("url",
            encodeURIComponent(url))]);
    }

    // required: url
    adhub.InternalBrowser = function (url) {
        if (!adhub.validateHttpString(url)) {
            adhub.anlog("InternalBrowser error: url should be a string");
            return;
        }

        adhub.fireMessage(CALL_INTERNALBROWSER, [new adhub.pair("url",
            encodeURIComponent(url))]);
    }

    // required: url
    adhub.RecordEvent = function (url) {
        if (!adhub.validateHttpString(url)) {
            adhub.anlog("RecordEvent error: url should be a string");
            return;
        }

        adhub.fireMessage(CALL_RECORDEVENT, [new adhub.pair("url",
            encodeURIComponent(url))]);
    }

    // required: at least one of event or data must be a non-empty string
    adhub.DispatchAppEvent = function (event, data) {
        // if not valid strings, set the parameters to empty string
        if (!adhub.validateString(event)) {
            event = "";
        }
        if (!adhub.validateString(data)) {
            data = "";
        }

        // validate that at least one is valid
        if (!event && !data) {
            adhub.anlog("DispatchAppEvent error: at least one of event or data must be a non-empty string");
            return;
        }

        adhub.fireMessage(CALL_DISPATCHAPPEVENT, [new adhub.pair(
            "event", event), new adhub.pair("data", data)]);
    }

    // required: callback
    adhub.GetVersion = function (callback) {
        if (typeof callback !== "function") {
            adhub.anlog("GetVersion error: callback parameter should be a function");
            return;
        }
        adhub.addCallback(callback);

        // call the callback function with version number
        var result = {};
        result.caller = CALL_GETVERSION;
        result.cb = callbacksCounter;
        result.version = VERSION_NO;
        adhub.onResult(result);
    }

    // required: callback
    adhub.GetDeviceID = function (callback) {
        if (typeof callback !== "function") {
            adhub.anlog("GetDeviceID error: callback parameter should be a function");
            return;
        }
        adhub.addCallback(callback);

        adhub.fireMessage(CALL_GETDEVICEID, [new adhub.pair(
            "cb", callbacksCounter)]);
    }

}());
