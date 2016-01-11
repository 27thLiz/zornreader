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
function getChapters(manga_id, listmodel, chapters) {

    chapters.length = 0
    var xmlhttp = new XMLHttpRequest();
    var url = "https://www.mangaeden.com/api/manga/" + manga_id + "/";
    xmlhttp.open("GET", url, true);
    xmlhttp.onreadystatechange=function() {
        if (xmlhttp.readyState == XMLHttpRequest.DONE) {

            var obj = JSON.parse(xmlhttp.responseText)
            for (var i = 0; i < obj.chapters.length; i++) {

                var c = obj.chapters[i]

                chapters.push({num: obj.chapters[i][0], name: obj.chapters[i][2], chapter_id: obj.chapters[i][3], index: i })
            }
            fillChapterModel(listmodel, chapters)
        }
    }
    xmlhttp.send();
}

function toggleFullScreen(force, fs ) {
    force = typeof force !== 'undefined' ? force : false;
    fs = typeof fs       !== 'undefined' ? fs : false;
    if (force) {
        if (fs) {
            win.isFullScreen = true
            win.showFullScreen()
        }
        else {
            win.isFullScreen = false
            win.showMaximized()
        }
    }
    else if (win.isFullScreen) {
        win.isFullScreen = false
        win.showMaximized()
    }
    else {
        win.isFullScreen = true
        win.showFullScreen()
    }
}

function fillChapterModel(model, chapters) {

    model.clear();

    for (var i = chapters.length - 1; i >= 0; i--) {

        model.append(chapters[i])
    }
}
