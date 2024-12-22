//
//  Icon.swift
//  AudiobookshelfAPI
//
//  Created by James Harquail on 2024-11-18.
//

import Foundation

public enum Icon: String {
    
    case database
    
    case audiobookshelf
    
    case books1 = "books-1"
    
    case books2 = "books-2"
    
    case book1 = "book-1"
    
    case microphone1 = "microphone-1"
    
    case microphone3 = "microphone-3"
    
    case radio
    
    case podcast
    
    case rss
    
    case headphones
    
    case music
    
    case filePicture = "file-picture"
    
    case rocket
    
    case power
    
    case star
    
    case heart
    
}

extension Icon: Decodable {}
extension Icon: Sendable {}
