/*
*    SPDX-FileCopyrightText: %{CURRENT_YEAR} %{AUTHOR} <%{EMAIL}>
*    SPDX-License-Identifier: LGPL-2.1-or-later
*/

import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.notification 1.0
import QtWebEngine 1.9

Item {
	id: root
	property bool themeMismatch: false;
	property bool newMessage: false;
	property int nextReloadTime: 0;
	property int reloadRetries: 0;
	property string osTheme: '';

	//Notifications
	Component {
		id: notificationComponent
		Notification {
			componentName: "plasma_workspace"
			eventId: "notification"
			iconName: Qt.resolvedUrl("./assets/logo.png");
			autoDelete: true
			defaultAction: "Default Action"
			onDefaultActivated: {
				console.log("Default action activated.");
				if (!plasmoid.expanded){
					plasmoid.expanded = !plasmoid.expanded;
					root.newMessage = false;
				} 
			}
			//urgency: Notification.HighUrgency-
			// replyAction {
			// 	label: "Reply"
			// 	placeholderText: "Reply to Dr Konqi..."
			// 	submitButtonText: "Send Reply"
			// 	submitButtonIconName: "mail-reply-all"
			// 	onReplied: console.log(text)
			// }
		}
	}

	Plasmoid.compactRepresentation: Item {
		anchors.fill: parent
		PlasmaCore.SvgItem {
			anchors.centerIn: parent
			width: parent.width < parent.height ? parent.width : parent.height
			height: width

			svg: PlasmaCore.Svg {
				imagePath: root.newMessage ? Qt.resolvedUrl("assets/logo-badge.svg") : Qt.resolvedUrl("assets/logo.svg");
			}

			MouseArea {
				anchors.fill: parent
				onClicked: {
					plasmoid.expanded = !plasmoid.expanded
					if (root.newMessage) {
						root.newMessage = false;
					}
				}
			}
		}
	}
	
	Plasmoid.fullRepresentation: ColumnLayout {
		Layout.minimumWidth: 256 * PlasmaCore.Units.devicePixelRatio
		Layout.minimumHeight:  512 * PlasmaCore.Units.devicePixelRatio
		Layout.preferredWidth: 1600 * PlasmaCore.Units.devicePixelRatio
		Layout.preferredHeight: 930 * PlasmaCore.Units.devicePixelRatio

		//-----------------------------  Helpers ------------------
		Connections {
			target: plasmoid
			// function onActivated() {
			// 	console.log("Plasmoid revealed to user")
			// }
			// function onStatusChanged() {
			// 	console.log("Plasmoid status changed "+plasmoid.status)
			// }
			// function hideOnWindowDeactivateChanged() {
			// 	console.log("Plasmoid hideOnWindowDeactivateChanged changed")
			// }
			function onExpandedChanged() {
				if(whatsappWebview && whatsappWebviewDual && plasmoid.expanded) {
					if(whatsappWebview.LoadStatus == WebEngineView.LoadFailedStatus) whatsappWebview.reload();
					if(plasmoid.configuration.dualWhatsapp && whatsappWebviewDual.LoadStatus == WebEngineView.LoadFailedStatus) whatsappWebviewDual.reload()
				}
				// if(!plasmoid.expanded && root.themeMismatch && plasmoid.configuration.matchTheme ) {
				// 	console.log("Entre 2")
				// 	root.themeMismatch = false;
				// 	whatsappWebview.reloadAndBypassCache();
				// }
				console.log("Plasmoid onExpandedChanged: "+plasmoid.expanded )
			}
		}

		//------------------------------------- UI -----------------------------------------
		anchors.fill: parent
		Column {
			anchors {
				right: parent.right;
				left: parent.left;
				top: parent.top;
			}
			height: 24 * PlasmaCore.Units.devicePixelRatio
			spacing: 2 * PlasmaCore.Units.devicePixelRatio

			Row {
				anchors {
					right: pinButton.left;
					left: parent.left;
					top: parent.top;
					bottom: parent.bottom
				}
				spacing: 2 * PlasmaCore.Units.devicePixelRatio
				PlasmaCore.SvgItem {
					height:parent.height
					width:height
					svg: PlasmaCore.Svg {
						imagePath: Qt.resolvedUrl("./assets/logo.svg");
					}
				}
			}
      		Row {
				anchors {
					right: parent.right;
					top: parent.top;
				}
				spacing: 2 * PlasmaCore.Units.devicePixelRatio
				PlasmaComponents.ToolButton {
					id:pinButton
					height:24 * PlasmaCore.Units.devicePixelRatio
					width:height
					checkable: true
					tooltip: i18n("Pin window")
					iconSource: "window-pin"
					checked: plasmoid.configuration.pin
					onCheckedChanged: plasmoid.configuration.pin = checked
				}
				PlasmaComponents.ToolButton {
					id: pinbutton
					height: 24 * PlasmaCore.Units.devicePixelRatio
					width: height
					tooltip: i18n("Reload whatsapp")
					iconSource: "view-refresh"
					onClicked: {
						whatsappWebview.reload();
						if(plasmoid.configuration.dualWhatsapp) whatsappWebviewDual.reload();
					}
				}
				PlasmaComponents.ToolButton {
					height: 24 * PlasmaCore.Units.devicePixelRatio
					width: height
					tooltip: i18n("Debug console whatsapp")
					visible: Qt.application.arguments[0] == "plasmoidviewer" || plasmoid.configuration.debugConsole
					enabled:visible
					iconSource: "debug-step-over"
					onClicked: {
						whatsappWebViewInspector.visible = !whatsappWebViewInspector.visible;
						whatsappWebViewInspector.enabled = visible || whatsappWebViewInspector.visible
					}
				}
				PlasmaComponents.ToolButton {
					height: 24 * PlasmaCore.Units.devicePixelRatio
					width: height
					tooltip: i18n("Debug console whatsapp dual")
					visible: plasmoid.configuration.dualWhatsapp && (Qt.application.arguments[0] == "plasmoidviewer" || plasmoid.configuration.debugConsole)
					enabled: visible
					iconSource: "debug-step-out"
					onClicked: {
						whatsappWebViewDualInspector.visible = !whatsappWebViewDualInspector.visible;
						whatsappWebViewDualInspector.enabled = visible || whatsappWebViewDualInspector.visible
					}
				}
   			}

			//-------------------- Connections  -----------------------
			Binding {
				target: plasmoid
				property: "hideOnWindowDeactivate"
				value: !plasmoid.configuration.pin
			}
		}
		RowLayout {
			Layout.fillHeight:true
			Layout.fillWidth:true
			WebEngineView {
				id: whatsappWebview
				url:"https://web.whatsapp.com"
				focus: true
				settings.javascriptCanAccessClipboard: plasmoid.configuration.allowClipboardAccess
				Layout.fillHeight:true
				Layout.fillWidth:true

				profile: WebEngineProfile {
					id: whatsappProfile
					storageName: "whatsapp"
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
						let notify = notificationComponent.createObject(parent);
						notify.title = notification.title;
						notify.text = notification.message
						notify.sendEvent();
					}
				}

				//This signal is emitted when the web site identified by securityOrigin requests to make use of the resource or device identified by feature.
				onFeaturePermissionRequested: {
					if (feature === WebEngineView.Notifications) {
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
						whatsappWebview.grantFeaturePermission("https://web.whatsapp.com", WebEngineView.Notifications, true)
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
					console.log("Whatsapp: " + message);
				}

				// onNavigationRequested : if(request.navigationType == WebEngineNavigationRequest.LinkClickedNavigation){
				// 	console.log("estando navegando a otra pagina")
				// 	if(request.url.toString().match(/https?\:\/\/whatsapp\.com/)) {
				// 		console.log("Es de whats");
				// 		whatsappWebview.url = request.url;
				// 	} else {
				// 		console.log("No es de Whatsapp");
				// 		Qt.openUrlExternally(request.url);
				// 		request.action = WebEngineNavigationRequest.IgnoreRequest;
				// 	}
				// } else {
				// 	console.log(request.url)
				// }

				function isDark(color) {
					let luminance = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
					return (luminance < 0.5);
				}
			}
			WebEngineView {
				id: whatsappWebviewDual
				url: "https://web.whatsapp.com"
				enabled: plasmoid.configuration.dualWhatsapp
				visible: plasmoid.configuration.dualWhatsapp
				settings.javascriptCanAccessClipboard: plasmoid.configuration.allowClipboardAccess
				Layout.fillHeight: true
				Layout.fillWidth: true

				profile: WebEngineProfile {
					id: whatsappProfileDual
					storageName: "whatsappDual"
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
						let notify = notificationComponent.createObject(parent);
						notify.title = notification.title;
						notify.text = notification.message
						notify.sendEvent();
					}
				}

				onFeaturePermissionRequested: {
					if (feature === WebEngineView.Notifications) {
						whatsappWebviewDual.grantFeaturePermission(securityOrigin, feature, true)
					}
				}

				onNewViewRequested: {
					Qt.openUrlExternally(request.requestedUrl)
				}

				onLoadingChanged:  {
					if(WebEngineView.LoadSucceededStatus === loadRequest.status) {
						console.log("Cargando")
						whatsappWebviewDual.grantFeaturePermission("https://web.whatsapp.com", WebEngineView.Notifications, true);
						whatsappWebviewDual.runJavaScript("document.userScripts.setConfig("+JSON.stringify(plasmoid.configuration)+");");
						
						if (plasmoid.configuration.matchTheme) {
							let themeLightness = (isDark(theme.backgroundColor) ? 'dark' : 'light');
							whatsappWebviewDual.runJavaScript("document.userScripts.getTheme();",function(theme) {
								if(theme !== themeLightness) whatsappWebviewDual.runJavaScript("document.userScripts.setTheme('"+themeLightness+"');");
							});
						}
					}
				}

				onJavaScriptConsoleMessage : if (Qt.application.arguments[0] == "plasmoidviewer") {
					console.log("Whatsapp Dual: " + message);
				}

				function isDark(color) {
					var luminance = 0.2126 * color.r + 0.7152 * color.g + 0.0722 * color.b;
					return (luminance < 0.5);
				}
			}
		}
		WebEngineView {
			id:whatsappWebViewInspector
			enabled: false
			visible: false
			z: 100
			height:parent.height /2
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignBottom
			inspectedView: enabled ? whatsappWebview : null
		}
		WebEngineView {
			id: whatsappWebViewDualInspector
			enabled: false
			visible: false
			z: 100
			height:parent.height /2
			Layout.fillWidth: true
			Layout.alignment: Qt.AlignBottom
			inspectedView: enabled ? whatsappWebviewDual : null
		}
	}

}


