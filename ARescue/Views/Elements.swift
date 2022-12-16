//
//  Elements.swift
//  ARescue
//
//  Created by Federico Lupotti on 15/12/22.
//

import Foundation

struct Element: Identifiable {
    let id = UUID()
    var name: String
    var imageName: String
}

class ModelElements: ObservableObject {
    
    let listOfElements: [Element] = [
        Element(name: "Defibrillator", imageName: "Defibrillator"),
        Element(name: "First Aid Kit", imageName: "First Aid Kit"),
        Element(name: "Hydrant", imageName: "Hydrant"),
        Element(name: "Fire Extinguisher", imageName: "Fire Extinguisher"),
    ]
}
