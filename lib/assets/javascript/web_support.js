function setupWebViewJavascriptBridge(callback) {
  if (window.WebViewJavascriptBridge) {
      return callback(WebViewJavascriptBridge);
  }
  if (window.WVJSBCallbacks) {
      return window.WVJSBCallbacks.push(callback);
  }
  window.WVJSBCallbacks = [callback];

  //only take effect on iOS
  let WVJSBIframe = document.createElement('iframe');
  WVJSBIframe.style.display = 'none';
  WVJSBIframe.src = 'https://__bridge_loaded__';
  if (document.documentElement) {
      document.documentElement.appendChild(WVJSBIframe);
      setTimeout(function() {
          document.documentElement.removeChild(WVJSBIframe)
      }, 0)
  }
}
  setupWebViewJavascriptBridge(function(bridge) {
      function defaultHandler(data) {
          return new Promise(resolve => {
              let res = 'hello world';
              setTimeout(() => resolve(res), 0);
          });
      }
      bridge.init(defaultHandler);
  });   