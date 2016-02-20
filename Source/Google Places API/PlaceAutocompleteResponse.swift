//
//  PlaceAutocompleteResponse.swift
//  GooglePlaces
//
//  Created by Honghao Zhang on 2016-02-13.
//  Copyright © 2016 Honghao Zhang. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: - PlaceAutocompleteResponse
extension GooglePlaces {
    public struct PlaceAutocompleteResponse: Mappable {
        public var status: StatusCode?
        public var predictions: [Prediction] = []
        public var errorMessage: String?
        
        public init() {}
        public init?(_ map: Map) { }
        
        public mutating func mapping(map: Map) {
            status <- (map["status"], EnumTransform())
            predictions <- map["predictions"]
            errorMessage <- map["error_message"]
        }
        
        /**
         *  Prediction
         */
        public struct Prediction: Mappable {
            public var description: String?
            public var place: Place?
            public var terms: [Term] = []
            public var types: [String] = []
            public var matchedSubstring: [MatchedSubstring] = []
            
            public init() {}
            public init?(_ map: Map) { }
            
            public mutating func mapping(map: Map) {
                description <- map["description"]
                place <- (map["place_id"], TransformOf(fromJSON: { (json) -> Place? in
                    if let placeId = json {
                        return Place.PlaceID(id: placeId)
                    } else {
                        return nil
                    }
                    }, toJSON: { (place) -> String? in
                        switch place {
                        case .None:
                            return nil
                        case .Some(let place):
                            switch place {
                            case .PlaceID(id: let id):
                                return id
                            default:
                                return nil
                            }
                        }
                }))
                
                terms <- map["terms"]
                types <- map["types"]
                matchedSubstring <- map["matched_substrings"]
            }
        }
        
        /**
         *  Term
         */
        public struct Term: Mappable {
            public var offset: Int?
            public var value: String?
            
            public init() {}
            public init?(_ map: Map) { }
            
            public mutating func mapping(map: Map) {
                offset <- map["offset"]
                value <- map["value"]
            }
        }
        
        /**
         *  MatchedSubstring
         */
        public struct MatchedSubstring: Mappable {
            public var length: Int?
            public var offset: Int?
            
            public init() {}
            public init?(_ map: Map) { }
            
            public mutating func mapping(map: Map) {
                length <- map["length"]
                offset <- map["offset"]
            }
        }
    }
}
