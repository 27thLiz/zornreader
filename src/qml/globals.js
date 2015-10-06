
function filterChapters(search_str) {

}


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

function fillChapterModel(model, chapters) {

    model.clear();

    for (var i = 0; i < chapters.length; i++) {

        model.append(chapters[i])
    }
}
