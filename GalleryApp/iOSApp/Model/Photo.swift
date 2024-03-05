//
//  Photo.swift
//  GalleryApp
//
//  Created by baps on 06/03/24.
//

import Foundation

struct Photo: Codable {
    let urls: URLs
}

struct URLs: Codable {
    let regular: String
}
