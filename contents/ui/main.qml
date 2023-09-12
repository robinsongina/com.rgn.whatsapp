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
			
			WhatsappEngineView {
				id: whatsappWebview
				profile.storageName: "whatsapp"
				msgDebug: "Whatsapp: "
			}

			WhatsappEngineView {
				id: whatsappWebviewDual
				profile.storageName: "whatsappDual"
				enabled: plasmoid.configuration.dualWhatsapp
				visible: plasmoid.configuration.dualWhatsapp
				msgDebug: "Whatsapp dual: "
			}
		}

		WhatsappEngineViewInspector {
			id: whatsappWebViewInspector
			height: parent.height / 2
            inspectedView: enabled ? whatsappWebview : null	
        }

		WhatsappEngineViewInspector {
			id: whatsappWebViewDualInspector
			height: parent.height / 2
            inspectedView: enabled ? whatsappWebviewDual : null	
        }
	}

}


