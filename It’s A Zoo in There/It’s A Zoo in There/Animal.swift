//
//  Animal.swift
//  It’s A Zoo in There
//
//  Created by Gianni Chen on 1/28/17.
//  Copyright © 2017 Gianni Chen. All rights reserved.
//

import UIKit

class Animal {
    
    let name: String
    let species: String
    let age: Int
    let image: UIImage
    let soundPath: String
    
    init(_ name: String, _ species: String, _ age: Int, _ image: UIImage, _ soundPath: String) {
        self.name = name
        self.species = species
        self.age = age
        self.image = image
        self.soundPath = soundPath
    }
    
    func dumpAnimalObject() {
        print("Animal Object: name = \(name), species = \(species), age = \(age), image = \(image)")
    }
    
}
