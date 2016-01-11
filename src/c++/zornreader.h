#ifndef ZORNREADER_H
#define ZORNREADER_H
#include <QSettings>

class ZornReader : public QObject
{
    Q_OBJECT
public:
    explicit ZornReader(QObject *parent = 0);
    Q_INVOKABLE void save_fav(QString mname, QString mid);
    Q_INVOKABLE QVariantMap load_favs();

signals:

public slots:

private:
    QSettings* settings;
};

#endif // ZORNREADER_H
