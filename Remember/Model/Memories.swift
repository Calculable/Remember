//
//  Model.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation
import UIKit
import MapKit

class Memories: ObservableObject {
    
    @Published private(set) var memories: [Memory] = []
    let notificationHelper = NotificationHelper()

    
    var availableMemories: [Memory] {
        memories.filter {
            !$0.isMarkedForDeletion
        }
    }
    
    var memoriesMarkedForDeletion: [Memory] {
        memories.filter {
            $0.isMarkedForDeletion
        }
    }
    
    
    init() {
        do {
            memories = try Bundle.main.decode(getSavePath())
        } catch {
            print("Existing memories not found. App probably oppened for the first time")
            print(error.localizedDescription)
            print("Add example memories")
            addExampleMemories()
        }
        
    }
    
    func getSavePath() -> URL {
        getDocumentsDirectory().appendingPathComponent("memories.json")
    }
    
    func addExampleMemories() {

       
        
        memories.append(Memory(name: "First man on the moon", date: Date(day: 21, month: 7, year: 1969), image: UIImage(named:"first_man_on_the_moon"), notes: "Apollo 11 was the American spaceflight that first landed humans on the Moon. Commander Neil Armstrong and lunar module pilot Buzz Aldrin landed the Apollo Lunar Module Eagle on July 20, 1969, at 20:17 UTC, and Armstrong became the first person to step onto the Moon's surface six hours and 39 minutes later, on July 21 at 02:56 UTC. Aldrin joined him 19 minutes later, and they spent about two and a quarter hours together exploring the site they had named Tranquility Base upon landing. Armstrong and Aldrin collected 47.5 pounds (21.5 kg) of lunar material to bring back to Earth as pilot Michael Collins flew the Command Module Columbia in lunar orbit, and were on the Moon's surface for 21 hours, 36 minutes before lifting off to rejoin Columbia.\n\nImage Credit: NASA on Unsplash\n\nSource: Apollo 11. (2022, 09 15). In Wikipedia. https://de.wikipedia.org/w/index.php?title=Apollo_11&oldid=226190691", notificationsEnabled: false))

        memories.append(Memory(name: "End of World War II", date: Date(day: 2, month: 9, year: 1945), image: UIImage(named:"end_of_ww2"), coordinate: CLLocationCoordinate2D(latitude: 35.53403865636597, longitude: 139.88601380220527), notes: "The war in Europe concluded with the liberation of German-occupied territories and the invasion of Germany by the Western Allies and the Soviet Union, culminating in the fall of Berlin to Soviet troops, Hitler's suicide, and the German unconditional surrender on 8 May 1945. Germany signed the surrender document on 9 May 1945. Following the refusal of Japan to surrender on the terms of the Potsdam Declaration (issued 26 July 1945), the United States dropped the first atomic bombs on the Japanese cities of Hiroshima, on 6 August, and Nagasaki, on 9 August. Faced with an imminent invasion of the Japanese archipelago, the possibility of additional atomic bombings, and the Soviet Union's declared entry into the war against Japan on the eve of invading Manchuria, Japan announced on 10 August its intention to surrender, leading to the de facto end of World War II. Japan signed the surrender document on 2 September 1945.\n\nSource: World War II. (2022, 09 17). In Wikipedia. https://en.wikipedia.org/w/index.php?title=World_War_II&oldid=1110773768", notificationsEnabled: false))

        memories.append(Memory(name: "First Organ Transplant", date: Date(day: 23, month: 12, year: 1954), image: UIImage(named:"first_organ_transplant"), coordinate: CLLocationCoordinate2D(latitude: 42.337781614023775, longitude: -71.10509755061052), notes: "In 1954, the first ever successful transplant of any organ was done at the Brigham & Women's Hospital in Boston, Ma. The surgery was performed by Dr. Joseph Murray, who received the Nobel Prize in Medicine for his work. The success of this transplant was mostly due to the family relation between the recipient, a Richard Herrick of Maine, and his donor and identical twin brother Ronald. Richard Herrick was in the Navy and became severely ill with acute renal failure. His brother Ronald donated his kidney to Richard, and Richard lived on for another eight years. Prior to this case, transplant recipients did not survive for more than thirty days. Their close family relation meant there was no need for anti-rejection medications, which was not known until this time, so the case shed light on the cause of rejection and of possible anti-rejection medicine.\n\nSource: Organ transplantation. (2022, 08 30). In Wikipedia. https://en.wikipedia.org/w/index.php?title=Organ_transplantation&oldid=1107612240", notificationsEnabled: false))

        memories.append(Memory(name: "Fall of the Berlin Wall", date: Date(day: 9, month: 11, year: 1989), image: UIImage(named:"fall_of_the_berlin_wall"), coordinate: CLLocationCoordinate2D(latitude: 52.53514906634863, longitude: 13.389938633579044), notes: "The fall of the Berlin Wall (German: Mauerfall) during the Peaceful Revolution, was a pivotal event in world history which marked the falling of the Iron Curtain and one of the series of events that started the fall of communism in Eastern and Central Europe, preceded by the Solidarity Movement in Poland. The fall of the inner German border took place shortly afterwards. An end to the Cold War was declared at the Malta Summit three weeks later and the German reunification took place in October the following year.\n\nPhoto Credits: Lear 21 at English Wikipedia [GFDL or CC BY-SA 3.0 ], via Wikimedia Commons\n\nSource: Fall of the Berlin Wall. (2022, 09 09). In Wikipedia. https://en.wikipedia.org/w/index.php?title=Fall_of_the_Berlin_Wall&oldid=1109373914", notificationsEnabled: false))

        memories.append(Memory(name: "First Human in Space", date: Date(day: 12, month: 4, year: 1961), image: UIImage(named:"yuri_gagarin"), notes: "Yuri Alekseyevich Gagarin was a Soviet pilot and cosmonaut who became the first human to journey into outer space. Travelling in the Vostok 1 capsule, Gagarin completed one orbit of Earth on 12 April 1961. By achieving this major milestone in the Space Race he became an international celebrity, and was awarded many medals and titles, including Hero of the Soviet Union, his nation's highest honour.\n\nSource: Yuri Gagarin. (2022, 08 26). In Wikipedia. https://en.wikipedia.org/w/index.php?title=Yuri_Gagarin&oldid=1106725309", notificationsEnabled: false))

        memories.append(Memory(name: "Martin Luther King’s \"I Have a Dream\" speech", date: Date(day: 28, month: 8, year: 1963), image: UIImage(named:"matin_luther_king"), coordinate: CLLocationCoordinate2D(latitude: 38.889293632185215, longitude: -77.05016527332381), notes: "\"I Have a Dream\" is a public speech that was delivered by American civil rights activist and Baptist minister, Martin Luther King Jr., during the March on Washington for Jobs and Freedom on August 28, 1963. In the speech, King called for civil and economic rights and an end to racism in the United States. Delivered to over 250,000 civil rights supporters from the steps of the Lincoln Memorial in Washington, D.C., the speech was a defining moment of the civil rights movement and among the most iconic speeches in American history.\n\nSource: I Have a Dream. (2022, 08 22). In Wikipedia. https://en.wikipedia.org/w/index.php?title=I_Have_a_Dream&oldid=1106011412", notificationsEnabled: false))

        memories.append(Memory(name: "Invention of the World Wide Web", date: Date(day: 12, month: 3, year: 1989), image: UIImage(named:"world_wide_web"), coordinate: CLLocationCoordinate2D(latitude: 46.23306059461583, longitude: 6.055677054221739), notes: "Tim Berners-Lee invented the World Wide Web while working at CERN in 1989, applying the concept of hyperlinking that had by then existed for some decades. He developed the first web server, the first web browser, and a document formatting protocol, called Hypertext Markup Language (HTML). After publishing the markup language in 1991, and releasing the browser source code for public use in 1993, many other web browsers were soon developed, with Marc Andreessen's Mosaic (later Netscape Navigator), being particularly easy to use and install, and often credited with sparking the Internet boom of the 1990s. It was a graphical browser which ran on several popular office and home computers, bringing multimedia content to non-technical users by including images and text on the same page.\n\nSource: History of the World Wide Web. (2022, 09 16). In Wikipedia. https://en.wikipedia.org/w/index.php?title=History_of_the_World_Wide_Web&oldid=1110565125", notificationsEnabled: false))
        
        memories.append(Memory(name: "Steve Jobs presents the first iPhone", date: Date(day: 9, month: 1, year: 2007), image: UIImage(named:"steve_jobs"), coordinate: CLLocationCoordinate2D(latitude: 37.7843318589039, longitude: -122.40069000218438), notes: "The iPhone (retrospectively referred to unofficially as the iPhone 2G, iPhone 1 or original iPhone) is the first iPhone model and the first smartphone designed and marketed by Apple Inc. Development of the iPhone as a product began in 2005 and continued in complete secrecy until its public unveiling. The device broke with prevailing mobile phone designs by eliminating most physical hardware buttons, and eschewing a stylus for its finger-friendly touch interface, featuring instead only a few physical buttons and a touch screen. It featured quad-band GSM cellular connectivity with GPRS and EDGE support for data transfer, and it made use of continuous internet access and onboard processing to support features unrelated to voice communication. The iPhone quickly became Apple's most successful product, with later generations propelling it to become the most profitable company at the time.\n\nImage Credit: Apple\n\nSource: iPhone (1st generation). (2022, 09 13). In Wikipedia. https://en.wikipedia.org/w/index.php?title=IPhone_(1st_generation)&oldid=1110091524", notificationsEnabled: false))

        memories.append(Memory(name: "Curiosity takes a selfie on Mars", date: Date(day: 7, month: 9, year: 2012), image: UIImage(named:"curiosity"), notes: "The first space selfie on another planet was taken by the Curiosity rover. It was taken while the clear dust cover of the lens was closed giving a blurry image. The image was slightly modified and posted on its Facebook account on with the message: \n\n\"Hello, Gorgeous! Snapped this self portrait while inspecting my MAHLI camera with its dust cover intentionally left on. This was a test to make sure the cover, its hinge the area it sweeps when it opens are clear of debris.\"\n\nCuriosity is a car-sized Mars rover designed to explore the Gale crater on Mars as part of NASA's Mars Science Laboratory (MSL) mission. Curiosity was launched from Cape Canaveral (CCAFS) on 26 November 2011, at 15:02:00 UTC and landed on Aeolis Palus inside Gale crater on Mars on 6 August 2012, 05:17:57 UTC. The Bradbury Landing site was less than 2.4 km (1.5 mi) from the center of the rover's touchdown target after a 560 million km (350 million mi) journey.\n\nMission goals include an investigation of the Martian climate and geology, assessment of whether the selected field site inside Gale has ever offered environmental conditions favorable for microbial life (including investigation of the role of water), and planetary habitability studies in preparation for human exploration.\n\nImage Credit: NASA / JPL-Caltech / MSSS.\n\nSource: Curiosity (rover). (2022, 08 07). In Wikipedia. https://en.wikipedia.org/w/index.php?title=Curiosity_(rover)&oldid=1102885872\n\nSource: Space selfie. (2022, 09 01). In Wikipedia. https://en.wikipedia.org/w/index.php?title=Space_selfie&oldid=1107956477", notificationsEnabled: false))

        memories.append(Memory(name: "Discovery of the Double Helix", date: Date(day: 28, month: 2, year: 1953), image: UIImage(named:"dna"), coordinate: CLLocationCoordinate2D(latitude: 52.20918367734836, longitude: 0.0922546116964665), notes: "The discovery in 1953 of the double helix, the twisted-ladder structure of deoxyribonucleic acid (DNA), by James Watson and Francis Crick marked a milestone in the history of science and gave rise to modern molecular biology, which is largely concerned with understanding how genes control the chemical processes within cells. In short order, their discovery yielded ground-breaking insights into the genetic code and protein synthesis. During the 1970s and 1980s, it helped to produce new and powerful scientific techniques, specifically recombinant DNA research, genetic engineering, rapid gene sequencing, and monoclonal antibodies, techniques on which today's multi-billion dollar biotechnology industry is founded. Major current advances in science, namely genetic fingerprinting and modern forensics, the mapping of the human genome, and the promise, yet unfulfilled, of gene therapy, all have their origins in Watson and Crick's inspired work. The double helix has not only reshaped biology, it has become a cultural icon, represented in sculpture, visual art, jewelry, and toys.\n\nImage Credit: Warren Umoh on Unsplash\n\nSource: \"The Discovery of the Double Helix, 1951-1953,\" Francis Crick - Profiles in Science, last modified March 12, 2019, accessed September 17, 2022, https://profiles.nlm.nih.gov/spotlight/sc/feature/doublehelix.", notificationsEnabled: false))

        
        sortMemories()
        save()
    }
    
