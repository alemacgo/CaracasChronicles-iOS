//
//  Article.swift
//  CaracasChronicles-iOS
//
//  Created by Alejandro on 1/22/16.
//
//

class Article {
    var headline: String
    var thumbnail: UIImage? = nil
    var URL: NSURL
    
    init(headline: String, URL: NSURL) {
        self.headline = headline
        self.URL = URL
    }
}