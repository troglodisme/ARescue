

//
//  ArrowView.swift
//  ARescue
//
//  Created by Giulio on 13/12/22.
//

import SwiftUI

struct ArrowView: View {

    @ObservedObject var viewModel: ViewController
    
    @State private var backgroundGradient = [ Color.yellow, Color.green ]

    private let farColors = [ Color.red, Color.red ]
    private let mediumColors = [ Color.orange, Color.orange ]
    private let closeColors = [ Color.green, Color.green ]

    var body: some View {

        HStack(alignment: .center, spacing: 8) {
            
            Spacer()

            ZStack(alignment: .center) {

                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: self.backgroundGradient),
                                         startPoint: .bottomTrailing, endPoint: .topLeading))
                    .frame(width: 200, height: 200)
                    .animation(.linear(duration: 0.50))
                    .onReceive(self.viewModel.$distanceToPeer, perform: { updatedDistance in

                        guard let updatedDistance = updatedDistance else {
                            self.backgroundGradient = farColors
                            return
                        }

                        switch updatedDistance {
                            case 1.0 ... Float.infinity :
                                self.backgroundGradient = farColors
                            case 0.5 ... 0.99:
                                self.backgroundGradient = mediumColors
                            default:
                                self.backgroundGradient = closeColors
                        }
                    })

                Image(systemName: "arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                    .shadow(radius: 8)
//                    .rotationEffect(.degrees(self.viewModel.directionAngle))
                    .rotationEffect(.degrees(rad2deg(viewModel.directionAngle)))
                    .opacity(self.viewModel.isDirectionAvailable ? 1.0 : 0.10)
                    .animation(.linear)

            }

            Spacer()
            
//            Text(" \(rad2deg(viewModel.directionAngle))" )
//                .foregroundColor(.red)
        }


    }
    
    func rad2deg(_ number: Double) -> Double {
        return number * 180 / .pi
    }
}


//struct ArrowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ArrowView()
//    }
//}
