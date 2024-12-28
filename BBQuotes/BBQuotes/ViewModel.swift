//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Muharrem Efe Çayırbahçe on 27.12.2024.
//

import Foundation

@MainActor
@Observable
class ViewModel {
    enum FetchStatus {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        case failure(error: Error)
    }
    
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    var character: Character
    var episode: Episode
    
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        self.quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        self.character = try! decoder.decode(Character.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        self.episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    func getQuoteData(for show: String) async {
        status = .fetching
        
        do {
            quote = try await fetcher.fetchQuote(from: show)
            
            character = try await fetcher.fetchCharacter(quote.character)
            
            character.death = try await fetcher.fetchDeath(character.name)
            
            status = .successQuote
        } catch {
            status = .failure(error: error)
        }
    }
    
    func getEpisodeData(for show: String) async {
        status = .fetching
        
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappedEpisode
                status = .successEpisode
            }
        } catch {
            status = .failure(error: error)
        }
    }
}
