//
//  Event.swift
//  Event_Efrei
//
//  Created by CGalbon on 17/12/2022.
//

import Foundation
struct EventRecords: Codable{
    let records: [EventRecord]?
}
struct EventRecord: Codable, Identifiable {
    let id: String
    let createdTime: String
    let fields: Event
}
struct Event: Codable{
    let activity: String
    let type: String
    let start: Date
    let end: Date
    let location: String
    let speakers: [String]?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case activity = "Activity"
        case type = "Type"
        case start = "Start"
        case end = "End"
        case location = "Location"
        case speakers = "Speaker(s)"
        case notes = "Notes"
        }


}
struct SpeakerRecords:Codable{
    let records: [SpeakerRecord]?
}
struct SpeakerRecord:Codable, Identifiable, Hashable{
    static func == (lhs: SpeakerRecord, rhs: SpeakerRecord) -> Bool {
        return lhs.fields == rhs.fields
    }
    func hash(into hasher: inout Hasher) {
            return hasher.combine(id)
        }

    let id:String
    let createdTime:String
    let fields:Speaker
    
}
struct Speaker:Codable{
    static func == (lhs: Speaker, rhs:Speaker) -> Bool{
        return lhs.name == rhs.name &&
        lhs.role == rhs.role &&
        lhs.company == rhs.company &&
        lhs.phone == rhs.phone &&
        lhs.email == rhs.email
    }
    let name: String
    let speaking_at: [String]?
    let role: String
    let company: String
    let phone: String
    let email: String
    let confirmed: Bool?
    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case speaking_at = "Speaking at"
        case role = "Role"
        case company = "Company"
        case phone = "Phone"
        case email = "Email"
        case confirmed = "Confirmed?"
        }

}

//https://stackoverflow.com/questions/46458487/how-to-convert-a-date-string-with-optional-fractional-seconds-using-codable-in-s
extension Formatter {
    static let iso8601withFractionalSeconds: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let customISO8601 = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = Formatter.iso8601withFractionalSeconds.date(from: string) ?? Formatter.iso8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}

let EventTypes=[
    "Meal",
    "Networking",
    "Keynote",
    "Panel",
    "Workshop",
    "Breakout session"
]
let EmojiEventTypes = [
    "Meal":"🌭",
    "Networking":"💼",
    "Keynote":"🗒",
    "Panel":"💻",
    "Workshop":"🛠",
    "Breakout session":"☕️",
    "Default" : "❓"
]
