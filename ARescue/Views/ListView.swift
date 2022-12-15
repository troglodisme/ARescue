//
//  ListView.swift
//  ARescue
//
//  Created by Pasquale Viscido on 13/12/22.
//

import SwiftUI

struct ListView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.red.edgesIgnoringSafeArea(.all)
                VStack {
                    List {
                        Section {
                            HStack {
                                NavigationLink {
                                    NearbyView()
                                } label: {
                                    Image("Defibrillator")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .aspectRatio(contentMode: .fit)
                                    Text(" ")
                                    Text("DEFIBRILLATOR")
                                        .fontWeight(.medium)
                                }

                            } // End HStack defibrillator
                            
                            HStack {
                                Image("First Aid Kit")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .aspectRatio(contentMode: .fit)
                                Text(" ")
                                Text("FIRST AID KIT")
                                    .fontWeight(.medium)
                            } // End HStack firstaidkit
                            
                            HStack {
                                Image("Fire Extinguisher")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                Text(" ")
                                Text("FIRE EXTINGUISHER")
                                    .fontWeight(.medium)
                            } // End HStack fireextinguisher
                            
                            HStack {
                                Image("Hydrant")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                Text(" ")
                                Text("HYDRANT")
                                    .fontWeight(.medium)
                            }
                        } header: {
                            Text("Near You")
                        }
                    } // MARK: End List
                    .listStyle(.insetGrouped)
                    
                    .navigationTitle("Needed Equipment")
                    
                    VStack {
                        Button {
                            print("SOS Button Tapped")
                        } label: {
                            Text("SOS Call").font(.title).fontWeight(.bold).foregroundColor(.white)
                        } .padding()
                            .background(Color.red)
                    }

                    
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
