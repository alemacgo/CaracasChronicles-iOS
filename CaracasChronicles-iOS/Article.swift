//
//  Article.swift
//  CaracasChronicles-iOS
//
//  Created by Alejandro on 1/22/16.
//
//

import UIKit

class Article {
    var headline: String
    var thumbnailURL: NSURL? = nil
    var URL: NSURL
    
    init(headline: String, URL: NSURL) {
        self.headline = headline
        self.URL = URL
    }
}