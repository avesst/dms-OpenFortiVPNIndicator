import QtQuick
import Quickshell.Io
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root
    visible: processStarted
    width: processStarted ? (root.isVertical ? root.barThickness : root.widgetThickness) : 0
    height: processStarted ? (root.isVertical ? root.barThickness : root.widgetThickness) : 0

    property bool processStarted: false
    property bool interfaceActive: false

    horizontalBarPill: Component {
        DankIcon {
            id: vpn_icon
            name: "vpn_lock_2"
            color: interfaceActive ? Theme.primary : Theme.outlineButton
        }
    }

    verticalBarPill: Component {
        DankIcon {
            id: vpn_icon
            name: "vpn_lock"
            color: interfaceActive ? Theme.primary : Theme.outlineButton
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: checkVpnStatus()
    }

    function checkVpnStatus() {
        check_openfortivpn.running = true

        if (processStarted) {
            check_device.running = true
        } else {
            interfaceActive = false
        }
    }

    Process {
        id: check_openfortivpn
        command: ["pgrep", "openfortivpn"]

        onExited: (exitCode) => { processStarted = exitCode === 0 }
    }

    Process {
        id: check_device
        command: ["ip", "link", "show", "dev", "ppp0"]

        onExited: (exitCode) => { interfaceActive = exitCode === 0 }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: false
        cursorShape: Qt.ArrowCursor
    }

    Component.onCompleted: checkVpnStatus()
}
