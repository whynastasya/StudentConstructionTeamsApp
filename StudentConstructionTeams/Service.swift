//
//  DatabaseConfiguration.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 21.12.2023.
//

import PostgresClientKit
import Foundation

final class Service {
    private let connection: Connection
    
    init() {
        var configuration = ConnectionConfiguration()
        configuration.host = "127.0.0.1"
        configuration.port = 5432
        configuration.database = "StudentConstructionTeams"
        configuration.user = "nastasya"
        configuration.credential = .trust
        configuration.ssl = false
        
        connection = try! Connection(configuration: configuration)
    }
    
    func verificateUser(phone: String, password: String) throws -> (any UserProtocol)? {
        var user = User(id: 0, name: "", surname: "", patronymic: "", phone: "")
        
        let query = "SELECT * FROM my_user WHERE phone = '\(phone)' AND password = '\(password)';"
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
            if bdate != nil {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                birthdate = dateFormatter.date(from: bdate!)
            }
            
            let phone = try columns[5].string()
            
            user = User(
                id: id,
                name: name,
                surname: surname,
                patronymic:  patronymic ?? "",
                birthdate: birthdate,
                phone: phone
            )
            print(user)
        }
        
        let studentQuery = "SELECT * FROM student WHERE ID = \(user.id)"
        let studentStatement = try self.connection.prepareStatement(text: studentQuery)
        defer { studentStatement.close() }
        
        let studentCursor = try studentStatement.execute(parameterValues: [])
        defer { studentCursor.close() }
        
        for row in studentCursor {
            let columns = try row.get().columns
            let isElder = try columns[1].bool()
            let earnings = try columns[2].int()
            let groupID = try columns[3].int()
            let teamID = try columns[4].int()
            
            let group = try fetchStudentGroup(with: groupID)
            let team = try fetchUserTeam(with: teamID)
            
            let student = Student(
                id: user.id,
                name: user.name,
                surname: user.surname,
                patronymic: user.patronymic,
                birthdate: user.birthdate,
                earnings: earnings,
                phone: user.phone,
                isElder: isElder,
                group: group,
                team: team
            )
            
            if user.id == 0 {
                return nil
            }
            
            return student
        }
        
        let teamDirectorQuery = "SELECT * FROM team_director WHERE ID = \(user.id)"
        let teamDirectorStatement = try self.connection.prepareStatement(text: teamDirectorQuery)
        defer { teamDirectorStatement.close() }
        
        let teamDirectorCursor = try teamDirectorStatement.execute(parameterValues: [])
        defer { teamDirectorStatement.close() }
        
        for row in teamDirectorCursor {
            let columns = try row.get().columns
            let teamID = try columns[1].int()
            
            let team = try fetchUserTeam(with: teamID)
            
            let teamDirector = TeamDirector(
                id: user.id,
                name: user.name,
                surname: user.surname,
                patronymic: user.patronymic,
                birthdate: user.birthdate,
                phone: user.phone,
                team: team
            )
            
            return teamDirector
        }
        
        return user
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
    
    func fetchUserTeam(with id: Int) throws -> Team? {
        let query = "SELECT * FROM team WHERE ID = \(id);"
        let statement = try connection.prepareStatement(text: query)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let name = try columns[1].string()
            let countStudents = try columns[2].int()
            
            let team = Team(id: id, name: name, countStudents: countStudents)
            return team
        }
        
        return Team(id: 0, name: "", countStudents: 0)
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

        if birthdate != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthdateString = dateFormatter.string(from: birthdate!)
        }
        
        var insertQuery = ""
        
        if birthdateString != nil && patronymic != "" {
            insertQuery = "INSERT INTO my_user (phone, password, surname, name, patronymic, birthdate) VALUES ('\(phone)', '\(password)', '\(surname)', '\(name)', '\(patronymic!)', '\(birthdateString!)');"
        } else if birthdateString == nil && patronymic != "" {
            insertQuery = "INSERT INTO my_user (phone, password, surname, name, patronymic) VALUES ('\(phone)', '\(password)', '\(surname)', '\(name)', '\(patronymic!)');"
        } else if birthdateString != nil && patronymic == "" {
            insertQuery = "INSERT INTO my_user (phone, password, surname, name, birthdate) VALUES ('\(phone)', '\(password)', '\(surname)', '\(name)', '\(birthdateString!)');"
        } else if birthdateString == nil && patronymic == "" {
            insertQuery = "INSERT INTO my_user (phone, password, surname, name) VALUES ('\(phone)', '\(password)', '\(surname)', '\(name)');"
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
                query = "INSERT INTO student (ID) VALUES (\(userID));"
            } else if groupID == 0 {
                query = "INSERT INTO student (ID, groupID) VALUES (\(userID), \(groupID!));"
            } else if teamID == 0 {
                query = "INSERT INTO student (ID, teamID) VALUES (\(userID), \(teamID!);"
            } else {
                query = "INSERT INTO student (ID, teamID, groupID) VALUES (\(userID), \(teamID!), \(groupID!));"
            }
            
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: [])
            defer { cursor.close() }
        } else {
            var query = ""
            if teamID == 0 {
                query = "INSERT INTO team_director (ID) VALUES (\(userID));"
            } else {
                query = "INSERT INTO team_director (ID, teamID) VALUES (\(userID), \(teamID!));"
            }
            
            let statement = try connection.prepareStatement(text: query)
            defer { statement.close() }
            
            let cursor = try statement.execute(parameterValues: [])
            defer { cursor.close() }
        }
    }
    
    func fetchAllTeams() throws -> [Team] {
        let query = "SELECT * FROM team;"
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
                phone: phone
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
}
