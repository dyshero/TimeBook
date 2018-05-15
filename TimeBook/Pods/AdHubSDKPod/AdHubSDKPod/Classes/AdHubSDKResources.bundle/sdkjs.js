/*
 * Copyright © 2016 Hubcloud.com.cn. All rights reserved.
 * AdRequest.java
 * AdHubSDK
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 */
(function () {

    if ((typeof window.sdkjs) !== "undefined") {
        return;
    }

    // constants
    var DEBUG = false;
    var NATIVE_CALL_PREFIX = "adhub://";
    var ADHUBSDK_PROTOCOL = "adhub:";
    var SDKJS_PROTOCOL = "sdkjs:";
    var CALL_INIT = "init";
    var CALL_GOTOPAGE ="GotoPage";
    var CALL_SENDMSG = "SendMsg";
    var CALL_CALLNO = "CallNo";
    var CALL_CLOSEPAGE = "ClosePage";
    var CALL_DOWNLOAD = 'Download';
    var CALL_MAYDEEPLINK = "MayDeepLink";
    var CALL_DEEPLINK = "DeepLink";
    var CALL_EXTERNALBROWSER = "ExternalBrowser";
    var CALL_INTERNALBROWSER = "InternalBrowser";
    var CALL_RECORDEVENT = "RecordEvent";
    var CALL_DISPATCHAPPEVENT = "DispatchAppEvent";
    var CALL_GETDEVICEID = "GetDeviceID";
    var CALL_READY = "ready";
    var CALL_RESULT = "result";
    var CALL_MRAID = "mraid";
    var CALL_PING = "Ping";

    // public window variable to be invoked by mraid.js
    var sdkjs = window.sdkjs = {};
    sdkjs.client = {};

    // internal SDKJS variables
    var adhubsdkFrames = [];
    var nativeCallQueue = [];

    sdkjs.anlog = function (message) {
        if (DEBUG) {
            console.log(message);
        }
    }

    // window event listener to receive messages from SDKJS
    sdkjs.listener = function (event) {
        // accept all event.origin values, filter based on protocol
        // use anchor element for convenient parsing
        var a = document.createElement("a");
        a.href = event.data;

        if (a.protocol === ADHUBSDK_PROTOCOL) {
            // use pathname because host doesn't work
            var path = a.pathname;

            // parameters
            var search = a.search.substr(1); // drop the '?' at the front
            var query = search.split("&");
            var queryParameters = {};
            for (var i = 0; i < query.length; i++) {
                var values = query[i].split("=");
                queryParameters[values[0]] = values[1];
            }

            // commands handler
            sdkjs.anlog("SDKJS received: call(" + path + ") params:(" +
                JSON.stringify(queryParameters) + ")");

            if (path === CALL_INIT) {
                sdkjs.callInit(queryParameters);
            } else if (path === CALL_GOTOPAGE) {
                sdkjs.callGotoPage(queryParameters);
            } else if (path === CALL_SENDMSG) {
                sdkjs.callSendMsg(queryParameters);
            } else if (path === CALL_CALLNO) {
                sdkjs.callCallNo(queryParameters);
            } else if (path === CALL_CLOSEPAGE) {
                sdkjs.callClosePage(queryParameters);
            } else if (path === CALL_DOWNLOAD) {
                sdkjs.callDownload(queryParameters);
            } else if (path === CALL_MAYDEEPLINK) {
                sdkjs.callMayDeepLink(queryParameters);
            } else if (path === CALL_DEEPLINK) {
                sdkjs.callDeepLink(queryParameters);
            } else if (path === CALL_EXTERNALBROWSER) {
                sdkjs.callExternalBrowser(queryParameters);
            } else if (path === CALL_INTERNALBROWSER) {
                sdkjs.callInternalBrowser(queryParameters);
            } else if (path === CALL_RECORDEVENT) {
                sdkjs.callRecordEvent(queryParameters);
            } else if (path === CALL_DISPATCHAPPEVENT) {
                sdkjs.callDispatchAppEvent(queryParameters);
            } else if (path === CALL_GETDEVICEID) {
                sdkjs.callGetDeviceID(queryParameters);
            } else if (path === CALL_MRAID) {
                sdkjs.callMraid(queryParameters);
            } else if (path === CALL_PING) {
                /* An iframe can send a post message directly to the top window
                 * in order to be sure to be inside the AppNexus SDK context (without injecting adhub.js):
                 *
                 * window.top.postMessage('adhub:Ping?cb=toto', '*');
                 *
                 * The SDK will anwser a message like 'sdkjs:result?caller=Ping&answer=1&cb=toto'
                 * The iframe needs a listener:
                 * window.addEventListener("message", function(_e) { if(_e.data === 'sdkjs:result?caller=Ping&answer=1&cb=toto') { console.log('Ping received'); } else { console.log('other event: ' + _e.data); } } );
                 */
                var queryStringParameters = 'caller=' + CALL_PING + '&answer=1&cb=' + queryParameters.cb;
                sdkjs.sendPingAnswer(queryStringParameters, event);
            }
        }
    }

    sdkjs.setup = function () {
        if (window.addEventListener) {
            window.addEventListener("message", sdkjs.listener, false);
        } else {
            window.attachEvent("onmessage", sdkjs.listener);
        }
    }

    sdkjs.setup();

    sdkjs.postMessageToFrames = function (message) {
        for (var i = 0; i < adhubsdkFrames.length; i++) {
            try {
                adhub.anlog("Dispatching message to window name " + adhubsdkFrames[i].name);
            } catch(e) {
                // In Cross Domain communication, the window's name is not available
                adhub.anlog("Dispatching message to a cross domain window");
            }
            adhubsdkFrames[i].postMessage(message, "*");
        }
    }

    sdkjs.fireMessage = function (call, params) {
        params = params || "";
        sdkjs.postMessageToFrames(SDKJS_PROTOCOL + call + "?" + params);
    }

    sdkjs.callInit = function (queryParameters) {
        var name = queryParameters.name;
        var w = window.open("", name, null, false);
        adhubsdkFrames.push(w);
        sdkjs.fireMessage(CALL_READY);
    }

    // It sends a ping answer to the window which sends the ping initially
    sdkjs.sendPingAnswer = function (queryStringParameters, event) {
        try{
            event.source.postMessage( SDKJS_PROTOCOL + CALL_RESULT + "?" + queryStringParameters, "*");
        } catch(_e) {
            sdkjs.anlog("SDKJS can't send properly ping answer to sub window: " + _e);
        }
    }

    sdkjs.dequeue = function () {
        window.location = nativeCallQueue.shift();
        if (nativeCallQueue.length > 0) {
            setTimeout(sdkjs.dequeue, 0);
        }
    }

    sdkjs.makeNativeCall = function (uri) {
        sdkjs.makeNativeCallWithPrefix(NATIVE_CALL_PREFIX, uri);
    }

    sdkjs.makeNativeCallWithPrefix = function (prefix, uri) {
        nativeCallQueue.push(prefix + uri);
        if (nativeCallQueue.length == 1) {
            setTimeout(sdkjs.dequeue, 0);
        }
    }

    sdkjs.callGotoPage = function (queryParameters) {
        var cb = queryParameters.cb;
        var index = queryParameters.index;

        sdkjs.makeNativeCall("GotoPage?cb=" + cb + "&index=" + index);
    }

    sdkjs.callSendMsg = function (queryParameters) {
        var cb = queryParameters.cb;
        var msg = queryParameters.msg;
        var receiver = queryParameters.receiver;

        sdkjs.makeNativeCall("SendMsg?cb=" + cb + "&msg=" + msg + "&receiver=" + receiver);
    }

    sdkjs.callCallNo = function (queryParameters) {
        var cb = queryParameters.cb;
        var receiver = queryParameters.receiver;

        sdkjs.makeNativeCall("CallNo?cb=" + cb + "&receiver=" + receiver);
    }

    sdkjs.callClosePage = function (queryParameters) {
        var cb = queryParameters.cb;

        sdkjs.makeNativeCall("ClosePage?cb=" + cb);
    }

    sdkjs.callDownload = function(queryParameters) {
        var cb = queryParameters.cb;
        var url = queryParameters.url;

        sdkjs.makeNativeCall("Download?cb=" + cb + "&url=" + url);
    }

    sdkjs.callMayDeepLink = function (queryParameters) {
        var cb = queryParameters.cb;
        var url = queryParameters.url;

        sdkjs.makeNativeCall("MayDeepLink?cb=" + cb + "&url=" + url);
    }

    sdkjs.callDeepLink = function (queryParameters) {
        var cb = queryParameters.cb;
        var url = queryParameters.url;

        sdkjs.makeNativeCall("DeepLink?cb=" + cb + "&url=" + url);
    }

    sdkjs.callExternalBrowser = function (queryParameters) {
        var url = queryParameters.url;

        sdkjs.makeNativeCall("ExternalBrowser?url=" + url);
    }

    sdkjs.callInternalBrowser = function (queryParameters) {
        var url = queryParameters.url;

        sdkjs.makeNativeCall("InternalBrowser?url=" + url);
    }

    sdkjs.callRecordEvent = function (queryParameters) {
        var url = queryParameters.url;

        sdkjs.makeNativeCall("RecordEvent?url=" + url);
    }

    sdkjs.callDispatchAppEvent = function (queryParameters) {
        var event = queryParameters.event;
        var data = queryParameters.data;

        sdkjs.makeNativeCall("DispatchAppEvent?event=" + event + "&data=" +
            data);
    }

    sdkjs.callGetDeviceID = function (queryParameters) {
        var cb = queryParameters.cb;

        sdkjs.makeNativeCall("GetDeviceID?cb=" + cb);
    }

    sdkjs.callMraid = function (queryParameters) {
        var key = "p0";
        var count = 0;
        var args = [];

        while ((typeof queryParameters[key]) !== "undefined") {
            args.push(JSON.parse(decodeURIComponent(queryParameters[key])));
            count++;
            key = "p" + count;
        }

        if ((typeof mraid) !== "undefined") {
            mraid[queryParameters.method].apply(mraid, args);
        }
    }

    sdkjs.client.result = function (params) {
        sdkjs.fireMessage(CALL_RESULT, params);
    }

    sdkjs.mraidEventHandler = function (eventName) {
        // mraid events have at most two parameters in the callback
        // pass undefined if not present; adhub should handle
        this.call = function (p0, p1) {
            sdkjs.fireMessage(CALL_MRAID, "event=" + eventName + "&p0=" +
                p0 + "&p1=" + p1);
        };
    }

    sdkjs.mraidReadyEventHandler = new sdkjs.mraidEventHandler("ready");
    sdkjs.mraidErrorEventHandler = new sdkjs.mraidEventHandler("error");
    sdkjs.mraidStateChangeEventHandler = new sdkjs.mraidEventHandler(
        "stateChange");
    sdkjs.mraidViewableChangeEventHandler = new sdkjs.mraidEventHandler(
        "viewableChange");
    sdkjs.mraidSizeChangeEventHandler = new sdkjs.mraidEventHandler(
        "sizeChange");

    if ((typeof mraid) !== "undefined") {
        // add mraid event listeners to pass to adhub
        mraid.addEventListener("ready", sdkjs.mraidReadyEventHandler.call);
        mraid.addEventListener("error", sdkjs.mraidErrorEventHandler.call);
        mraid.addEventListener("stateChange", sdkjs.mraidStateChangeEventHandler
            .call);
        mraid.addEventListener("viewableChange",
            sdkjs.mraidViewableChangeEventHandler.call);
        mraid.addEventListener("sizeChange", sdkjs.mraidSizeChangeEventHandler
            .call);
    }

    sdkjs.mraidUpdateProperty = function (propertyName, value) {
        sdkjs.fireMessage(CALL_MRAID, "method=updateProperty&propertyName=" +
            propertyName + "&value=" + encodeURIComponent(JSON.stringify(
                value)));
    }

    sdkjs.mraidUpdateSupports = function (feature, value) {
        sdkjs.fireMessage(CALL_MRAID, "method=updateSupports&feature=" +
            feature + "&value=" + value);
    }

}());
