//
//  EpisodeView.swift
//  BBQuotes
//
//  Created by Muharrem Efe Çayırbahçe on 28.12.2024.
//

import SwiftUI

struct EpisodeView: View {
    let episode: Episode
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(episode.title)
                .font(.largeTitle)
            
            Text(episode.seasonEpisode)
                .font(.title2)
            
            AsyncImage(url: episode.image) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } placeholder: {
                ProgressView()
            }
            
            Text(episode.synopsis)
                .font(.title3)
                .minimumScaleFactor(0.5)
                .padding(.bottom)
            
            Text("Written by: \(episode.writtenBy)")
                    
            Text("Directed by: \(episode.directedBy)")
            
            Text("Air Date: \(episode.airDate)")
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding()
    }
}

#Preview {
    EpisodeView(episode: ViewModel().episode)
}
