//
//  DatabaseConfiguration.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 21.12.2023.
//

import PostgresClientKit
import Foundation

final class Service {
    
    static let shared = Service()
    
    private init() {
        var configuration = ConnectionConfiguration()
        configuration.host = "127.0.0.1"
        configuration.port = 5432
        configuration.database = "StudentConstructionTeams"
        configuration.user = "nastasya"
        configuration.credential = .trust
        configuration.ssl = false
        
        connection = try! Connection(configuration: configuration)
    }
    
    private let connection: Connection
    
    func verificateUser(phone: String, password: String) throws -> Role? {
        var user = User(id: 0, name: "", surname: "", patronymic: "", phone: "", userType: UserType(id: 0, name: ""))
        
        let query = "SELECT my_user.ID AS user_id, my_user.surname, my_user.name, my_user.patronymic, my_user.birthdate, my_user.phone, user_type.id, user_type.name AS user_type FROM my_user JOIN user_type ON my_user.user_type_ID = user_type.ID WHERE my_user.phone = '\(phone)' AND my_user.password = '\(password)';"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let surname = try columns[1].string()
            let name = try columns[2].string()
            let patronymic = try columns[3].optionalString()
            
            var birthdate: Date? = nil
            let bdate = try columns[4].optionalDate()?.description
            if let bdate = bdate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: bdate)
            }
            
            let phone = try columns[5].string()
            let userTypeID = try columns[6].int()
            let userTypeName = try columns[7].string()
            
            user = User(
                id: id,
                name: name,
                surname: surname,
                patronymic:  patronymic ?? "",
                birthdate: birthdate,
                phone: phone,
                userType: UserType(id: userTypeID, name: userTypeName)
            )
        }
        
        switch user.userType.name {
            case "Студент":
                return .student(user.id)
            case "Руководитель команды":
                return .teamDirector(user.id)
            case "Админ":
                return .admin(user.id)
            default:
                return nil
        }
    }
    
    func fetchStudent(with id: Int) throws -> Student? {
        let query = "SELECT student.ID AS student_id, my_user.ID AS user_id, my_user.surname, my_user.name, my_user.patronymic, my_user.birthdate, my_user.phone, student.is_elder, student.earnings, student_group.id AS group_id, student_group.name AS group_name, student_group.faculty, team.id AS team_id, team.name AS team_name, COUNT(*) AS students_in_team FROM student JOIN my_user ON student.userID = my_user.ID LEFT JOIN student_group ON student.groupID = student_group.ID LEFT JOIN team ON student.teamID = team.ID WHERE student.id = \(id) GROUP BY student.ID, my_user.ID, student_group.ID, team.ID;"
        let statement = try self.connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let studentID = try columns[0].int()
            let userID = try columns[1].int()
            let surname = try columns[2].string()
            let name = try columns[3].string()
            let patronymic = try columns[4].optionalString() ?? nil
            
            var birthdate: Date? = nil
            let bdate = try columns[5].optionalDate()?.description
            if let bdate = bdate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: bdate)
            }
            
            let phone = try columns[6].string()
            let isElder = try columns[7].bool()
            let earnings = try columns[8].int()
            
            let groupID = try columns[9].optionalInt()
            let groupName = try columns[10].optionalString()
            let faculty = try columns[11].optionalString()
            
            let teamID = try columns[12].optionalInt()
            let teamName = try columns[13].optionalString()
            let countStudents = try columns[14].int()
            
            var group = Group(id: 0, name: "", faculty: "")
            if let id = groupID, let name = groupName, let faculty = faculty{
                group = Group(id: id, name: name, faculty: faculty)
            }
            
            var team = Team(id: 0, name: "", countStudents: 0)
            if let id = teamID, let name = teamName {
                team = Team(id: id, name: name, countStudents: countStudents)
            }
            
            let student = Student(
                id: studentID,
                userID: userID,
                name: name,
                surname: surname,
                patronymic: patronymic,
                birthdate: birthdate,
                earnings: earnings,
                phone: phone,
                isElder: isElder,
                group: group,
                team: team
            )
            return student
        }
        return nil
    }
    
    func fetchTeamDirector(with userID: Int) throws -> TeamDirector? {
        let query = "SELECT team_director.ID AS team_director_id, my_user.ID AS user_id, my_user.surname, my_user.name, my_user.patronymic, my_user.birthdate, my_user.phone, team.id AS team_id, team.name AS team_name, COUNT(student.ID) AS students_in_team FROM team_director JOIN my_user ON team_director.userID = my_user.ID LEFT JOIN team ON team_director.teamID = team.ID LEFT JOIN student ON student.teamID = team.ID WHERE team_director.id = \(userID) GROUP BY team_director.ID, my_user.ID, team.ID;"
        
        let statement = try self.connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let teamDirectorID = try columns[0].int()
            let userID = try columns[1].int()
            let surname = try columns[2].string()
            let name = try columns[3].string()
            let patronymic = try columns[4].optionalString() ?? nil
            
            var birthdate: Date? = nil
            let bdate = try columns[5].optionalDate()?.description
            if let bdate = bdate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: bdate)
            }
            
            let phone = try columns[6].string()
            let teamID = try columns[7].optionalInt()
            let teamName = try columns[8].optionalString()
            let countStudents = try columns[9].int()
            
            var team = Team(id: 0, name: "", countStudents: 0)
            if let id = teamID, let name = teamName {
                team = Team(id: id, name: name, countStudents: countStudents)
            }
            
            let teamDirector = TeamDirector(
                id: teamDirectorID,
                userID: userID,
                name: name,
                surname: surname,
                patronymic: patronymic,
                birthdate: birthdate,
                phone: phone,
                team: team
            )
            
            return teamDirector
        }
        
        return nil
    }
    
    func fetchUser(with userID: Int) throws -> User? {
        let query = "SELECT my_user.ID AS user_id, my_user.surname, my_user.name, my_user.patronymic, my_user.birthdate, my_user.phone, user_type.id, user_type.name AS user_type FROM my_user JOIN user_type ON my_user.user_type_ID = user_type.ID WHERE my_user.ID = \(userID);"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let surname = try columns[1].string()
            let name = try columns[2].string()
            let patronymic = try columns[3].optionalString()
            
            var birthdate: Date? = nil
            let bdate = try columns[4].optionalDate()?.description
            if let bdate = bdate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: bdate)
            }
            
            let phone = try columns[5].string()
            let userTypeID = try columns[6].int()
            let userTypeName = try columns[7].string()
            
            let user = User(
                id: id,
                name: name,
                surname: surname,
                patronymic:  patronymic ?? "",
                birthdate: birthdate,
                phone: phone,
                userType: UserType(id: userTypeID, name: userTypeName)
            )
            
            return user
        }
        
        return nil
    }
    
    func fetchStudentGroup(with id: Int) throws -> Group {
        let query = "SELECT * FROM student_group WHERE ID = \(id);"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let name = try columns[1].string()
            let faculty = try columns[2].string()
            
            let group = Group(id: id, name: name, faculty: faculty)
            return group
        }
        
        return Group(id: 0, name: "", faculty: "")
    }
    
    func registerNewUser(
        phone: String,
        password: String,
        surname: String,
        name: String,
        patronymic: String?,
        birthdate: Date?,
        teamID: Int?,
        groupID: Int?,
        isStudent: Bool
    ) throws {
        var birthdateString: String? = nil
        
        if let birthdate = birthdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthdateString = dateFormatter.string(from: birthdate)
        }
        
        var userTypeID = 0
        var userType = ""
        
        if isStudent {
            userType = "Студент"
        } else {
            userType = "Руководитель команды"
        }
        
        let userTypeQuery = "SELECT id FROM user_type WHERE name = '\(userType)';"
        let userTypeStatement = try connection.prepareStatement(text: userTypeQuery)
        defer { userTypeStatement.close() }
        
        let userTypeCursor = try userTypeStatement.execute(parameterValues: [])
        defer { userTypeCursor.close() }
        
        for row in userTypeCursor {
            let columns = try row.get().columns
            userTypeID = try columns[0].int()
        }
        
        var insertQuery = ""
        if let birthdateString = birthdateString, let patronymic = patronymic {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', '\(password)', \(userTypeID), '\(patronymic)', '\(birthdateString)')"
        } else if birthdateString == nil && patronymic != "" {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', '\(password)', \(userTypeID), '\(patronymic!)', null)"
        } else if birthdateString != nil && patronymic == "" {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', '\(password)', \(userTypeID), '', '\(birthdateString!)')"
        } else if birthdateString == nil && patronymic == "" {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', '\(password)', \(userTypeID), '', null)"
        }
        let insertStatement = try connection.prepareStatement(text: insertQuery)
        
        defer { insertStatement.close() }
        
        let insertCursor = try insertStatement.execute(parameterValues: [])
        defer { insertCursor.close() }
        
        let query = "SELECT ID FROM my_user WHERE phone = '\(phone)' AND password = '\(password)';"
        let statement = try connection.prepareStatement(text: query)
        
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var userID = 0
        for row in cursor {
            let columns = try row.get().columns
            userID = try columns[0].int()
        }
        
        if isStudent {
            var query = ""
            if teamID == 0 && groupID == 0 {
                query = "SELECT add_student(\(userID))"
            } else if groupID == 0 {
                query = "SELECT add_student(\(userID), FALSE, 0, NULL, \(teamID!));"
            } else if teamID == 0 {
                query = "SELECT add_student(\(userID), FALSE, 0, \(groupID!));"
            } else {
                query = "SELECT add_student(\(userID), FALSE, 0, \(groupID!), \(teamID!));"
            }
            
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: [])
            cursor.close()
        } else {
            var query = ""
            if teamID == 0 {
                query = "SELECT add_team_director(\(userID))"
            } else {
                query = "SELECT add_team_director(\(userID), \(teamID!));"
            }
            
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: [])
            cursor.close()
        }
    }
    
    func fetchAllTeams() throws -> [Team] {
        let query = "SELECT team.ID AS team_id, team.name AS team_name, COUNT(student.ID) AS student_count FROM team LEFT JOIN student ON team.ID = student.teamID GROUP BY team.ID, team.name ORDER BY team.ID;"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var teams = [Team]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            let countStudents = try columns[2].int()
            
            let team = Team(id: id, name: name, countStudents: countStudents)
            teams.append(team)
        }
        
        return teams
    }
    
    func fetchAllGroups() throws -> [Group] {
        let query = "SELECT sg.ID AS group_id, sg.name AS group_name, sg.faculty, u.ID AS elder_id FROM student_group sg LEFT JOIN student s ON sg.ID = s.groupID AND s.is_elder = true LEFT JOIN my_user u ON s.userID = u.ID;"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var groups = [Group]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            let faculty = try columns[2].string()
            let elderID = try columns[3].optionalInt()
            
            let group = Group(id: id, name: name, faculty: faculty, elderID: elderID)
            groups.append(group)
        }
        
        return groups
    }
    
    func fetchAllStudents() throws -> [Student] {
        let query = "SELECT s.ID AS student_id, u.ID AS user_id, u.surname, u.name, u.patronymic, u.birthdate, u.phone, s.is_elder, s.earnings, sg.id, sg.name AS group_name, t.id, t.name AS team_name FROM student s JOIN my_user u ON s.userID = u.ID LEFT JOIN student_group sg ON s.groupID = sg.ID LEFT JOIN team t ON s.teamID = t.ID;"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var students = [Student]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let userID = try columns[1].int()
            let surname = try columns[2].string()
            let name = try columns[3].string()
            let patronymic = try columns[4].optionalString()
            
            var birthdate: Date? = nil
            let bdate = try columns[5].optionalDate()?.description
            if let bdate = bdate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: bdate)
            }
            
            let phone = try columns[6].string()
            let isElder = try columns[7].bool()
            let earnings = try columns[8].int()
            let groupID = try columns[9].optionalInt()
            let groupName = try columns[10].optionalString()
            let teamID = try columns[11].optionalInt()
            let teamName = try columns[12].optionalString()
            
            var team = Team(id: 0, name: "", countStudents: 0)
            if let id = teamID, let name = teamName {
                team = Team(id: id, name: name, countStudents: 0)
            }
            
            var group = Group(id: 0, name: "", faculty: "")
            if let id = groupID, let name = groupName {
                group = Group(id: id, name: name, faculty: "")
            }
            
            let student = Student(id: id, userID: userID, name: name, surname: surname, patronymic: patronymic, birthdate: birthdate, earnings: earnings, phone: phone, isElder: isElder, group: group, team: team)
            students.append(student)
        }
        
        return students
    }
    
    func fetchAllTeamDirectors() throws -> [TeamDirector] {
        let query = "SELECT td.ID AS team_director_id, u.ID AS user_id, u.surname, u.name, u.patronymic, u.birthdate, u.phone, td.teamID, t.name AS team_name FROM team_director td LEFT JOIN my_user u ON td.userID = u.ID LEFT JOIN team t ON td.teamID = t.ID WHERE u.user_type_id = (SELECT id FROM user_type WHERE name = 'Руководитель команды');"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var teamDirectors = [TeamDirector]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let userID = try columns[1].int()
            let surname = try columns[2].string()
            let name = try columns[3].string()
            let patronymic = try columns[4].optionalString()
            
            var birthdate: Date? = nil
            let bdate = try columns[5].optionalDate()?.description
            if let bdate = bdate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: bdate)
            }
            
            let phone = try columns[6].string()
            let teamID = try columns[7].optionalInt()
            let teamName = try columns[8].optionalString()
            
            var team = Team(id: 0, name: "", countStudents: 0)
            if let id = teamID, let name = teamName {
                team = Team(id: id, name: name, countStudents: 0)
            }
            
            let teamDirector = TeamDirector(id: id, userID: userID, name: name, surname: surname, patronymic: patronymic, birthdate: birthdate, phone: phone, team: team)
            teamDirectors.append(teamDirector)
        }
        
        return teamDirectors
    }
    
    func fetchAllUsers() throws -> [User] {
        let query = "SELECT my_user.*, user_type.name AS user_type_name FROM my_user JOIN user_type ON my_user.user_type_ID = user_type.ID"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var users = [User]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let surname = try columns[1].string()
            let name = try columns[2].string()
            let patronymic = try columns[3].optionalString() ?? ""
            
            var birthdate: Date? = nil
            let bdate = try columns[4].optionalDate()?.description
            if bdate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: bdate!)
            }
            
            let phone = try columns[5].string()
            let userTypeID = try columns[7].int()
            let userTypeName = try columns[8].string()
            
            let user = User(
                id: id,
                name: name,
                surname: surname,
                patronymic: patronymic,
                birthdate: birthdate,
                phone: phone,
                userType: UserType(id: userTypeID, name: userTypeName)
            )
            users.append(user)
        }
        return users
    }
    
    func fetchAllTasks() throws -> [ConstructionTask] {
        let query = "SELECT t.ID AS task_id, tt.name AS task_type, tt.id, t.hours, tt.rate_per_hour, ts.id, ts.name AS task_status, tm.id, tm.name AS team_name, t.start_date, t.end_date FROM task t JOIN task_type tt ON t.typeID = tt.ID JOIN task_status ts ON t.statusID = ts.ID LEFT JOIN team tm ON t.teamID = tm.ID"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var tasks = [ConstructionTask]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let typeName = try columns[1].string()
            let typeID = try columns[2].int()
            let hours = try columns[3].int()
            let ratePerHour = try columns[4].int()
            let statusID = try columns[5].int()
            let statusName = try columns[6].string()
            let teamID = try columns[7].optionalInt()
            let teamName = try columns[8].optionalString()
            
            var startDate: Date? = nil
            let sDate = try columns[9].optionalDate()?.description
            if let date = sDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                startDate = dateFormatter.date(from: date)
            }
            
            var endDate: Date? = nil
            let eDate = try columns[10].optionalDate()?.description
            if let date = eDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                endDate = dateFormatter.date(from: date)
            }
            
            
            var team: Team? = nil
            if let id = teamID, let name = teamName {
                team = Team(id: id, name: name, countStudents: 0)
            }
            
            let task = ConstructionTask(id: id, taskType: TaskType(id: typeID, name: typeName, ratePerHour: String(ratePerHour)), countHours: String(hours), status: TaskStatus(id: statusID, name: statusName), team: team, startDate: startDate, endDate: endDate)
            tasks.append(task)
        }
        
        return tasks
    }
    
    func fetchAllTaskTypes() throws -> [TaskType] {
        let query = "SELECT * FROM task_type;"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var taskTypes = [TaskType]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            let ratePerHour = try columns[2].int()
            
            let taskType = TaskType(id: id, name: name, ratePerHour: String(ratePerHour))
            taskTypes.append(taskType)
        }
        
        return taskTypes
    }
    
    func updateUser(
        with userID: Int,
        surname: String,
        name: String,
        patronymic: String?,
        phone: String,
        birthdate: Date?,
        userTypeID: Int
    ) throws {
        var birthdateString: String? = nil
        if let birthdate = birthdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthdateString = dateFormatter.string(from: birthdate)
        }
        
        var query = ""
        
        if let birthdateString = birthdateString, let patronymic = patronymic {
            query = "SELECT update_my_user(\(userID), '\(surname)', '\(name)', '\(phone)', \(userTypeID), '\(patronymic)', '\(birthdateString)')"
        } else if birthdateString == nil && patronymic != "" {
            query = "SELECT update_my_user(\(userID), '\(surname)', '\(name)', '\(phone)', \(userTypeID), '\(patronymic!)')"
        } else if birthdateString != nil && patronymic == "" {
            query = "SELECT update_my_user(\(userID), '\(surname)', '\(name)', '\(phone)', \(userTypeID), '', '\(birthdateString!)')"
        } else if birthdateString == nil && patronymic == "" {
            query = "SELECT update_my_user(\(userID), '\(surname)', '\(name)', '\(phone)', \(userTypeID))"
        }
        print(query)
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateUserTeam(userID: Int, teamID: Int, typeUser: Screen) throws {
        var query = ""
        if typeUser == .studentAccount {
            query = "UPDATE student SET teamID = \(teamID) WHERE userID = \(userID)"
            if teamID == 0 {
                query = "UPDATE student SET teamID = NULL WHERE userID = \(userID)"
            }
        } else if typeUser == .teamDirectorAccount {
            query = "UPDATE team_director SET teamID = \(teamID) WHERE userID = \(userID)"
            if teamID == 0 {
                query = "UPDATE team_director SET teamID = NULL WHERE userID = \(userID)"
            }
        }
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchStudentTeam(with userID: Int) throws -> GeneralInformation? {
        let query = "SELECT team.name AS team_name, team_director_user.surname AS director_name, team_director_user.name AS director_name, team_director_user.patronymic AS director_name, team_director_user.phone AS director_phone, COUNT(student.ID) AS students_count FROM team LEFT JOIN student ON team.ID = student.teamID LEFT JOIN team_director ON team.ID = team_director.teamID LEFT JOIN my_user AS team_director_user ON team_director_user.ID = team_director.userID WHERE team.ID IN (SELECT teamID FROM student WHERE userID = \(userID)) GROUP BY team.ID, team.name, team_director_user.name, team_director_user.surname, team_director_user.patronymic, team_director_user.phone"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let teamName = try columns[0].string()
            let teamDirectorSurname = try columns[1].string()
            let teamDirectorName = try columns[2].string()
            let teamDirectorPatronymic = try columns[3].optionalString()
            let teamDirectorPhone = try columns[4].string()
            let studentsCount = try columns[5].int()
            
            var teamDirectorFullName = teamDirectorSurname + " " + teamDirectorName
            if let patronymic = teamDirectorPatronymic {
                teamDirectorFullName += " " + patronymic
            }
            
            let generalInformation = GeneralInformation(teamName: teamName, director: GeneralInformation.Person(name: teamDirectorFullName, phone: teamDirectorPhone), countStudents: studentsCount)
            return generalInformation
        }
        return nil
    }
    
    func fetchUserCurrentTask(userID: Int) throws -> GeneralInformation? {
        let query = "SELECT task_type.name AS task_type, task.start_date FROM task JOIN task_type ON task.typeID = task_type.ID JOIN student ON task.teamID = student.teamID WHERE student.userID = \(userID) AND task.start_date >= CURRENT_DATE  ORDER BY task.start_date LIMIT 1;"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let taskType = try columns[0].string()
            
            var startDate: Date? = nil
            let date = try columns[1].optionalDate()?.description
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                startDate = dateFormatter.date(from: date)
            }
            
            let generalInformation = GeneralInformation(taskType: TaskType(id: 0, name: taskType, ratePerHour: ""), startDate: startDate)
            return generalInformation
        }
        return nil
    }
    
    func fetchTeammates(userID: Int) throws -> [Student] {
        let query = "SELECT u.ID AS student_id, u.surname AS student_surname, u.name AS student_name, u.patronymic AS student_patronymic, u.birthdate AS student_birthdate, u.phone AS student_phone, sg.name AS group_name FROM student s JOIN my_user u ON s.userID = u.ID JOIN team t ON s.teamID = t.ID LEFT JOIN student_group sg ON s.groupID = sg.ID WHERE t.ID IN (SELECT teamID FROM team_director WHERE userID = \(userID)) OR t.ID IN (SELECT teamID FROM student WHERE userID = \(userID));"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var students = [Student]()
        
        for row in cursor {
            let columns = try row.get().columns
            let studentID = try columns[0].int()
            let surname = try columns[1].string()
            let name = try columns[2].string()
            let patronymic = try columns[3].optionalString()
            
            var birthdate: Date? = nil
            let date = try columns[4].optionalDate()?.description
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: date)
            }
            
            let phone = try columns[5].string()
            
            var groupName = ""
            if let name = try columns[6].optionalString() {
                groupName = name
            }
            
            let student = Student(id: studentID, userID: 0, name: name, surname: surname, patronymic: patronymic, birthdate: birthdate, phone: phone, group: Group(id: 0, name: groupName, faculty: ""))
            
            students.append(student)
        }
        return students
    }
    
    func fetchStudentGroup(with userID: Int) throws -> GeneralInformation? {
        let query = "SELECT sg.name AS group_name, MAX(student_leader.surname) AS leader_surname, MAX(student_leader.name) AS leader_name, MAX(student_leader.patronymic) AS leader_patronymic, MAX(student_leader.phone) AS leader_phone, COUNT(student.ID) AS students_count FROM student_group sg LEFT JOIN student ON sg.ID = student.groupID LEFT JOIN my_user AS student_leader ON student_leader.ID = student.userID AND student.is_elder = TRUE WHERE sg.ID IN (SELECT groupID FROM student WHERE userID = \(userID)) GROUP BY sg.name;"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let groupName = try columns[0].optionalString() ?? ""
            let elderName = try columns[1].optionalString()
            let elderSurname = try columns[2].optionalString()
            let elderPatronymic = try columns[3].optionalString()
            let elderPhone = try columns[4].optionalString() ?? ""
            let participantsCount = try columns[5].int()
            
            var elderFullName: String? = nil
            if let surname = elderSurname {
                elderFullName = surname + " " + elderName!
            }
            
            if let patronymic = elderPatronymic {
                elderFullName! += " " + patronymic
            }
            
            var elder: GeneralInformation.Person? = nil
            if let fullName = elderFullName {
                elder = GeneralInformation.Person(name: fullName, phone: elderPhone)
            }
            
            let groupInformation = GeneralInformation(groupName: groupName, elder: elder, countStudents: participantsCount)
            return groupInformation
        }
        return nil
    }
    
    func fetchGroupmates(with userID: Int) throws -> [Student] {
        let query = "SELECT u.ID AS student_id, u.name AS student_name, u.surname AS student_surname, u.patronymic AS student_patronymic, u.birthdate AS student_birthdate, u.phone AS student_phone, t.name AS team_name FROM student s JOIN my_user u ON s.userID = u.ID LEFT JOIN team t ON s.teamID = t.ID WHERE s.groupID = (SELECT groupID FROM student WHERE userID = \(userID) LIMIT 1);"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var students = [Student]()
        
        for row in cursor {
            let columns = try row.get().columns
            let studentID = try columns[0].int()
            let surname = try columns[1].string()
            let name = try columns[2].string()
            let patronymic = try columns[3].optionalString()
            
            var birthdate: Date? = nil
            let date = try columns[4].optionalDate()?.description
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: date)
            }
            
            let phone = try columns[5].string()
            
            var teamName = ""
            if let name = try columns[6].optionalString() {
                teamName = name
            }
            
            let student = Student(
                id: studentID,
                userID: 0,
                name: name,
                surname: surname,
                patronymic: patronymic,
                birthdate: birthdate,
                phone: phone,
                team: Team(id: 0,
                           name: teamName,
                           countStudents:  0)
            )
            
            students.append(student)
        }
        return students
    }
    
    func updateGroupForStudent(userID: Int, groupID: Int) throws {
        var query = "UPDATE student SET groupID = \(groupID) WHERE userID = \(userID)"
        
        if groupID == 0 {
            query = "UPDATE student SET groupID = NULL WHERE userID = \(userID)"
        }
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchFreeTeamsForTeamDirector(with id: Int) throws -> [Team] {
        let query = "SELECT t.ID AS team_id, t.name AS team_name FROM team t LEFT JOIN team_director td ON t.ID = td.teamID LEFT JOIN my_user u ON td.userID = u.ID WHERE td.ID = \(id) OR td.userID IS NULL;"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var teams = [Team]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            
            let team = Team(id: id, name: name, countStudents: 0)
            teams.append(team)
        }
        
        return teams
    }
    
    func fetchTeamDirectorTeam(with userID: Int) throws -> GeneralInformation? {
        let query = "SELECT team.name AS team_name, COUNT(student.ID) AS participants_count FROM team LEFT JOIN team_director ON team.ID = team_director.teamID LEFT JOIN my_user AS director_user ON team_director.userID = director_user.ID LEFT JOIN student ON team.ID = student.teamID WHERE director_user.ID = \(userID) GROUP BY team.ID, team.name;"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let teamName = try columns[0].optionalString()
            let participantsCount = try columns[1].optionalInt()
            
            let generalInformation = GeneralInformation(teamName: teamName, countStudents: participantsCount)
            return generalInformation
        }
        return nil
    }
    
    func fetchAllUserTypes() throws -> [UserType] {
        let query = "SELECT * FROM user_type"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var userTypes = [UserType]()
        
        for row in cursor {
            let columns = try row.get().columns
            let ID = try columns[0].int()
            let name = try columns[1].string()
            
            let userType = UserType(id: ID, name: name)
            userTypes.append(userType)
        }
        return userTypes
    }
    
    func addNewUser(
        phone: String,
        surname: String,
        name: String,
        patronymic: String?,
        birthdate: Date?,
        userTypeID: Int,
        userTypeName: String
    ) throws {
        var birthdateString: String? = nil
        
        if let birthdate = birthdate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthdateString = dateFormatter.string(from: birthdate)
        }
        
        var insertQuery = ""
        if let birthdateString = birthdateString, let patronymic = patronymic {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', 'user', \(userTypeID), '\(patronymic)', '\(birthdateString)')"
        } else if birthdateString == nil && patronymic != "" {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', 'user', \(userTypeID), '\(patronymic!)', null)"
        } else if birthdateString != nil && patronymic == "" {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', 'user', \(userTypeID), '', '\(birthdateString!)')"
        } else if birthdateString == nil && patronymic == "" {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', 'user', \(userTypeID), '', null)"
        }
        
        let insertStatement = try connection.prepareStatement(text: insertQuery)
        defer { insertStatement.close() }
        
        let insertCursor = try insertStatement.execute(parameterValues: [])
        defer { insertCursor.close() }
        
        let query = "SELECT ID FROM my_user WHERE phone = '\(phone)' AND password = 'user';"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var userID = 0
        for row in cursor {
            let columns = try row.get().columns
            userID = try columns[0].int()
        }
        
        if userTypeName == "Студент" {
            var query = "SELECT add_student(\(userID))"
            
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: [])
            cursor.close()
        } else {
            var query = "SELECT add_team_director(\(userID))"
            
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: [])
            cursor.close()
        }
    }
    
    func adminUpdateUser(
        with id: Int,
        phone: String,
        surname: String,
        name: String,
        patronymic: String?,
        birthdate: Date?,
        userTypeID: Int) throws {
            let query = "SELECT change_user_type(\(id), \(userTypeID));"
            
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: [])
            defer { cursor.close() }
            
            do {
                try updateUser(with: id, surname: surname, name: name, patronymic: patronymic, phone: phone, birthdate: birthdate, userTypeID: userTypeID)
            } catch { }
        }
    
    func deleteUser(with id: Int) throws {
        let query = "SELECT delete_user(\(id))"
        print(query)
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchUserType(with id: Int) throws -> UserType {
        let query = "SELECT * FROM user_type WHERE ID = \(id)"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let name = try columns[1].string()
            
            return UserType(id: id, name: name)
        }
        return UserType(id: 0, name: "")
    }
    
    func addNewUserType(name: String) throws {
        let query = "SELECT add_user_type('\(name)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateUserType(with id: Int, newName: String) throws {
        let query = "SELECT update_user_type(\(id), '\(newName)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func deleteUserType(with id: Int) throws {
        let query = "SELECT delete_user_type(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func deleteGroup(with id: Int) throws {
        let query = "SELECT delete_student_group(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateGroup(with id: Int, newName: String, newFaculty: String) throws {
        let query = "SELECT update_student_group(\(id), '\(newName)', '\(newFaculty)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func addGroup(with name: String, faculty: String) throws {
        let query = "SELECT add_student_group('\(name)', '\(faculty)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchTaskType(with id: Int) throws -> TaskType {
        let query = "SELECT * FROM task_type WHERE ID = \(id)"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let name = try columns[1].string()
            let ratePerHour = try columns[2].int()
            
            return TaskType(id: id, name: name, ratePerHour: String(ratePerHour))
        }
        return TaskType(id: 0, name: "", ratePerHour: "")
    }
    
    func updateTaskType(with id: Int, newName: String, ratePerHour: Int) throws {
        let query = "SELECT update_task_type(\(id), '\(newName)', \(ratePerHour))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func addNewTaskType(name: String, ratePerHour: Int) throws {
        let query = "SELECT add_task_type('\(name)', \(ratePerHour))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func deleteTaskType(with id: Int) throws {
        let query = "SELECT delete_task_type(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchAllTaskStatuses() throws -> [TaskStatus] {
        let query = "SELECT * FROM task_status"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var taskStatuses = [TaskStatus]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            
            let taskStatus = TaskStatus(id: id, name: name)
            taskStatuses.append(taskStatus)
        }
        
        return taskStatuses
    }
    
    func fetchTaskStatus(with id: Int) throws -> TaskStatus {
        let query = "SELECT * FROM task_status WHERE id = \(id)"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let name = try columns[1].string()
            
            let taskStatus = TaskStatus(id: id, name: name)
            return taskStatus
        }
        
        return TaskStatus(id: 0, name: "")
    }
    
    func addNewTaskStatus(name: String) throws {
        let query = "SELECT add_task_status('\(name)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateTaskStatus(with id: Int, newName: String) throws {
        let query = "SELECT update_task_status(\(id), '\(newName)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func deleteTaskStatus(with id: Int) throws {
        let query = "SELECT delete_task_status(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchTask(with id: Int) throws -> ConstructionTask {
        let query = "SELECT t.ID AS task_id, tt.name AS task_type, tt.id, t.hours, tt.rate_per_hour, ts.id, ts.name AS task_status, tm.id, tm.name AS team_name, t.start_date, t.end_date FROM task t JOIN task_type tt ON t.typeID = tt.ID JOIN task_status ts ON t.statusID = ts.ID LEFT JOIN team tm ON t.teamID = tm.ID WHERE t.id = \(id)"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let typeName = try columns[1].string()
            let typeID = try columns[2].int()
            let hours = try columns[3].int()
            let ratePerHour = try columns[4].int()
            let statusID = try columns[5].int()
            let statusName = try columns[6].string()
            let teamID = try columns[7].optionalInt()
            let teamName = try columns[8].optionalString()
            
            var startDate: Date? = nil
            let sDate = try columns[9].optionalDate()?.description
            if let date = sDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                startDate = dateFormatter.date(from: date)
            }
            
            var endDate: Date? = nil
            let eDate = try columns[10].optionalDate()?.description
            if let date = eDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                endDate = dateFormatter.date(from: date)
            }
            
            var team: Team? = Team(id: 0, name: "", countStudents: 0)
            if let id = teamID, let name = teamName {
                team = Team(id: id, name: name, countStudents: 0)
            }
            
            let task = ConstructionTask(id: id, taskType: TaskType(id: typeID, name: typeName, ratePerHour: String(ratePerHour)), countHours: String(hours), status: TaskStatus(id: statusID, name: statusName), team: team, startDate: startDate, endDate: endDate)
            return task
        }
        
        return ConstructionTask(id: 0, taskType: TaskType(id: 0, name: "", ratePerHour: ""), countHours: "", status: TaskStatus(id: 0, name: ""))
    }
    
    func addNewTask(typeID: Int, hours: Int, statusID: Int, teamID: Int?, startDate: Date?, endDate: Date?) throws {
        var startDateString: String? = nil
        var endDateString: String? = nil
        
        if let date = startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            startDateString = dateFormatter.string(from: date)
        }
        
        if let date = endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            endDateString = dateFormatter.string(from: date)
        }
        
        var newTeamID: Int? = nil
        if teamID != 0 || teamID != 0 {
            newTeamID = teamID
        }
        
        var query = ""
        
        if startDateString != nil && endDateString != nil && newTeamID != nil {
            query = "SELECT add_task(\(typeID), \(hours), \(statusID), \(teamID!), '\(startDateString!)', '\(endDateString!)')"
        } else if startDateString == nil && endDateString == nil && newTeamID != nil {
            query = "SELECT add_task(\(typeID), \(hours), \(statusID), \(teamID!), null, null)"
        } else if startDateString != nil && endDateString == nil && newTeamID != nil {
            query = "SELECT add_task(\(typeID), \(hours), \(statusID), \(teamID!), '\(startDateString!)', null)"
        } else if startDateString != nil && endDateString != nil && newTeamID == nil {
            query = "SELECT add_task(\(typeID), \(hours), \(statusID), \(teamID!), '\(startDateString!)', null)"
        } else if startDateString != nil && endDateString == nil && newTeamID == nil {
            query = "SELECT add_task(\(typeID), \(hours), \(statusID), null, '\(startDateString!)', null)"
        } else if startDateString == nil && endDateString == nil && newTeamID == nil {
            query = "SELECT add_task(\(typeID), \(hours), \(statusID))"
        }
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateTask(with id: Int, typeID: Int, hours: Int, statusID: Int, teamID: Int?, startDate: Date?, endDate: Date?) throws {
        var startDateString: String? = nil
        var endDateString: String? = nil
        
        if let date = startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            startDateString = dateFormatter.string(from: date)
        }
        
        if let date = endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            endDateString = dateFormatter.string(from: date)
        }
        
        var newTeamID: Int? = nil
        if teamID != 0 || teamID != 0 {
            newTeamID = teamID
        }
        
        var query = ""
        
        if startDateString != nil && endDateString != nil && newTeamID != nil {
            query = "SELECT update_task(\(id), \(typeID), \(hours), \(statusID), \(teamID!), '\(startDateString!)', '\(endDateString!)')"
        } else if startDateString == nil && endDateString == nil && newTeamID != nil {
            query = "SELECT update_task(\(id), \(typeID), \(hours), \(statusID), \(teamID!), null, null)"
        } else if startDateString != nil && endDateString == nil && newTeamID != nil {
            query = "SELECT update_task(\(id), \(typeID), \(hours), \(statusID), \(teamID!), '\(startDateString!)', null)"
        } else if startDateString != nil && endDateString != nil && newTeamID == nil {
            query = "SELECT update_task(\(id), \(typeID), \(hours), \(statusID), \(teamID!), '\(startDateString!)', null)"
        } else if startDateString != nil && endDateString == nil && newTeamID == nil {
            query = "SELECT update_task(\(id), \(typeID), \(hours), \(statusID), null, '\(startDateString!)', null)"
        } else if startDateString == nil && endDateString == nil && newTeamID == nil {
            query = "SELECT update_task(\(id), \(typeID), \(hours), \(statusID))"
        }
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func deleteTask(with id: Int) throws {
        let query = "SELECT delete_task(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func addNewTeamDirector(name: String, surname: String, patronymic: String, phone: String, birthdate: Date?, teamID: Int?) throws {
        let queryUserType = "SELECT id FROM user_type WHERE name = 'Руководитель команды'"

        let statementUserType = try connection.prepareStatement(text: queryUserType)
        defer { statementUserType.close() }
        
        let cursorUserType = try statementUserType.execute(parameterValues: [])
        defer { cursorUserType.close() }
        
        var userTypeID = 0
        
        for row in cursorUserType {
            let columns = try row.get().columns
            userTypeID = try columns[0].int()
        }
        
        try addNewUser(phone: phone, surname: surname, name: name, patronymic: patronymic, birthdate: birthdate, userTypeID: userTypeID, userTypeName: "Руководитель команды")
        
        let queryTeamDirectorID = "SELECT td.ID AS team_director_id FROM team_director td JOIN my_user u ON td.userID = u.ID JOIN team t ON td.teamID = t.ID WHERE u.phone = '\(phone)';"

        let statementTeamDirectorID = try connection.prepareStatement(text: queryTeamDirectorID)
        defer { statementTeamDirectorID.close() }
        
        let cursorTeamDirectorID = try statementTeamDirectorID.execute(parameterValues: [])
        defer { cursorTeamDirectorID.close() }
        
        var teamDirectorID = 0
        
        for row in cursorTeamDirectorID {
            let columns = try row.get().columns
            teamDirectorID = try columns[0].int()
        }
        
        var newTeamID: Int? = nil
        if teamID != 0 && teamID != nil {
            newTeamID = teamID
        }
        
        var query = ""
        
        if newTeamID != nil {
            query = "SELECT update_team_director(\(teamDirectorID), \(newTeamID!))"
        } else {
            query = "SELECT update_team_director(\(teamDirectorID))"
        }

        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateTeamDirector(with id: Int, userID: Int, newName: String, newSurname: String, newPatronymic: String, newPhone: String, newBirthdate: Date?, newTeamID: Int?) throws {
        let queryUserType = "SELECT id FROM user_type WHERE name = 'Руководитель команды'"
        
        let statementUserType = try connection.prepareStatement(text: queryUserType)
        defer { statementUserType.close() }
        
        let cursorUserType = try statementUserType.execute(parameterValues: [])
        defer { cursorUserType.close() }
        
        var userTypeID = 0
        
        for row in cursorUserType {
            let columns = try row.get().columns
            userTypeID = try columns[0].int()
        }
        
        try updateUser(with: userID, surname: newSurname, name: newName, patronymic: newPatronymic, phone: newPhone, birthdate: newBirthdate, userTypeID: userTypeID)
        
        var teamID: Int? = nil
        if newTeamID != 0 && newTeamID != nil {
            teamID = newTeamID
        }
        
        var query = ""
        
        if teamID != nil {
            query = "SELECT update_team_director(\(id), \(teamID!))"
        } else {
            query = "SELECT update_team_director(\(id))"
        }
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
        
    }
    
    func deleteTeamDirector(with id: Int, userID: Int) throws {
        let query = "SELECT delete_team_director(\(id), \(userID)"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func deleteStudent(with id: Int, userID: Int) throws {
        let query = "SELECT delete_student(\(id), \(userID))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func addNewStudent(name: String, surname: String, patronymic: String, phone: String, birthdate: Date?, teamID: Int?, groupID: Int?, isElder: Bool) throws {
        let queryUserType = "SELECT id FROM user_type WHERE name = 'Студент'"
        let statementUserType = try connection.prepareStatement(text: queryUserType)
        defer { statementUserType.close() }
        
        let cursorUserType = try statementUserType.execute(parameterValues: [])
        defer { cursorUserType.close() }
        
        var userTypeID = 0
        
        for row in cursorUserType {
            let columns = try row.get().columns
            userTypeID = try columns[0].int()
        }
        
        try addNewUser(phone: phone, surname: surname, name: name, patronymic: patronymic, birthdate: birthdate, userTypeID: userTypeID, userTypeName: "Студент")
        
        let queryStudentID = "SELECT student.ID FROM student JOIN my_user u ON student.userID = u.ID WHERE u.phone = '\(phone)';"
        let statementStudentID = try connection.prepareStatement(text: queryStudentID)
        defer { statementStudentID.close() }
        
        let cursorStudentID = try statementStudentID.execute(parameterValues: [])
        defer { cursorStudentID.close() }
        
        var studentID = 0
        
        for row in cursorStudentID {
            let columns = try row.get().columns
            studentID = try columns[0].int()
        }
        
        var newTeamID: Int? = nil
        if teamID != 0 && teamID != nil {
            newTeamID = teamID
        }
        
        var newGroupID: Int? = nil
        if groupID != 0 && groupID != nil {
            newGroupID = groupID
        }
        
        var query = ""
        
        if newTeamID != nil && newGroupID != nil {
            query = "SELECT update_student(\(studentID), \(isElder), \(newGroupID!), \(newTeamID!))"
        } else if newTeamID == nil && newGroupID != nil {
            query = "SELECT update_student(\(studentID), \(isElder), \(newGroupID!), null)"
        } else if newTeamID != nil && newGroupID == nil {
            query = "SELECT update_student(\(studentID), \(isElder), null, \(newTeamID!))"
        } else {
            query = "SELECT update_student(\(studentID), \(isElder), null, null)"
        }

        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateStudent(with id: Int, userID: Int, newName: String, newSurname: String, newPatronymic: String, newPhone: String, newBirthdate: Date?, newTeamID: Int?, newGroupID: Int?, isElder: Bool) throws {
        let queryUserType = "SELECT id FROM user_type WHERE name = 'Студент'"
        let statementUserType = try connection.prepareStatement(text: queryUserType)
        defer { statementUserType.close() }
        
        let cursorUserType = try statementUserType.execute(parameterValues: [])
        defer { cursorUserType.close() }
        
        var userTypeID = 0
        
        for row in cursorUserType {
            let columns = try row.get().columns
            userTypeID = try columns[0].int()
        }
        
        try updateUser(with: userID, surname: newSurname, name: newName, patronymic: newPatronymic, phone: newPhone, birthdate: newBirthdate, userTypeID: userTypeID)
        
        var teamID: Int? = nil
        if newTeamID != 0 && newTeamID != nil {
            teamID = newTeamID
        }
        
        var groupID: Int? = nil
        if newGroupID != 0 && newGroupID != nil {
            groupID = newGroupID
        }
        
        var query = ""
        
        if teamID != nil && groupID != nil {
            query = "SELECT update_student(\(id), \(isElder), \(groupID!), \(teamID!))"
        } else if teamID == nil && groupID != nil {
            query = "SELECT update_student(\(id), \(isElder), \(groupID!), null)"
        } else if teamID != nil && groupID == nil {
            query = "SELECT update_student(\(id), \(isElder), null, \(teamID!))"
        } else {
            query = "SELECT update_student(\(id), \(isElder), null, null)"
        }

        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchTeam(with id: Int) throws -> Team {
        let query = "SELECT team.ID AS team_id, team.name AS team_name, COUNT(student.ID) AS student_count FROM team LEFT JOIN student ON team.ID = student.teamID WHERE team.id = \(id) GROUP BY team.ID, team.name ORDER BY team.ID;"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            let countStudents = try columns[2].int()
            
            let team = Team(id: id, name: name, countStudents: countStudents)
            return team
        }
        
        return Team(id: 0, name: "", countStudents: 0)
    }
    
    func deleteTeam(with id: Int) throws {
        let query = "SELECT delete_team(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func addNewTeam(name: String) throws {
        let query = "SELECT add_team('\(name)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateTeam(with id: Int, newName: String) throws {
        let query = "SELECT update_team(\(id), '\(newName)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchAllStayingInTeams() throws -> [StayingInTeam] {
        let query = "SELECT sit.ID,  sit.studentID, u.surname, u.name, u.patronymic, sit.teamID, t.name AS team_name, sit.start_date, sit.end_date FROM staying_in_team sit JOIN team t ON sit.teamID = t.ID JOIN student s ON sit.studentID = s.ID JOIN my_user u ON s.userID = u.ID;"

        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var stayingInTeams = [StayingInTeam]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let studentID = try columns[1].int()
            let studentSurname = try columns[2].string()
            let studentName = try columns[3].string()
            let studentPatronymic = try columns[4].optionalString()
            let student = Student(id: studentID, userID: 0, name: studentName, surname: studentSurname, patronymic: studentPatronymic, phone: "")
            
            let teamID = try columns[5].int()
            let teamName = try columns[6].string()
            let team = Team(id: teamID, name: teamName, countStudents: 0)
            
            let sDate = try columns[7].date().description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var startDate = dateFormatter.date(from: sDate) ?? Date()
            
            
            var endDate: Date? = nil
            let eDate = try columns[8].optionalDate()?.description
            if let date = eDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                endDate = dateFormatter.date(from: date)
            }
            
            let stayingInTeam = StayingInTeam(id: id, team: team, student: student, startDate: startDate, endDate: endDate)
            stayingInTeams.append(stayingInTeam)
        }
        
        return stayingInTeams
    }
    
    func fetchStayingInTeam(with id: Int) throws -> StayingInTeam {
        let query = "SELECT sit.ID,  sit.studentID, u.surname, u.name, u.patronymic, sit.teamID, t.name AS team_name, sit.start_date, sit.end_date FROM staying_in_team sit JOIN team t ON sit.teamID = t.ID JOIN student s ON sit.studentID = s.ID JOIN my_user u ON s.userID = u.ID WHERE sit.id = \(id);"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let studentID = try columns[1].int()
            let studentName = try columns[2].string()
            let studentSurname = try columns[3].string()
            let studentPatronymic = try columns[4].optionalString()
            let student = Student(id: studentID, userID: 0, name: studentName, surname: studentSurname, patronymic: studentPatronymic, phone: "")
            
            let teamID = try columns[5].int()
            let teamName = try columns[6].string()
            let team = Team(id: teamID, name: teamName, countStudents: 0)
            
            let sDate = try columns[7].date().description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var startDate = dateFormatter.date(from: sDate) ?? Date()
            
            
            var endDate: Date? = nil
            let eDate = try columns[8].optionalDate()?.description
            if let date = eDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                endDate = dateFormatter.date(from: date)
            }
            
            let stayingInTeam = StayingInTeam(id: id, team: team, student: student, startDate: startDate, endDate: endDate)
            return stayingInTeam
        }
        
        return StayingInTeam(id: 0, team: Team(id: 0, name: "", countStudents: 0), student: Student(id: 0, userID: 0, name: "", surname: "", phone: ""), startDate: Date())
    }
    
    func addNewStayingInTeam(studentID: Int, teamID: Int, startDate: Date, endDate: Date?) throws {
        var startDateString: String?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDateString = dateFormatter.string(from: startDate)
        
        var endDateString: String? = nil
        
        if let date = endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            endDateString = dateFormatter.string(from: date)
        }
        
        var query = ""
        
        if endDateString != nil {
            query = "SELECT add_staying_in_team(\(teamID), \(studentID), '\(startDateString!)', '\(endDateString!)')"
        } else {
            query = "SELECT add_staying_in_team(\(teamID), \(studentID), '\(startDateString!)', null)"
        }
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func updateStayingInTeam(with id: Int, newStudentID: Int, newTeamID: Int, newStartDate: Date, newEndDate: Date?) throws {
        var startDateString: String?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startDateString = dateFormatter.string(from: newStartDate)
        
        var endDateString: String? = nil
        
        if let date = newEndDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            endDateString = dateFormatter.string(from: date)
        }
        
        var query = ""
        
        if endDateString != nil {
            query = "SELECT update_staying_in_team(\(id), \(newTeamID), \(newStudentID), '\(startDateString!)', '\(endDateString!)')"
        } else {
            query = "SELECT update_staying_in_team(\(id), \(newTeamID), \(newStudentID), '\(startDateString!)', null)"
        }
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func deleteStayingInTeam(with id: Int) throws {
        let query = "SELECT delete_staying_in_team(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        cursor.close()
    }
    
    func fetchFreeStudents() throws -> [Student] {
        let query = "SELECT s.ID AS student_id, u.ID AS user_id, u.surname, u.name, u.patronymic, u.birthdate, u.phone, s.is_elder, s.earnings, s.groupID, s.teamID FROM student s JOIN my_user u ON s.userID = u.ID WHERE s.teamID IS NULL;"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var students = [Student]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let userID = try columns[1].int()
            let surname = try columns[2].string()
            let name = try columns[3].string()
            let patronymic = try columns[4].optionalString() ?? ""
            
            let student = Student(id: id, userID: userID, name: name, surname: surname, patronymic: patronymic, phone: "")
            students.append(student)
        }
        return students
    }
    
    func fetchAllStayingInTeamsForStudent(with id: Int) throws -> [StayingInTeam] {
        let query = "SELECT sit.ID,  sit.studentID, u.surname, u.name, u.patronymic, sit.teamID, t.name AS team_name, sit.start_date, sit.end_date FROM staying_in_team sit JOIN team t ON sit.teamID = t.ID JOIN student s ON sit.studentID = s.ID JOIN my_user u ON s.userID = u.ID WHERE s.id = \(id);"

        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var stayingInTeams = [StayingInTeam]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let studentID = try columns[1].int()
            let studentSurname = try columns[2].string()
            let studentName = try columns[3].string()
            let studentPatronymic = try columns[4].optionalString()
            let student = Student(id: studentID, userID: 0, name: studentName, surname: studentSurname, patronymic: studentPatronymic, phone: "")
            
            let teamID = try columns[5].int()
            let teamName = try columns[6].string()
            let team = Team(id: teamID, name: teamName, countStudents: 0)
            
            let sDate = try columns[7].date().description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var startDate = dateFormatter.date(from: sDate) ?? Date()
            
            
            var endDate: Date? = nil
            let eDate = try columns[8].optionalDate()?.description
            if let date = eDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                endDate = dateFormatter.date(from: date)
            }
            
            let stayingInTeam = StayingInTeam(id: id, team: team, student: student, startDate: startDate, endDate: endDate)
            stayingInTeams.append(stayingInTeam)
        }
        
        return stayingInTeams
    }
    
    func fetchTeamSummary() throws -> [TeamSummary] {
        let query = "SELECT * FROM team_summary"

        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var teamSummary = [TeamSummary]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let teamName = try columns[1].string()
            let studentsCount = try columns[2].int()
            let averageEarnings = try columns[3].optionalInt()
            let date = try columns[4].optionalDate()?.description
            
            var latestStartDate: Date? = nil
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                latestStartDate = dateFormatter.date(from: date)
            }
            
            let team = TeamSummary(id: id, teamName: teamName, studentsCount: studentsCount, averageEarnings: averageEarnings, latestStayStart: latestStartDate)

            teamSummary.append(team)
        }
        
        return teamSummary
    }
    
    func fetchStudentsInBirthdateRange(firstNumber: Int, secondNumber: Int) throws -> [Student] {
        let query = "SELECT id, surname || ' ' || name || ' ' || patronymic AS full_name, birthdate FROM (SELECT * FROM my_user WHERE EXTRACT(YEAR FROM birthdate) BETWEEN \(firstNumber) AND \(secondNumber)) AS td;"

        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var students = [Student]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            let date = try columns[2].optionalDate()?.description
            
            var birthdate: Date? = nil
            if let date = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: date)
            }
            
            let student = Student(id: id, userID: 0, name: name, surname: "", birthdate: birthdate, phone: "")
            students.append(student)
        }
        
        return students
    }
    
    func fetchLargeTasks() throws -> [ConstructionTask] {
        let query = "SELECT task.ID, task_type.name AS task_type_name, task.hours, CAST((SELECT AVG(hours) FROM task) as int) AS overall_average_hours FROM task JOIN task_type ON task.typeID = task_type.ID WHERE task.hours > (SELECT AVG(hours) FROM task);"

        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        var tasks = [ConstructionTask]()
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            let hours = try columns[2].int()
            let overallAverageHours = try columns[3].int()
            
            let task = ConstructionTask(id: id, taskType: TaskType(id: 0, name: name, ratePerHour: String(overallAverageHours)), countHours: String(hours), status: TaskStatus(id: 0, name: ""))
            tasks.append(task)
        }
        
        return tasks
    }
}

