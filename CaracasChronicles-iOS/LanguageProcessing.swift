//
//  LanguageProcessing.swift
//  CaracasChronicles-iOS
//
//  Created by Alejandro on 1/23/16.
//
//

import UIKit

let options = NSLinguisticTaggerOptions.OmitWhitespace.rawValue | NSLinguisticTaggerOptions.JoinNames.rawValue
let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("en"), options: Int(options))

func getFirstNoun(string: String) -> String {
    tagger.string = string
    
    let range = NSMakeRange(0, string.characters.count)
    var nouns = [String]()
    tagger.enumerateTagsInRange(range, scheme: NSLinguisticTagSchemeNameTypeOrLexicalClass, options: NSLinguisticTaggerOptions(rawValue: options)) { tag, tokenRange, sentenceRange, stop in
        let token = (string as NSString).substringWithRange(tokenRange)
        if tag == "Noun" || tag == "PersonalName" || tag == "PlaceName" {
            nouns.append(token)
        }
    }
    if nouns.isEmpty {
        return string
    }
    return nouns.joinWithSeparator(" ")
}