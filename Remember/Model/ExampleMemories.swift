//
//  ExampleMemories.swift
//  Remember
//
//  Created by Jan Huber on 21.10.22.
//

import Foundation
import SwiftUI
import MapKit

let historicExampleMemories: [Memory] = {

    var memories: [Memory] = []

    memories.append(Memory(name: String(localized: "First man on the moon"), date: Date(day: 21, month: 7, year: 1969), image: UIImage(named: "first_man_on_the_moon"), notes: String(localized: "First man on the moon (description)"), notificationsEnabled: false))

    /*memories.append(Memory(name: String(localized: "End of World War II"), date: Date(day: 2, month: 9, year: 1945), image: UIImage(named:"end_of_ww2"), coordinate: CLLocationCoordinate2D(latitude: 35.53403865636597, longitude: 139.88601380220527), notes: String(localized: "End of World War II (description)"), notificationsEnabled: false))*/

    memories.append(Memory(name: String(localized: "First Organ Transplant"), date: Date(day: 23, month: 12, year: 1954), image: UIImage(named: "first_organ_transplant"), coordinate: CLLocationCoordinate2D(latitude: 42.337781614023775, longitude: -71.10509755061052), notes: String(localized: "First Organ Transplant (description)"), notificationsEnabled: false))


    memories.append(Memory(name: String(localized: "Fall of the Berlin Wall"), date: Date(day: 9, month: 11, year: 1989), image: UIImage(named: "fall_of_the_berlin_wall"), coordinate: CLLocationCoordinate2D(latitude: 52.53514906634863, longitude: 13.389938633579044), notes: String(localized: "Fall of the Berlin Wall (description)"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "First Human in Space"), date: Date(day: 12, month: 4, year: 1961), image: UIImage(named: "yuri_gagarin"), notes: String(localized: "First Human in Space (description)"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "Martin Luther King’s \"I Have a Dream\" speech"), date: Date(day: 28, month: 8, year: 1963), image: UIImage(named: "matin_luther_king"), coordinate: CLLocationCoordinate2D(latitude: 38.889293632185215, longitude: -77.05016527332381), notes: String(localized: "Martin Luther King’s \"I Have a Dream\" speech (description)"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "Invention of the World Wide Web"), date: Date(day: 12, month: 3, year: 1989), image: UIImage(named: "world_wide_web"), coordinate: CLLocationCoordinate2D(latitude: 46.23306059461583, longitude: 6.055677054221739), notes: String(localized: "Invention of the World Wide Web (description)"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "Steve Jobs presents the first iPhone"), date: Date(day: 9, month: 1, year: 2007), image: UIImage(named: "steve_jobs"), coordinate: CLLocationCoordinate2D(latitude: 37.7843318589039, longitude: -122.40069000218438), notes: String(localized: "Steve Jobs presents the first iPhone (description)"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "Curiosity takes a selfie on Mars"), date: Date(day: 7, month: 9, year: 2012), image: UIImage(named: "curiosity"), notes: String(localized: "Curiosity takes a selfie on Mars (description)"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "Discovery of the Double Helix"), date: Date(day: 28, month: 2, year: 1953), image: UIImage(named: "dna"), coordinate: CLLocationCoordinate2D(latitude: 52.20918367734836, longitude: 0.0922546116964665), notes: String(localized: "Discovery of the Double Helix (description)"), notificationsEnabled: false))

    return memories
}()


let personalExampleMemories: [Memory] = {

    var memories: [Memory] = []

    memories.append(Memory(name: String(localized: "Wedding"), date: Date(day: 21, month: 7, year: 2018), image: UIImage(named: "wedding"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "Adoption of my cat Mittens"), date: Date(day: 12, month: 7, year: 2022), image: UIImage(named: "cat"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "Graduation"), date: Date(day: 10, month: 5, year: 2016), image: UIImage(named: "graduation"), notificationsEnabled: false))

    memories.append(Memory(name: String(localized: "Liam's first steps"), date: Date(day: 30, month: 6, year: 2022), image: UIImage(named: "first_steps"), notificationsEnabled: false))


    return memories
}()
