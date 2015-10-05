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
        backgroundColor: Palette.colors["blueGrey"]["800"]
        primaryColor: Palette.colors["blue"]["500"]
        primaryDarkColor: Palette.colors["orange"]["700"]
        accentColor: Palette.colors["yellow"]["500"]
        tabHighlightColor: "white"
    }

    color: theme.backgroundColor

    initialPage: TabbedPage {

        title: "Mangas"

        id: mainPage
        Keys.onEscapePressed: toggleFullScreen()
        function open_chapter(chapID) {

            toggleFullScreen(true, true)
            pageStack.push(Qt.resolvedUrl("PageView.qml"), {chapter: chapID})
        }

        MangaView {

            id: mview
            visible: true
            onClickedManga:{
                var newPage = pageStack.push(Qt.resolvedUrl("ChapterView.qml"), {manga_id: iD, manga_name: name})
                newPage.clickedChapter.connect(mainPage.open_chapter)
            }
        }

        Tab {
            iconName: "action/favorite"
            id: p
            PageView {
                id: pview
                anchors.fill: parent
                visible: false
            }
        }
    }
}
