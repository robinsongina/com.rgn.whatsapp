import QtQuick 2.3
import org.kde.plasma.configuration 2.0

ConfigModel {
    ConfigCategory {
        name: i18n("General")
        icon: "configure"
        source: "config/configGeneral.qml"
    }
    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-display-color"
        source: "config/configAppearance.qml"
    }
    ConfigCategory {
        name: i18n("Advanced")
        icon: "tools"
        source: "config/configAdvanced.qml"
    }
}
