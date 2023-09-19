import QtQuick 2.3
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.5 as QQC2
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
  id: page

  property alias cfg_matchTheme: matchTheme.checked
  property alias cfg_allowClipboardAccess: allowClipboardAccess.checked
  property alias cfg_userAgent: userAgent.text
  property alias cfg_dualWhatsapp: dualWhatsapp.checked
  property alias cfg_width: width.value
  property alias cfg_height: height.value
	
  Layout.fillHeight:true

  QQC2.Slider {
    Kirigami.FormData.label:i18n("Window Width: %1px",width.value );
    id: width
    from: 790
    stepSize: 10
    value: 790
    to: 1920
    live: true
  }

  QQC2.Slider {
    Kirigami.FormData.label:i18n("Window Height: %1px",height.value );
    id: height
    from: 555
    stepSize: 10
    value: 555
    to: 1080
    live: true
  }

  QQC2.TextField {
	  id: userAgent
    Kirigami.FormData.label: i18n("UserAgent:")
	  placeholderText: "UserAgent for browser"
  }

  QQC2.Label {
   font.pixelSize: 10
   font.italic: true
   text:i18n("It is necessary to ignore the message Whatsapp works with Google Chrome 60+");
  }

  QQC2.CheckBox {
    id: dualWhatsapp
    //Kirigami.FormData.label: i18n("Dual Whatsapp :")
    text: i18n("Dual Whastapp")
  }
	
	QQC2.CheckBox {
    id: matchTheme
    text: i18n("Match OS theme")
  }

	QQC2.CheckBox {
    id: allowClipboardAccess
    text: i18n("Allow Whatsapp system clipboard access")
  }

  QQC2.Label {
		font.pixelSize: 8
		font.italic: true
		text:i18n("This is enabled by default to allow for quick code/recipe/etc but can be disabled if you are worried about Whatsapp examining your system clipboard");
	} 
  
}
