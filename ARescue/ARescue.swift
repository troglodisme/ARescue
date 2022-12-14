//
//  CercaApp.swift
//  Cerca
//
//  Created by Adolfo Vera Blasco on 24/06/2020.
//

import SwiftUI

@main
struct ARescue: App {
    var body: some Scene {
        
        WindowGroup {
            
            if ViewController.nearbySessionAvailable {
                ContentView()
//                NavigationView()
            }
            else {
                ErrorView()
            }
        }
    }
}
