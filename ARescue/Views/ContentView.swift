//
//  ContentView.swift
//  ARescue
//
//  Created by Giulio on 14/12/22.
//

import SwiftUI


// m

struct ContentView: View {
    var body: some View {
        
        NavigationView {
            NavigationLink(destination: NearbyView()) {
                Text("FIRE")
            }
            .navigationTitle("Emergency")
        }

            
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
