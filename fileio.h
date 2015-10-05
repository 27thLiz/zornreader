#ifndef FILEIO_H
#define FILEIO_H
#include <QObject>
#include <QFile>
#include <QTextStream>

class fileIO : public QObject
{
    Q_OBJECT
public:
    explicit fileIO(QObject *parent = 0);

signals:

public slots:
    bool write(const QString& source, const QString& data)
        {
            if (source.isEmpty())
                return false;

            QFile file(source);
            if (!file.open(QFile::WriteOnly | QFile::Truncate))
                return false;

            QTextStream out(&file);
            out << data;
            file.close();
            return true;
        }
};

#endif // FILEIO_H
