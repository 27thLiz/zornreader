#include "zornreader.h"
#include <QDebug>

ZornReader::ZornReader(QObject *parent) : QObject(parent)
{
    settings = new QSettings("Hinsbart", "ZornReader");
}

void ZornReader::save_fav(QString mname, QString mid) {
    QMap<QString, QVariant> map = settings->value("mangas/favs").toMap();
    map[mname] = mid;
    settings->setValue("mangas/favs", map);
}

QVariantMap ZornReader::load_favs() {

    QMap<QString, QVariant> map = settings->value("mangas/favs").toMap();
    return map;
}
