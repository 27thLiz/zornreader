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
import QtQuick.Controls 1.4 as Controls

Page {

    title: manga_name
    id: cview

    visible: true
    signal clickedChapter(string iD)

    property string manga_id
    property string manga_name

    ListModel {

        id: model
    }

    ListView {
        anchors.fill: parent
        id: listview
        model: model

        delegate: Text {
            color: myPalette.text
            text: num + ": " + name

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onContainsMouseChanged: {
                    color = containsMouse ? theme.accentColor : "white"
                }
                onClicked:  {

                    clickedChapter(i)
                }
            }
        }
    }

    onVisibleChanged: {
        if (visible) {
            toggleFullScreen(true, false)
        }
    }

    onManga_idChanged: getChapters(manga_id)
    function getChapters(manga_id) {

        cview.visible = true
        listview.model.clear()
        var xmlhttp = new XMLHttpRequest();
        var url = "https://www.mangaeden.com/api/manga/" + manga_id + "/";
        xmlhttp.open("GET", url, true);
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState == XMLHttpRequest.DONE) {

                var obj = JSON.parse(xmlhttp.responseText)
                for (var i = 0; i < obj.chapters.length; i++) {

                    var c = obj.chapters[i]
                    listview.model.append({num: obj.chapters[i][0], name: obj.chapters[i][2], i: obj.chapters[i][3] })
                }
            }
        }
        xmlhttp.send();
    }
}

