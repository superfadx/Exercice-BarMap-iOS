//
//  PenseBete.swift
//  Exercice Map
//
//  Created by Fady on 14/11/2018.
//  Copyright © 2018 SuperFadx. All rights reserved.
//

import Foundation


struct PenseBete : Decodable  {
    
    var code : Int
    var bars : [Bar]
    var neighborhoods : [Neighborhood]
    var city : City
    
    struct Bar : Decodable {
        var id : Int?
        var address : String?
        var name : String?
        var url : String?
        var imageUrl : String?
        var tags : Any
        var latitude : Double?
        var longitude : Double?
        
        
        private enum CodingKeys: String, CodingKey {
            case id
            case address
            case name
            case url
            case imageUrl  = "image_url"
            case tags
            case latitude
            case longitude
        }
        
        init(from decoder: Decoder) throws {
            do {
                
                
                let container = try decoder.container(keyedBy: CodingKeys.self)
                id = try? container.decode(Int.self, forKey: .id)
                address = try? container.decode(String.self, forKey: .address)
                name = try? container.decode(String.self, forKey: .name)
                url = try? container.decode(String.self, forKey: .url)
                imageUrl = try? container.decode(String.self, forKey: .imageUrl)
                
                //Nettoyage des données (du "false" dans le champ tags de l'objet bar)
                if let stringProperty = try? container.decode(String.self, forKey: .tags) {
                    tags = stringProperty
                } else if (try? container.decode(Bool.self, forKey: .tags)) != nil {
                    tags = ""
                } else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: container.codingPath, debugDescription: "Uknown type"))
                }
                
                latitude = try? container.decode(Double.self, forKey: .latitude)
                longitude = try? container.decode(Double.self, forKey: .longitude)
            }
            
        }
    }
    
    struct Neighborhood : Decodable {
        
        var id : Int
        var name : String
        var slug : String
        
    }
    
    struct City : Decodable  {
        
        var name : String
        var nameonly : String
        var id : Int
    }
    
}
