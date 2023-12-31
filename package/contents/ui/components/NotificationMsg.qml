import QtQuick 2.3
import QtQuick.Layouts 1.0
import org.kde.notification 1.0
import org.kde.plasma.plasmoid 2.0

Component {
	id: notificationComponent
	Notification {
		property string chatId: ""
		componentName: "plasma_workspace"
		eventId: "notification"
		iconName: Qt.resolvedUrl("../assets/logo.svg");
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
		replyAction {
			label: "Reply"
			placeholderText: "Reply message"
			submitButtonText: "Send Reply"
			submitButtonIconName: "mail-reply-all"
			onReplied: {
				whatsappWebview.runJavaScript(`document.userScripts.replyMsg('${chatId}', '${text}');`);
			}
		}
	}
}