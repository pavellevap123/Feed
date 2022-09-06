//
//  Tile.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

class Tiles: Codable {
    var tiles: [Tile]
}

class Tile: Codable {
    let name, headline: String
    let subline: String?
    let data: String?
    let score: Int
}
