//
//  ListView.swift
//  ARescue
//
//  Created by Pasquale Viscido on 13/12/22.
//

import SwiftUI

struct ListView: View {
    
    @StateObject var elements = ModelElements()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.red.edgesIgnoringSafeArea(.all)
                VStack {
                    List {
                        Section {
                            ForEach(elements.listOfElements) { element in
                                HStack {
                                    NavigationLink {
                                        NearbyView()
                                    } label: {
                                        Image(element.imageName)
                                            .resizable()
                                            .frame(width: 80, height: 80)
                                            .aspectRatio(contentMode: .fit)
                                        
                                        Text(element.name)
                                            .fontWeight(.medium)
                                    }
                                }
                            }
                        } header: {
                            Text("Near You")
                        }
                    } // MARK: End List
                    .listStyle(.insetGrouped)
                    
                    .navigationTitle("Safety Equipment")
                    
                    
                    VStack {
                        Button {
                            print("SOS Button Tapped")
                        } label: {
                            Text("SOS Call").font(.title).fontWeight(.bold).foregroundColor(.white)
                        }
                    }
                    .padding(5)

                    
                } // MARK: End VStack
            } // MARK: End NavigationView
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
