//
//  FetchView.swift
//  BBQuotes
//
//  Created by Muharrem Efe Çayırbahçe on 27.12.2024.
//

import SwiftUI

struct FetchView: View {
    let viewModel = ViewModel()
    let show: String
    
    @State var showCharacterInfo = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(show.removeCaseAndSpaces())
                    .resizable()
                    .frame(width: geometry.size.width * 2.7, height: geometry.size.height * 1.2)
                
                VStack {
                    VStack {
                        Spacer(minLength: 60)
                        
                        switch viewModel.status {
                        case .notStarted:
                            EmptyView()
                        case .fetching:
                            ProgressView()
                        case .successQuote:
                            Text("\"\(viewModel.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                            
                            ZStack(alignment: .bottom) {
                                AsyncImage(url: viewModel.character.images[0]) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 1.8)
                                
                                Text(viewModel.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geometry.size.width / 1.1, height: geometry.size.height / 1.8)
                            .clipShape(.rect(cornerRadius: 50))
                            .onTapGesture {
                                showCharacterInfo.toggle()
                            }
                            
                        case .successEpisode:
                            EpisodeView(episode: viewModel.episode)
                            
                        case .failure(let error):
                            Text("Error: \(error.localizedDescription)")
                                .foregroundStyle(.red)
                                .padding()
                                .background(.black.opacity(0.5))
                                .clipShape(.rect(cornerRadius: 25))
                                .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    
                    HStack {
                        Button {
                            Task {
                                await viewModel.getQuoteData(for: show)
                            }
                        } label: {
                            Text("Get Random Quote")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 25))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                        
                        Spacer()
                        
                        Button {
                            Task {
                                await viewModel.getEpisodeData(for: show)
                            }
                        } label: {
                            Text("Get Random Episode")
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color("\(show.removeSpaces())Button"))
                                .clipShape(.rect(cornerRadius: 25))
                                .shadow(color: Color("\(show.removeSpaces())Shadow"), radius: 2)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer(minLength: 95)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .sheet(isPresented: $showCharacterInfo) {
            CharacterView(character: viewModel.character, show: show)
        }
    }
}

#Preview {
    FetchView(show: Constants.bbName)
        .preferredColorScheme(.dark)
}
