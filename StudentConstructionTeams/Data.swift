//
//  Data.swift
//  StudentConstructionTeams
//
//  Created by nastasya on 16.12.2023.
//

import Foundation

var students =
    [Student(id: 1, name: "Настасья", surname: "Григорчук", patronymic: "Тимофеевна", birthdate: Date(), earnings: 23456, phone: "89260819584", isElder: true, team: Team(id: 23, name: "Cats", countStudents: 34)),
     Student(id: 2, name: "Настасья", surname: "Григорчук", patronymic: "Тимофеевна", birthdate: Date(), earnings: 23456, phone: "89260819584", isElder: false, group: Group(id: 3, name: "02-21", faculty: "fdsdff"), team: Team(id: 23, name: "Cats", countStudents: 34)),
     Student(id: 3, name: "Настасья", surname: "", patronymic: "Тимофеевна", birthdate: nil, earnings: 23456, phone: "89260819584", isElder: true, group: Group(id: 3, name: "02-21", faculty: "fdsdff"))]

var taskTypes = [TaskType(id: 1, name: "Побелка", ratePerHour: 234),
                TaskType(id: 2, name: "Уборка", ratePerHour: 323),
                TaskType(id: 3, name: "Мусор", ratePerHour: 0),
                TaskType(id: 4, name: "Шпаклевка", ratePerHour: 7654),
                TaskType(id: 5, name: "Покраска", ratePerHour: 33),
                TaskType(id: 6, name: "Говно", ratePerHour: 2334),
                TaskType(id: 7, name: "Моча", ratePerHour: 23144144)
]

var tasks = [ConstructionTask(id: 1, taskType: taskTypes[0], countHours: 45, status: .completed, team: Team(id: 1, name: "dogs", countStudents: 34), startDate: Date(), endDate: Date()),
             ConstructionTask(id: 2, taskType: taskTypes[5], countHours: 425, status: .inProgress, team: Team(id: 2, name: "cats", countStudents: 34), startDate: Date(), endDate: Date()),
             ConstructionTask(id: 3, taskType: taskTypes[3], countHours: 4, status: .free, team: Team(id: 3, name: "rats", countStudents: 34), startDate: Date(), endDate: Date()),
             ConstructionTask(id: 4, taskType: taskTypes[2], countHours: 45, status: .inProgress, team: Team(id: 4, name: "govno", countStudents: 34), startDate: Date(), endDate: Date()),
             ConstructionTask(id: 5, taskType: taskTypes[1], countHours: 435, status: .completed, team: Team(id: 1, name: "dogs", countStudents: 34), startDate: Date(), endDate: Date()),
]

var teamDirectors = [TeamDirector(id: 1, name: "Дима", surname: "Кулич", patronymic: "", birthdate: Date(), phone: "3456789", team: Team(id: 1, name: "ksfks", countStudents: 23)),
                     TeamDirector(id: 2, name: "Дима", surname: "Цвырик", patronymic: "", birthdate: Date(), phone: "3456789", team: Team(id: 2, name: "ksвывfks", countStudents: 23)),
                     TeamDirector(id: 3, name: "Дима", surname: "Лосяш", patronymic: "", birthdate: Date(), phone: "3456789", team: Team(id: 3, name: "123456нs", countStudents: 23)),
                     TeamDirector(id: 4, name: "Дима", surname: "Садычок", patronymic: "", birthdate: Date(), phone: "3456789", team: Team(id: 4, name: "говно", countStudents: 23))
]

var users = [User(id: 1, name: "Дима", surname: "Кулич", patronymic: "", birthdate: Date(), phone: "3456789", team: Team(id: 1, name: "ksfks", countStudents: 23)),
             User(id: 2, name: "Дима", surname: "Цвырик", patronymic: "", birthdate: Date(), phone: "3456789", team: Team(id: 2, name: "ksвывfks", countStudents: 23)),
             User(id: 3, name: "Дима", surname: "Лосяш", patronymic: "", birthdate: Date(), phone: "3456789", team: Team(id: 3, name: "123456нs", countStudents: 23)),
             User(id: 4, name: "Дима", surname: "Садычок", patronymic: "", birthdate: Date(), phone: "3456789", team: Team(id: 4, name: "говно", countStudents: 23))
]

