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
    
    func fetchStudent(with userID: Int) throws -> Student? {
        let query = "SELECT student.ID AS student_id, my_user.ID AS user_id, my_user.surname, my_user.name, my_user.patronymic, my_user.birthdate, my_user.phone, student.is_elder, student.earnings, student_group.id AS group_id, student_group.name AS group_name, student_group.faculty, team.id AS team_id, team.name AS team_name, COUNT(*) AS students_in_team FROM student JOIN my_user ON student.userID = my_user.ID LEFT JOIN student_group ON student.groupID = student_group.ID LEFT JOIN team ON student.teamID = team.ID WHERE my_user.id = \(userID) GROUP BY student.ID, my_user.ID, student_group.ID, team.ID;"
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
            
            var group: Group? = nil
            if let id = groupID, let name = groupName, let faculty = faculty{
                group = Group(id: id, name: name, faculty: faculty)
            }
            
            var team: Team? = nil
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
        let query = "SELECT team_director.ID AS team_director_id, my_user.ID AS user_id, my_user.surname, my_user.name, my_user.patronymic, my_user.birthdate, my_user.phone, team.id AS team_id, team.name AS team_name, COUNT(student.ID) AS students_in_team FROM team_director JOIN my_user ON team_director.userID = my_user.ID LEFT JOIN team ON team_director.teamID = team.ID LEFT JOIN student ON student.teamID = team.ID WHERE my_user.id = \(userID) GROUP BY team_director.ID, my_user.ID, team.ID;"
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
            
            var team: Team? = nil
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
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', '\(password)', \(userTypeID), '\(patronymic)', null)"
        } else if birthdateString != nil && patronymic == "" {
            insertQuery = "SELECT add_my_user('\(surname)', '\(name)', '\(phone)', '\(password)', \(userTypeID), '', '\(birthdateString)')"
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
            defer { cursor.close() }
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
            defer { cursor.close() }
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
        let query = "SELECT * FROM student_group;"
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
            
            let group = Group(id: id, name: name, faculty: faculty)
            groups.append(group)
        }
        
        return groups
    }
    
    func fetchAllStudents() {
        
    }
    
    func fetchAllTeamDirectors() {
        
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
    
    func fetchAllTask() {
        
    }
    
    func fetchAllTaskTypes() {
        
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
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
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
        defer { cursor.close() }
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
            
            let generalInformation = GeneralInformation(taskType: TaskType(id: 0, name: taskType, ratePerHour: 0), startDate: startDate)
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
        defer { cursor.close() }
    }
    
    func fetchFreeTeamsForTeamDirector(with userID: Int) throws -> [Team] {
        let query = "SELECT team.name AS team_name, COUNT(student.ID) AS participants_count FROM team LEFT JOIN team_director ON team.ID = team_director.teamID LEFT JOIN my_user AS director_user ON team_director.userID = director_user.ID LEFT JOIN student ON team.ID = student.teamID WHERE director_user.ID = \(userID) GROUP BY team.ID, team.name;"
        
        var teams = [Team]()
        
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
            defer { cursor.close() }
        } else {
            var query = "SELECT add_team_director(\(userID))"
            
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: [])
            defer { cursor.close() }
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
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
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
        defer { cursor.close() }
    }
    
    func updateUserType(with id: Int, newName: String) throws {
        let query = "SELECT update_user_type(\(id), '\(newName)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
    }
    
    func deleteUserType(with id: Int) throws {
        let query = "SELECT delete_user_type(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
    }
    
    func deleteGroup(with id: Int) throws {
        let query = "SELECT delete_student_group(\(id))"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
    }
    
    func updateGroup(with id: Int, newName: String, newFaculty: String) throws {
        let query = "SELECT update_student_group(\(id), '\(newName)', '\(newFaculty)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
    }
    
    func addGroup(with name: String, faculty: String) throws {
        let query = "SELECT add_student_group('\(name)', '\(faculty)')"
        
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
    }
}
