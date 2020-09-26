//
//  Router.swift
//  FetchRewards
//
//  Created by Eric Figura on 9/26/20.
//  Copyright © 2020 FetchRewards. All rights reserved.
//

import Foundation

// Created a router for scabability. Granted it's not needed for a project like this but it's a talking point. 
enum Router {
    case GetItems
    
    var baseUrl: String {
        return "fetch-hiring.s3.amazonaws.com"
    }
    
    var scheme: String {
        return "https"
    }
    
    var path: String {
        switch self {
        case .GetItems:
            return "/hiring.json"
        }
    }
}
