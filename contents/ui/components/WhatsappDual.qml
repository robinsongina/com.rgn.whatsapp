import QtQuick 2.3
import QtQuick.Layouts 1.0
import org.kde.plasma.plasmoid 2.0
import QtWebEngine 1.9

Component {
	id: whatsappWebviewDualComponent
	WhatsappEngineView {
		id: whatsappWebviewDual
		profile.storageName: "whatsappDual"
		enabled: plasmoid.configuration.dualWhatsapp
		visible: plasmoid.configuration.dualWhatsapp
		msgDebug: "Whatsapp dual: "
	}
}