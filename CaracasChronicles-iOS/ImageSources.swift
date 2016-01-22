//
//  ImageSources.swift
//  CaracasChronicles-iOS
//
//  Created by Alejandro on 1/22/16.
//
//

import Alamofire
import SwiftyJSON

let NYTimesArticleSearchURL = "svc/search/v2/articlesearch.json"

func fetchFirstNYTimesSquareImage(article: Article, indexPath: NSIndexPath, completion: (NSIndexPath) -> Void) {
    let query = article.headline
    Alamofire.request(.GET, API.NYTimes.baseURL + NYTimesArticleSearchURL,
        parameters: ["fq": "venezuela " + query,
                     "api-key": API.NYTimes.key,
                     "fl": "multimedia"])
        .responseJSON { response in
            if let result = response.result.value {
                let docs = JSON(result)["response"]["docs"]
                for (_, doc) in docs {
                    for (_, media) in doc["multimedia"] {
                        if media["width"] == media["height"] {
                            article.thumbnailURL = NSURL(string: API.NYTimesImages.baseURL + media["url"].stringValue)!
                            completion(indexPath)
                            return
                        }
                    }
                }
            }
    }
}