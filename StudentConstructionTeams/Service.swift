//
//  DatabaseConfiguration.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 21.12.2023.
//

import PostgresClientKit

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
    
    func fetchTeams() throws {
        let text = "SELECT * FROM team"
        let statement = try connection.prepareStatement(text: text)
        defer { statement.close() }
        
        let cursor = try statement.execute(parameterValues: [])
        defer { cursor.close() }
        
        for row in cursor {
            let columns = try row.get().columns
            let id = try columns[0].int()
            let name = try columns[1].string()
            let count_students = try columns[2].int()
            
            print(id, name, count_students)
        }
    }
}