    func addMemory(_ newMemory: Memory) {
        memories.append(newMemory)
        sortMemories()
        save()
    }
    
    func sortMemories() {
        memories.sort()
        memories.reverse()
    }
    
    func removeAllMemories() {
        memories = []
        addExampleMemories()
    }
    
    func markForDeletion(_ memory: Memory) {
        objectWillChange.send()
        
        notificationHelper.removeNotification(for: memory) //redundant because all notifications get recreated on save
        memory.isMarkedForDeletion = true
        save()
    }
    
    func restore(_ memory: Memory) {
        objectWillChange.send()
        
        memory.isMarkedForDeletion = false
        save()
    }
    
    func deleteMarkedMemories() {
        for memoryToDelete in memories {
            remove(memoryToDelete)
        }
    }
    
    func remove(_ memory: Memory) {
        notificationHelper.removeNotification(for: memory) //redundant because all notifications get recreated on save

        memory.image = nil //triggers deletion of the image

        memories.remove(at: memories.firstIndex(of: memory)!)
        save()
    }
    
    
    func toggleNotifications(for memory: Memory) {
        objectWillChange.send()
        memory.notificationsEnabled.toggle()
        save()
    }
    
    func newestYear() -> Int? {
        return memories.map({memory in memory.date.year()}).max();
    }
    
    func oldestYear() -> Int? {
        return memories.map({memory in memory.date.year()}).min();
    }
    
    func memoriesForYear(_ year: Int) -> [Memory] {
        return memories.filter { memory in
            return memory.date.year() == year;
        }
    }

    
    private func save() {
        do {
            let data = try JSONEncoder().encode(memories)
            try data.write(to: getSavePath(), options:[.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
        
        notificationHelper.updateNotifications(memories: self)
    }
    
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
}
