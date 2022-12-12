//
//  ErrorView.swift
//  Cerca
//
//  Created by Adolfo Vera Blasco on 24/06/2020.
//

import SwiftUI

internal struct ErrorView: View
{
    internal var body: some View
    {
        VStack(alignment: .center, spacing: 8)
        {
            Spacer()
            
            Image("MeMac")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .shadow(radius: 8)
            
            Text("Cannot run on this device")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(24)
            
            Text("Need a U1 chip")
                .font(.system(size: 20))
                .padding(24)
            
            Spacer()
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
