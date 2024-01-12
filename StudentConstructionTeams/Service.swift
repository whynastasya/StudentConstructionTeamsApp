//
//  DatabaseConfiguration.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 21.12.2023.
//

import PostgresClientKit
import Foundation

final class Service {
    
    static var service: Service {
        return Service()
    }
    
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
    
    func fetchStudentGroup(with id: Int) throws -> Group? {
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
        print(insertQuery)
        defer { insertStatement.close() }
        
        let insertCursor = try insertStatement.execute(parameterValues: [])
        defer { insertCursor.close() }
        
        let query = "SELECT ID FROM my_user WHERE phone = '\(phone)' AND password = '\(password)';"
        let statement = try connection.prepareStatement(text: query)
        print(query)
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
            print(query)
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
            print(query)
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
    
    func fetchAllStudent() {
        
    }
    
    func fetchAllTeamDirectors() {
        
    }
    
    func fetchAllUsers() throws -> [User] {
        let query = "SELECT * FROM my_user;"
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
            
            let user = User(
                id: id,
                name: name,
                surname: surname,
                patronymic: patronymic,
                birthdate: birthdate,
                phone: phone, 
                userType: UserType(id: 0, name: "")
            )
            users.append(user)
        }
        print(users)
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
        userTypeID: Int,
        password: String
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
        defer { cursor.close() }
    }
}
