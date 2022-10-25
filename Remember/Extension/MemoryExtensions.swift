//
//  Memory+Codable.swift
//  Remember
//
//  Created by Jan Huber on 21.10.22.
//

import Foundation

extension Memory: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, name, date, latitude, longitude, notificationsEnabled, notes, isMarkedForDeletion
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(notificationsEnabled, forKey: .notificationsEnabled)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(notes, forKey: .notes)
        try container.encode(isMarkedForDeletion, forKey: .isMarkedForDeletion)


    }

}
