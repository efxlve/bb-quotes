//
//  CharacterView.swift
//  BBQuotes
//
//  Created by Muharrem Efe Çayırbahçe on 27.12.2024.
//

import SwiftUI

struct CharacterView: View {
    let character: Character
    let show: String
    
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { proxy in
                ZStack(alignment: .top) {
                    Image(show.removeCaseAndSpaces())
                    .resizable()
                    .scaledToFill()
                    .opacity(0.3)
                    .frame(width: geometry.size.width, height: geometry.size.height * 1.1)
                    .ignoresSafeArea()
                    
                    ScrollView {
                        VStack {
                            TabView {
                                ForEach(character.images, id: \.self) { characterImageURL in
                                    
                                    AsyncImage(url: characterImageURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                            }
                            .tabViewStyle(.page)
                            .frame(width: geometry.size.width / 1.2, height: geometry.size.height / 1.7)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .padding(.top, 60)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text(character.name)
                                    .font(.largeTitle)
                                
                                Text("Portrayed by: \(character.portrayedBy)")
                                    .font(.subheadline)
                                
                                Divider()
                                
                                Text("\(character.name) Character Info")
                                    .font(.title2)
                                
                                Text("Birthday: \(character.birthday)")
                                
                                Divider()
                                
                                Text("Occupations:")
                                
                                ForEach(character.occupations, id: \.self) { occupation in
                                    Text("• \(occupation)")
                                        .font(.subheadline)
                                }
                                
                                Divider()
                                
                                Text("Aliases:")
                                
                                if character.aliases.count > 0 {
                                    ForEach(character.aliases, id: \.self) { alias in
                                        Text("• \(alias)")
                                            .font(.subheadline)
                                    }
                                } else {
                                    Text("None")
                                        .font(.subheadline)
                                }
                                
                                Divider()
                                
                                DisclosureGroup("Status (spoiler alert!)") {
                                    VStack(alignment: .leading) {
                                        Text(character.status)
                                            .font(.title2)
                                        
                                        if let death = character.death {
                                            AsyncImage(url: death.image) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                                    .onAppear() {
                                                        withAnimation {
                                                            proxy.scrollTo(1, anchor: .bottom)
                                                        }
                                                    }
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            
                                            Text("How: \(death.details)")
                                                .padding(.bottom, 7)
                                            
                                            Text("Last Words: \"\(death.lastWords)\"")
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .tint(.primary)
                            }
                            .frame(maxWidth: geometry.size.width / 1.25, alignment: .leading)
                            .padding(.bottom, 50)
                            .id(1)
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

#Preview {
    CharacterView(character: ViewModel().character, show: Constants.bbName)
}
