import QtQuick 2.3

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
Item {
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