var groups = [Group(id: 1, name: "02-21", faculty: "fklfklnf"),
              Group(id: 2, name: "02-23", faculty: "234"),
              Group(id: 3, name: "03", faculty: "fds"),
              Group(id: 4, name: "01", faculty: "saffsafasfasf"),
]

var teams = [Team(id: 1, name: "cats", countStudents: 543),
             Team(id: 2, name: "dogs", countStudents: 34),
             Team(id: 3, name: "govno", countStudents: 4),
             Team(id: 4, name: "pigs", countStudents: 543133),
             Team(id: 5, name: "rats", countStudents: 6),
]

var stayingInTeam = [StayingInTeam(id: 1, team: teams[2], user: users[2], startDate: Date(), endDate: Date()),
                     StayingInTeam(id: 2, team: teams[1], user: users[0], startDate: Date()),
                     StayingInTeam(id: 3, team: teams[0], user: users[3], startDate: Date(), endDate: Date()),
                     StayingInTeam(id: 4, team: teams[4], user: users[1], startDate: Date()),
                     StayingInTeam(id: 5, team: teams[2], user: users[1], startDate: Date(), endDate: Date())
]

var earningsOnTeams: [EarningsOnTeams] = [EarningsOnTeams(teamName: "gfds", earnings: 1234),
                                          EarningsOnTeams(teamName: "2", earnings: 23),
                                          EarningsOnTeams(teamName: "333", earnings: 365),
                                          EarningsOnTeams(teamName: "444", earnings: 5435),
                                          EarningsOnTeams(teamName: "55", earnings: 2343),
]

var earningsOnMonths = [EarningsOnMonths(month: .january, earnings: 204),
                        EarningsOnMonths(month: .february, earnings: 124),
                        EarningsOnMonths(month: .march, earnings: 765),
                        EarningsOnMonths(month: .april, earnings: 345),
                        EarningsOnMonths(month: .may, earnings: 567),
                        EarningsOnMonths(month: .june, earnings: 1007),
                        EarningsOnMonths(month: .jule, earnings: 234),
                        EarningsOnMonths(month: .august, earnings: 654),
                        EarningsOnMonths(month: .september, earnings: 678),
                        EarningsOnMonths(month: .october, earnings: 145),
                        EarningsOnMonths(month: .november, earnings: 204),
                        EarningsOnMonths(month: .december, earnings: 764),
]

var completedTasksOnTeams = [CompletedTasksOnTeams(count: 7, teamName: "111"),
                             CompletedTasksOnTeams(count: 15, teamName: "222"),
                             CompletedTasksOnTeams(count: 3, teamName: "333"),
                             CompletedTasksOnTeams(count: 9, teamName: "444"),
                             CompletedTasksOnTeams(count: 10, teamName: "555")
]

var completedTasksOnMonths = [CompletedTasksOnMonths(count: 12, month: .january),
                              CompletedTasksOnMonths(count: 43, month: .february),
                              CompletedTasksOnMonths(count: 87, month: .march),
                              CompletedTasksOnMonths(count: 120, month: .april),
                              CompletedTasksOnMonths(count: 24, month: .may),
                              CompletedTasksOnMonths(count: 56, month: .june),
                              CompletedTasksOnMonths(count: 89, month: .jule),
                              CompletedTasksOnMonths(count: 34, month: .august),
                              CompletedTasksOnMonths(count: 45, month: .september),
                              CompletedTasksOnMonths(count: 90, month: .october),
                              CompletedTasksOnMonths(count: 23, month: .november),
                              CompletedTasksOnMonths(count: 65, month: .december)
]
