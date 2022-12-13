//
//  NearbyView.swift
//  Cerca
//
//  Created by Adolfo Vera Blasco on 24/06/2020.
//

import SwiftUI

struct NearbyView: View {

    @StateObject private var viewModel = ViewController()
    
    @State private var distance = "···"

    
    @State private var backgroundGradient = [ Color.yellow, Color.green ]

    private let farColors = [ Color.red, Color.red ]
    private let mediumColors = [ Color.orange, Color.orange ]
    private let closeColors = [ Color.green, Color.green ]
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 8) {
            
            Spacer()
            
            //Display distance
            Text(self.distance)
                .font(.system(size: 80, weight: .medium, design: .rounded))
                .onReceive(self.viewModel.$distanceToPeer, perform: { updatedDistance in
                    
                    guard let updatedDistance = updatedDistance else {
                        self.distance = "···"
                        return
                    }
                    
                    self.distance = String(format: "%.2f m", updatedDistance)
                })
            
            Spacer()
            
            //Display direction arrow and colour
            ArrowView(viewModel: viewModel)        
            
            Spacer()
            
            //Displays if direction information is available
//            Image(systemName: self.viewModel.isDirectionAvailable ? "location.fill" : "location.slash.fill")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.white)
//                .frame(width: 25, height: 25)
//                .offset(x: 55, y: -45)
//                .opacity(0.50)
//                .animation(.linear)
            
            Text(self.viewModel.peerName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(self.viewModel.isConnectionLost ? .secondary : .primary)
            
            //trying to print the iphone token on top of the display name
//            Text(self.viewModel.peerDescription)
//                .font(.system(size: 20, weight: .semibold))
//                .foregroundColor(self.viewModel.isConnectionLost ? .secondary : .primary)
//            
            

            
//            Text("Looking for...")
//                .font(.system(size: 14))
//                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct NearbyView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyView()
            .preferredColorScheme(.dark)
    }
}
