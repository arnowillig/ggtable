import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

Item {
	id: appPage
	signal appClicked(string appId)

	Rectangle {
		id: appPageBackground
		anchors.fill: parent
		radius: 16
		color: "#20ffffff"
		border.width: 1
		border.color: "#80ffffff"
		opacity: appPageMouseArea.pressed ? 1.0 : 0.125
		Behavior on opacity { NumberAnimation { duration: 500 } }
	}
	MouseArea {
		id: appPageMouseArea
		anchors.fill: parent
	}

	ListModel {
		id: appModel
		ListElement { appId: "com.bytefeed.gamegrid.browser"; name: "Internet"; icon: "chrome.svg" }
		ListElement { appId: "com.bytefeed.gamegrid.dice"; name: "Roll dice"; icon: "dice.svg" }
		ListElement { appId: "com.bytefeed.gamegrid.heroes3"; name: "Heroes III"; icon: "heroes3.png" }
		ListElement { appId: "com.bytefeed.gamegrid.chess"; name: "Chess"; icon: "chess.svg" }
		ListElement { appId: "com.bytefeed.gamegrid.morris"; name: "Nine Men's Morris"; icon: "morris.svg" }
		ListElement { appId: "com.bytefeed.gamegrid.drakon"; name: "Drakon"; icon: "" }
		ListElement { appId: "com.bytefeed.gamegrid.root"; name: "Root"; icon: "" }
		ListElement { appId: "com.bytefeed.gamegrid.helden"; name: "Helden müssen draußen bleiben"; icon: "" }
		ListElement { appId: "com.bytefeed.gamegrid.wingspan"; name: "Wingspan"; icon: "" }
		ListElement { appId: "com.bytefeed.gamegrid.tickettoride"; name: "Ticket to Ride"; icon: "" }
		ListElement { appId: "com.bytefeed.gamegrid.smallworld"; name: "SmallWorld"; icon: "" }
		ListElement { appId: "com.bytefeed.gamegrid.browser"; name: "Heckmeck am Bratwurmeck"; icon: "heckmeck.jpg" }
		ListElement { appId: "com.bytefeed.gamegrid.settings"; name: "Settings"; icon: "settings.svg" }
		ListElement { appId: "com.bytefeed.gamegrid.screensaver"; name: "Screensaver"; icon: "sleepmode.svg" }
		ListElement { appId: "com.bytefeed.gamegrid.add"; name: "Add app"; icon: "plus.svg" }
	}
	Item {
		id: appPageItem
		width: parent.width
		height: parent.height

		function calculateRows() {
			let count = appModel.count;
			if (count < 5) {
				return 1;
			} else if (count < 9) {
				return 2;
			} else {
				return 3;
			}
		}

		function calculateColumns() {
			let count = appModel.count;
			let rows = calculateRows();
			switch (rows) {
			case 1: return [count];
			case 2: {
				let half = Math.ceil(count / 2);
				return [Math.floor(count / 2), count - Math.floor(count / 2)];
			}
			case 3: {
				let base = Math.floor(count / 3);
				let remainder = count % 3;
				if (remainder === 0) {
					return [base, base, base];
				} else if (remainder === 1) {
					return [base, base + 1, base];
				} else {
					return [base + 1, base, base + 1];
				}
			}
			}
		}

		function calculateIndex(col, row) {
			let columnsPerRow = calculateColumns();
			let index = 0;
			for (let i=0; i<row; i++) {
				index += columnsPerRow[i];
			}
			index += col;
			return index;
		}

		Column {
			anchors.centerIn: parent
			spacing: 32

			Repeater {
				model: appPageItem.calculateRows()
				delegate: Row {
					id: rowItem
					spacing: 48
					anchors.horizontalCenter: parent.horizontalCenter
					property int rowIndex: index
					z: 0

					Repeater {
						id: rowRepeater
						model: appPageItem.calculateColumns()[index]
						delegate: GGAppItem {
							id: appItem
							text: appModel.get(appPageItem.calculateIndex(index, rowItem.rowIndex)).name
							icon: appModel.get(appPageItem.calculateIndex(index, rowItem.rowIndex)).icon
							onPressedChanged: { rowItem.z = pressed ? 1 : 0; }
							onClicked: {
								appPage.appClicked(appModel.get(appPageItem.calculateIndex(index, rowItem.rowIndex)).appId);
							}
						}
					}
				}
			}
		}
	}
}

