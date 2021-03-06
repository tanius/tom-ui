#ifndef GOTIME_UI_PROJECT_H
#define GOTIME_UI_PROJECT_H

#include <QtCore>
#include <QtCore/QString>

#include "timespan/timespan.h"

class Project {
public:
    Project();

    Project(QStringList names, QString id, QString parentID, QString hourlyRate);

    QString getID() const;

    QString getParentID() const;

    QString getName() const;

    QString getShortName() const;

    QString getHourlyRate() const;

    bool isValid() const;

    bool isRootProject() const;

    bool isValidOrRootProject() const;

    static Project rootProject() {
        Project root = Project();
        root._isRootProject = true;
        return root;
    }

private:
    QString _id;
    QString _parentID;
    QStringList _names;
    QString _hourlyRate;
    QDateTime _lastUpdated;
    QString _fullName;
    bool _isValid;
    bool _isRootProject;
};

inline bool operator==(const Project &a, const Project &b) { return a.getID() == b.getID(); }

inline bool operator!=(const Project &a, const Project &b) { return !operator==(a, b); }

#endif //GOTIME_UI_PROJECT_H
