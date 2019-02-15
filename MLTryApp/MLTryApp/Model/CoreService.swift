//
//  CoreService.swift
//  MLTryApp
//
//  Created by Ali Dhanani on 14/02/2019.
//  Copyright © 2019 Ali Dhanani. All rights reserved.
//

import Foundation
import CoreData

class CoreService {
    static let shared = CoreService()
    init() {
    }
    
    let persistanceManager = CoreDataWork.shared
    var notes = [Entity]()
    
    // Create User
    func CreateUser(Value value: String, Description desc: String, completion: @escaping ()->()) {
        let entity = Entity(context: persistanceManager.context)
        // Save Value
        entity.value = value
        entity.desc = desc
        persistanceManager.save()
        completion()
    }
    
    func GetParticularMessage(Position num: Int, completion: @escaping (String, String)->()) {
        completion(notes[num].value!, notes[num].desc!)
    }
    
    func printNotes(compeltion: @escaping ([String], [String]) -> ()) {
        let notes = persistanceManager.fetch(Entity.self)
        self.notes = notes
        var value: [String] = []
        var desc: [String] = []
        notes.forEach { (note) in
            // print value
            value.append(note.value!)
            desc.append(note.desc!)
            compeltion(value, desc)
        }
    }
    
    //    func getUser() {
    //        let notes = persistanceManager.fetch(Notes.self)
    //        self.notes = notes
    //        printNotes()
    //    }
    
    func updateNotes(Position num: Int, Message msg: String, completion: @escaping ()->()) {
        let firstNote = notes[num]
        // Value to update
        persistanceManager.save()
        completion()
    }
    
    func DeleteUser(Position num: Int, completion: @escaping ()->()) {
        let firstNote = notes[num]
        persistanceManager.context.delete(firstNote)
        persistanceManager.save()
        completion()
    }
}
