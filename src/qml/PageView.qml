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

    id: pview
    title: "read"
    visible: true
    backgroundColor: "black"
    property var pages: []
    property int currentChapter
    property string chapter

    actions: [

        Action {
            iconName: "navigation/chevron_left"
            name: "Previous chapter"
            onTriggered: chapterAction("prev")
        },

        Action {
            iconName: "navigation/chevron_right"
            name: "Next chapter"
            onTriggered: chapterAction("next")
        },

        Action {
            iconName: isFullScreen ? "navigation/fullscreen_exit" : "navigation/fullscreen"
            name: "toggle fullscreen"
            onTriggered: {
                toggleFullScreen()
            }
        },

        Action {
            iconName: "action/settings"
            name: "Settings"
            hoverAnimation: true
        }
    ]

    MouseArea {
        id: topMouse
        anchors {top: parent.top; left: parent.left; right: parent.right}
        height: Units.dp(32)
        hoverEnabled: true
        property bool hiding: true
        onContainsMouseChanged: {
            if (containsMouse && hiding) {
                hiding = false
                actionBar.hidden = false
            }
            else if (containsMouse && !hiding) {
                actionBar.hidden = true
                hiding = true
            }
        }
    }
    Controls.ScrollView {

        id: scroll
        anchors.centerIn: parent
        verticalScrollBarPolicy: Qt.ScrollBarAlwaysOff
        width: Math.min(contentItem.width, pview.width)
        height: Math.min(contentItem.height, pview.height)
        focus: true
        flickableItem.boundsBehavior: Flickable.StopAtBounds

        Keys.onDownPressed:  flickableItem.flick(0, -400)
        Keys.onUpPressed:    flickableItem.flick(0,  400)
        Keys.onLeftPressed:  imgView.gotoPage(imgView.currentPage - 1)
        Keys.onRightPressed: imgView.gotoPage(imgView.currentPage + 1)
        Keys.onEscapePressed: toggleFullScreen()
        Image {
            id: imgView
            cache: false

            //anchors.rightMargin: (parent.width - paintedWidth)/2
            fillMode: Image.PreserveAspectFit
            property string download: "https://cdn.mangaeden.com/mangasimg/"
            property int currentPage: 0

            function gotoPage(page) {

                scroll.flickableItem.contentY = 0
                var go = pages.length - 1 - page
                if (go >= 0) {
                    source = download + pages[go]
                    currentPage = page
                }
            }

            MouseArea {

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.horizontalCenter
                propagateComposedEvents: true
                onClicked: {
                    parent.gotoPage(parent.currentPage - 1)
                }
            }

            MouseArea {

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.horizontalCenter
                anchors.right: parent.right
                propagateComposedEvents: true
                onClicked: parent.gotoPage(parent.currentPage + 1)
            }
        }
    }

    //onChapterChanged: getPages(chapter)
    onCurrentChapterChanged: getPages(win.chapters[currentChapter].chapter_id)

    function chapterAction(action) {
        var newChapter = currentChapter
        if (action === "next") {
            newChapter -= 1
        }
        else if (action === "prev") {
            newChapter += 1
        }
        if (newChapter >= 0 && newChapter < win.chapters.length) {
            currentChapter = newChapter
        }
    }

    function getPages(chapter_id) {

        pages.length = 0
        var xmlhttp = new XMLHttpRequest();
        var url = "https://www.mangaeden.com/api/chapter/" + chapter_id + "/";
        xmlhttp.open("GET", url, true);
        xmlhttp.onreadystatechange=function() {
            if (xmlhttp.readyState == XMLHttpRequest.DONE) {

                var obj = JSON.parse(xmlhttp.responseText)
                for (var i = 0; i < obj.images.length; i++) {

                    pages.push(obj.images[i][1])
                }
                imgView.gotoPage(0)
            }
        }
        xmlhttp.send();
    }
}

