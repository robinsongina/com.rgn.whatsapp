import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtWebEngine 1.9

WebEngineView {
	property string msgDebug: ""
	id: whatsappWebview
	url: "https://web.whatsapp.com"
	settings.javascriptCanAccessClipboard: plasmoid.configuration.allowClipboardAccess
	Layout.fillHeight: true
	Layout.fillWidth: true

	NotificationMsg {
        id: notificationMsg
    }

	NotificationDownload {
		id: notificationDownload
	}

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
				sourceUrl: "../js/helper_functions.js"
			},
			WebEngineScript {
				injectionPoint: WebEngineScript.DocumentReady
				name: "resolveWhatsapp"
				worldId: WebEngineScript.MainWorld
				sourceUrl: "../js/whatsapp.js"
			}
		]

		//This signal is emitted whenever there is a newly created user notification. The notification argument holds the WebEngineNotification instance to query data and interact with.
		onPresentNotification: {
			if (!plasmoid.expanded) root.newMessage = true;
			sendNotification('msg', {
				title: notification.title, 
				text: notification.message, 
				chatId: notification.tag
			});
		}
		onDownloadRequested: {
			download.accept();
		}
		onDownloadFinished: {
			if(download.state === WebEngineDownloadItem.DownloadCompleted){
				sendNotification('download', { 
					title: "Download Complete", 
					text: download.downloadFileName,
					directory: download.downloadDirectory,
					actions: ['Open', 'Folder']
				})
			}else if (download.state === WebEngineDownloadItem.DownloadInterrupted){
				sendNotification('download', {
					title: "Download interrupted", 
					text: download.interruptReasonString
				})	
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
			//Permanently allow notifications
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

	function sendNotification(typeNotification, options ) {
		let notify;
		if(typeNotification === 'msg'){
			notify = notificationMsg.createObject(parent, options);
		}else{
			notify = notificationDownload.createObject(parent, options);
		}
		notify.sendEvent();
	}

	function isDark(color) {
		let luminance = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
		return (luminance < 0.5);
	}
}