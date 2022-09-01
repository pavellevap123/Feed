//
//  Tile.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

// MARK: - Welcome
struct Tiles: Codable {
    let tiles: [Tile]
}

// MARK: - Tile
struct Tile: Codable {
    let name, headline: String
    let subline: String?
    let data: String?
    let score: Int
}
