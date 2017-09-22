#ifndef QMISC_H
#define QMISC_H

#include <QObject>

class QMisc : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString appDir READ appDir WRITE setAppDir)

public:
    explicit QMisc(QObject *parent = 0);

    QString appDir()const;
    void setAppDir(const QString &dir);

    Q_INVOKABLE QString getDirName(const QString &dir);
    Q_INVOKABLE QString getFilePath(const QString &file);

    Q_INVOKABLE QString getBaseName(const QString &json);

    Q_INVOKABLE QString readFile(const QString &jsonFile);

    Q_INVOKABLE QString UrlToPath(const QString &jsonFile);
    Q_INVOKABLE QString getIP();

    Q_INVOKABLE QString getIPToJSON();

    Q_INVOKABLE bool writeFile(const QString &jsonFile, const QString &jsonString);


signals:

public slots:

private:
    QString _appDir;
};

#endif // QMISC_H
