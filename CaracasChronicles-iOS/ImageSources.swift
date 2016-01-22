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

func fetchFirstNYTimesSquareImage(query: String) {
    Alamofire.request(.GET, API.NYtimes.baseURL + NYTimesArticleSearchURL,
        parameters: ["fq": "venezuela " + query,
                     "api-key": API.NYtimes.key,
                     "fl": "multimedia"])
        .responseJSON { response in
            if let result = response.result.value {
                let docs = JSON(result)["response"]["docs"]
                for (_, doc) in docs {
                    for (_, media) in doc["multimedia"] {
                        if media["width"] == media["height"] {
                            print(media["url"].stringValue)
                            return
                        }
                    }
                }
            }
    }
}