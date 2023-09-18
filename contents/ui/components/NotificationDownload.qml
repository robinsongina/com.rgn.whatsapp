import QtQuick 2.3
import QtQuick.Layouts 1.0
import org.kde.notification 1.0
import org.kde.plasma.plasmoid 2.0

Component {
	id: notificationDownloadComponent
	Notification {
		property string directory: ""
		componentName: "plasma_workspace"
		eventId: "notification"
		iconName: Qt.resolvedUrl("../assets/logo.svg");
		autoDelete: true
		onAction1Activated: {
			let file = `file:///${directory}/${text}`
			Qt.openUrlExternally(file)
		}
		onAction2Activated: {
			let file = `file:///${directory}/`
			Qt.openUrlExternally(file)
		}
	}
}
