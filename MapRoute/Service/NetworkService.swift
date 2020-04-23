//
//  NetworkService.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    func getRoute(urlString: String, completion: @escaping([String: Any]?,Error?) -> ())
}

class NetworkService: NetworkServiceProtocol {
    
    // MARK: - ServerServiceProtocol methods
    
    func getRoute(urlString: String, completion: @escaping ([String : Any]?, Error?) -> ()) {
        if let URL = URL(string: urlString) {
            getJSON(URL: URL, completion: completion)
        }
    }
    
    // MARK: - Private methods
    
    private func getJSON(URL: URL, completion: @escaping ([String: Any]?, Error?) -> Swift.Void) {
          let sharedSession = URLSession.shared
          
          let dataTask = sharedSession.dataTask(with: URL, completionHandler: { (data, response, error) -> Void in
              
              if error != nil {
                  print("Error to load: \(String(describing: error?.localizedDescription))")
                  completion(nil, error)
                  return
              }
              
              if let dataResponse = data {
                  do {
                      let json = try JSONSerialization.jsonObject(with: dataResponse, options: []) as! [String: AnyObject]
                      
                      //print("json: \(json), error: \(String(describing: error))")
                      completion(json, nil)
                      return
                      
                  } catch let error as NSError {
                      
                      print("Failed to load: \(error.localizedDescription)")
                      completion(nil, error)
                  }
              }
          })
          dataTask.resume()
      }
}




