/* ZornReader, a simple online-reader for mangas
 * Copyright (C) 2015    Andreas Haas <hondres@gmail.com>

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import QtQuick 2.5
import Material 0.1
import Material.ListItems 0.1 as ListItem
import QtQuick.Controls 1.4 as Controls

Tab {

    id: mview
    title: "ALL"
    SystemPalette { id: myPalette; colorGroup: SystemPalette.Active }

    signal clickedManga(string iD, string name)

    Item {
        property var mangas: []
        property string test
        View {
            anchors.fill: parent
            anchors.margins: Units.dp(32)
            elevation: 2

            ListModel {

                id: model
            }

            //anchors.fill: parent

            Icon {
                id: searchIcon
                name: "action/search"
                anchors.right: parent.right
                size: 30
                color: "black"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        searchText.visible = true
                        searchText.forceActiveFocus()
                        searchAnim.start()
                    }
                }
            }

            TextField {
                id: searchText
                visible: false
                anchors.right: searchIcon.left
                width: 0
                placeholderText: "Search..."
                onTextChanged: searchMangas(text)
                onFocusChanged: console.log("changed")
            }
            PropertyAnimation {
                id: searchAnim
                target: searchText
                property: "width"
                to: "200"
            }


            ListView {
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                width: parent.width / 2
                id: listview
                model: model

                Scrollbar {
                    flickableItem: parent
                    thickness: Units.dp(10)
                }

                delegate: ListItem.Standard {

                    text: name
                    onClicked: clickedManga(i, name)
                }
            }
        }

        function addManga(chapter_id, manga_name) {
            var component = Qt.createComponent(Qt.resolvedUrl("src/qml/MangaItem.qml"));
            var newManga = component.createObject(mangalist, {chapter_id: chapter_id, manga_name: manga_name})
        }

        function searchMangas(search_str) {

            listview.model.clear()
            listview.contentY = 0
            for (var i = 0; i < mangas.length; i++) {

                if (mangas[i].name.toLowerCase().indexOf(search_str.toLowerCase()) != -1) {
                    listview.model.append(mangas[i])
                }
            }
        }

        function getMangas() {

            listview.model.clear()
            var xmlhttp = new XMLHttpRequest();
            var url = "https://www.mangaeden.com/api/list/0/";
            xmlhttp.open("GET", url, true);
            xmlhttp.onreadystatechange=function() {
                if (xmlhttp.readyState == XMLHttpRequest.DONE) {

                    var obj = JSON.parse(xmlhttp.responseText)
                    for (var i = 0; i < obj.manga.length; i++) {

                        listview.model.append({name: obj.manga[i].t, i: obj.manga[i].i })
                        mangas.push({name: obj.manga[i].t, i: obj.manga[i].i })
                        //addManga(obj.manga[i].i, obj.manga[i].t)
                    }
                }
            }
            xmlhttp.send();
        }
        Component.onCompleted: getMangas()
    }
}

