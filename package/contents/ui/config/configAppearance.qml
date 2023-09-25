import QtQml 2.0
import QtQuick 2.3
import QtQuick.Controls 2.5 as QQC2
import org.kde.kirigami 2.4 as Kirigami


Kirigami.FormLayout {
  id: page

  property alias cfg_width: width.value
  property alias cfg_height: height.value
  
  QQC2.Slider {
    Kirigami.FormData.label:i18n("Window Width: %1px",width.value );
    id: width
    from: 790
    stepSize: 5
    value: 790
    to: 1920
    live: true
  }

  QQC2.Slider {
    Kirigami.FormData.label:i18n("Window Height: %1px",height.value );
    id: height
    from: 555
    stepSize: 5
    value: 555
    to: 1080
    live: true
  }
}