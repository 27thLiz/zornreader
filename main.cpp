#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "fileio.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    fileIO io;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("fileio", &io);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

