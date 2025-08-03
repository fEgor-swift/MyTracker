import Foundation

struct Tracker {
    let id: UUID
    let name: String
    let color: String
    let emoji: String
    let schedule: [String]
}

struct TrackerCategory {
    let title: String
    var trackers: [Tracker]
}

struct TrackerRecord {
    let trackerId: UUID
    let date: Date
}

enum Day: String, CaseIterable, Hashable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"

    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }

    var order: Int {
        switch self {
        case .monday: 1
        case .tuesday: 2
        case .wednesday: 3
        case .thursday: 4
        case .friday: 5
        case .saturday: 6
        case .sunday: 7
        }
    }
}
