//
//  Constants.swift
//  Exercice Map
//
//  Created by Fady on 14/11/2018.
//  Copyright © 2018 SuperFadx. All rights reserved.
//

import Foundation



struct Constants {
    
    
    
    func getBarsFromJson() -> [PenseBete.Bar]!  {
        var resultat = [PenseBete.Bar]()
        if let path = Bundle.main.path(forResource: "Pense bete", ofType: "json", inDirectory : "Assets") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                do {
                    let decoder = JSONDecoder()
                    let penseBeteData = try decoder.decode(PenseBete.self, from: data)
                    resultat = penseBeteData.bars
                    
                } catch let err {
                    print("Err", err)
                }
                
                return resultat
                
            } catch let error {
                print("JSON Parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename or path.")
        }
        return nil
    }
    
    
    
}
