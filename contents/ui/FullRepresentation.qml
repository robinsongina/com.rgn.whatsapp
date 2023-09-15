import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import QtWebEngine 1.9
import "components" as Components

Item {
    id: fullRep
	Layout.minimumWidth: 790 * PlasmaCore.Units.devicePixelRatio
	Layout.minimumHeight:  555 * PlasmaCore.Units.devicePixelRatio
	Layout.preferredWidth: plasmoid.configuration.width * PlasmaCore.Units.devicePixelRatio
	Layout.preferredHeight: plasmoid.configuration.height * PlasmaCore.Units.devicePixelRatio

    Components.WhatsappDual{
        id: whatsappWebviewDualComponent
	}
    
    ColumnLayout {
        anchors.fill: parent

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
				if(whatsappWebview && plasmoid.expanded) {
					if(whatsappWebview.LoadStatus == WebEngineView.LoadFailedStatus) whatsappWebview.reload();
					if(plasmoid.configuration.dualWhatsapp){
						let whatsappDual = whatsappWebviewLoader.item;
						if(whatsappDual.LoadStatus == WebEngineView.LoadFailedStatus) whatsappDual.reload()
					}
				}
				// console.log("Plasmoid onExpandedChanged: "+plasmoid.expanded )
			}
		}

		//------------------------------------- UI -----------------------------------------
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
						if(plasmoid.configuration.dualWhatsapp) {
							let whatsappDual = whatsappWebviewLoader.item;
							whatsappDual.reload();
						}
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
						let whatsappDual = whatsappWebviewLoader.item;
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
			
			Components.WhatsappEngineView {
				id: whatsappWebview
				profile.storageName: "whatsapp"
				msgDebug: "Whatsapp: "
			}
	
			Item {
				Layout.fillHeight: true
				Layout.fillWidth: true
				enabled: plasmoid.configuration.dualWhatsapp
				visible: plasmoid.configuration.dualWhatsapp
				Loader {
					id: whatsappWebviewLoader
					anchors.fill: parent
					sourceComponent: plasmoid.configuration.dualWhatsapp ? whatsappWebviewDualComponent : null
				}
			}
		}

		Components.WhatsappEngineViewInspector {
			id: whatsappWebViewInspector
			height: parent.height / 2
			inspectedView: enabled ? whatsappWebview : null	
		}

		Components.WhatsappEngineViewInspector {
			id: whatsappWebViewDualInspector
			height: parent.height / 2
			inspectedView: enabled ? whatsappWebviewLoader.item : null	
		}
	}
}