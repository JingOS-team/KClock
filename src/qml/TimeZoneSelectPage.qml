/*
 * Copyright 2019 Nick Reitemeyer <nick.reitemeyer@web.de>
 *           2020 Devin Lin <espidev@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License or (at your option) version 3 or any later version
 * accepted by the membership of KDE e.V. (or its successor approved
 * by the membership of KDE e.V.), which shall act as a proxy
 * defined in Section 14 of version 3 of the license.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.4 as Kirigami

Kirigami.Page {
    
    title: "Timezones"
    
    TextField {
        id: timeZoneSearchInput
        anchors.right: parent.right
        anchors.left: parent.left
        placeholderText: "Search"
        onTextChanged: timeZoneFilterModel.setFilterFixedString(text)
    }

    ListView {
        anchors.top: timeZoneSearchInput.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.topMargin: Kirigami.Units.smallSpacing * 2
        ScrollBar.vertical: ScrollBar {}
        clip: true
        spacing: Kirigami.Units.largeSpacing
        model: timeZoneFilterModel
        delegate: Row {
            CheckBox {
                checked: model.shown
                text: model.id + " " + model.shortName
                onClicked: model.shown = this.checked
            }
        }
    }
}
