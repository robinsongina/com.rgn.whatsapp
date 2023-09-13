import QtQuick 2.3
import QtWebEngine 1.9
import QtQuick.Layouts 1.0

WebEngineView {
    property string msgDebug: ""
	id: whatsappWebview
	url: "https://web.whatsapp.com"
	settings.javascriptCanAccessClipboard: plasmoid.configuration.allowClipboardAccess
	Layout.fillHeight: true
	Layout.fillWidth: true

	profile: WebEngineProfile {
		id: whatsappProfile
		offTheRecord: false
		httpUserAgent: plasmoid.configuration.userAgent
		httpCacheType: WebEngineProfile.DiskHttpCache
		persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
		userScripts: [
			WebEngineScript {
				injectionPoint: WebEngineScript.DocumentCreation
				name: "helperFunctions"
				worldId: WebEngineScript.MainWorld
				sourceUrl: "./js/helper_functions.js"
			}
		]

		//This signal is emitted whenever there is a newly created user notification. The notification argument holds the WebEngineNotification instance to query data and interact with.
		onPresentNotification: {
			if (!plasmoid.expanded) root.newMessage = true;
			sendNotification(notification.title, notification.message);
		}
		onDownloadRequested: {
			download.accept();
		}
		onDownloadFinished: {
			if(download.state === WebEngineDownloadItem.DownloadCompleted){
				sendNotification("Download Complete", download.downloadFileName)
			}else if (download.state === WebEngineDownloadItem.DownloadInterrupted){
				sendNotification("Download interrupted", download.interruptReasonString)	
			}
		}
	}

	//This signal is emitted when the web site identified by securityOrigin requests to make use of the resource or device identified by feature.
	onFeaturePermissionRequested: {
		if (feature === WebEngineView.Notifications || feature === WebEngineView.MediaAudioCapture) {
			whatsappWebview.grantFeaturePermission(securityOrigin, feature, true)
		}
	}

	//This signal is emitted when request is issued to load a page in a separate web engine view. 
	onNewViewRequested: {
		Qt.openUrlExternally(request.requestedUrl)
	}

	//This signal is emitted when a page load begins, ends, or fails.
	onLoadingChanged:  {
		if(WebEngineView.LoadSucceededStatus === loadRequest.status) {
			whatsappWebview.grantFeaturePermission(url, WebEngineView.Notifications, true)
			whatsappWebview.runJavaScript("document.userScripts.setConfig("+JSON.stringify(plasmoid.configuration)+");");
			if (plasmoid.configuration.matchTheme) {						
				root.osTheme = (isDark(theme.backgroundColor) ? 'dark' : 'light');
				whatsappWebview.runJavaScript("document.userScripts.getTheme();",function(theme) {
					if(theme !== root.osTheme) whatsappWebview.runJavaScript("document.userScripts.setTheme('"+root.osTheme+"');");
				});
			}
		}
	}

    //This signal is emitted when a JavaScript program tries to print a message to the web browser's console.
    onJavaScriptConsoleMessage : if (Qt.application.arguments[0] == "plasmoidviewer") {
    	console.log(msgDebug + message);
    }

	function sendNotification(title, message) {
		let notify = notificationComponent.createObject(parent, {title: title, text: message});
		notify.sendEvent();
	}

	function isDark(color) {
		let luminance = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
		return (luminance < 0.5);
	}
}