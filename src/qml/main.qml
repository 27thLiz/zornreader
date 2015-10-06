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
import QtQuick.Window 2.2
import Material 0.1
import QtQuick.Controls 1.4 as Controls

ApplicationWindow {
    id: win
    visible: true

    title: "Zorn Reader"
    property bool isFullScreen: false
    property var chapters: []
    //property var
    property Item chapView: ;
    function toggleFullScreen(force, fs ) {
        force = typeof force !== 'undefined' ? force : false;
        fs = typeof fs       !== 'undefined' ? fs : false;
        if (force) {
            if (fs) {
                isFullScreen = true
                showFullScreen()
            }
            else {
                isFullScreen = false
                showMaximized()
            }
        }
        else if (isFullScreen) {
            isFullScreen = false
            showMaximized()
        }
        else {
            isFullScreen = true
            showFullScreen()
        }
    }


    theme {
        backgroundColor: "#C5CAE9"

        primaryColor: "#3F51B5"
        primaryDarkColor: "#303F9F"

        accentColor: "#FF4081"
        tabHighlightColor: "#FF4081"
    }

    color: theme.backgroundColor

    initialPage: TabbedPage {

        title: "Mangas"

        id: mainPage
        Keys.onEscapePressed: toggleFullScreen()
        function open_chapter(chapID, index) {

            toggleFullScreen(true, true)
            pageStack.push(Qt.resolvedUrl("PageView.qml"), {chapter: chapID, currentChapter: index})
        }

        MangaView {

            id: mview
            visible: true
            onClickedManga:{
                chapView = pageStack.push(Qt.resolvedUrl("ChapterView.qml"), {manga_id: iD, manga_name: name})
                chapView.clickedChapter.connect(mainPage.open_chapter)
            }
        }

        Tab {

            id: p
            iconName:  "action/favorite"
            PageView {
                id: pview
                anchors.fill: parent
                visible: false
            }
        }
    }
}
