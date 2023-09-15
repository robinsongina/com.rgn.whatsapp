import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.5 as QQC2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: page
	property alias cfg_debugConsole: debugConsole.checked

	Layout.fillHeight:true

    QQC2.CheckBox {
       id: debugConsole
       Layout.alignment: Qt.AlignBottom
       text: i18n("Show debug console")
    }
}
