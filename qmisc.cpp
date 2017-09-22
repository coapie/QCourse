#include <QDir>
#include<QDebug>
#include <QTextStream>
#include <QTextCodec>
#include <QUrl>
#include <QNetworkInterface>
#include "qmisc.h"

QMisc::QMisc(QObject *parent) : QObject(parent)
{
    _appDir = QDir::currentPath();
}

QString QMisc::appDir()const
{
    return _appDir;
}

QString QMisc::getDirName(const QString &dir)
{

    QDir qd(dir);

    return qd.dirName();
}

QString QMisc::readFile(const QString &json)
{
    QString val;
    QFile file;

    file.setFileName(json);

    if(!file.exists())
    {
        qDebug() << "read json : " << json << " not exist!";
        return QString("");
    }

    if(! file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qDebug() << "open json : fail !";
        return QString("");
    }

    val = file.readAll();
    file.close();

    return val;
}

QString QMisc::UrlToPath(const QString &json)
{
    QUrl  url(json);

    return url.toLocalFile();
}

bool QMisc:: writeFile(const QString &jsonFile, const QString &jsonString)
{
    QFile file;

    file.setFileName(jsonFile);

    if(! file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        qDebug() << "open json : fail !";
        return false;
    }

    QTextStream out(&file);
    out.setCodec("UTF-8");

    out << jsonString.toUtf8() << "\r\n";

    //file.write(jsonString.data()->da, jsonString.length());
/*
    QTextStream out(&file);


    QByteArray localBytes = QTextCodec::codecForName("UTF-8")->fromUnicode(jsonString);
    //jsonString.toUtf8();

    qDebug() << "write json : " << localBytes;

    out << localBytes << "\r\n" <<endl;
*/

    file.close();

    return true;
}

QString QMisc::getFilePath(const QString &file)
{
    QFileInfo  fi(QDir::cleanPath(file));

    return fi.path();
}

QString QMisc::getBaseName(const QString &file)
{
    QFileInfo  fi(QDir::cleanPath(file));

    return fi.baseName();
}

void QMisc::setAppDir(const QString &dir)
{
    _appDir = dir;
}


QString QMisc::getIP()
{
    QList<QHostAddress> list = QNetworkInterface::allAddresses();
    foreach (QHostAddress address, list)
    {
        if(address.protocol() == QAbstractSocket::IPv4Protocol)
        {
            if (address.toString().contains("127.0."))
            {
                continue;
            }

            return address.toString();
        }
    }
    return  QString("");
}


QString QMisc::getIPToJSON()
{
    QString ipsJSON = "{\"IPs\":[";
    bool first = true;

    QList<QHostAddress> list = QNetworkInterface::allAddresses();

    foreach (QHostAddress address, list)
    {
        if(address.isLoopback())
            continue;

        if(address.isMulticast())
            continue;

        if(address.isNull())
            continue;

        if(address.protocol() != QAbstractSocket::IPv4Protocol)
            continue;

        if (address.toString().contains("127.0."))
            continue;

        if(first){
            first = false;
        }else{
            ipsJSON += ",";
        }

        ipsJSON += "\"" + address.toString() + "\"";

    }

    ipsJSON += "]}";

    return  ipsJSON;
}

