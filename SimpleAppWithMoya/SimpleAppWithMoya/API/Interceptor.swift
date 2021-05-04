//
//  Interceptor.swift
//  SimpleAppWithMoya
//
//  Created by Viennarz Curtiz on 5/4/21.
//

import Alamofire
import Foundation

class APIRequestRetrier: Retrier {
   init() {
       super.init { request, session, error, completion in
           if let response = request.task?.response as? HTTPURLResponse {
            
               // Validate response.statusCode property and do corresponding actions
               completion(.retry) // Retry request after it
           } else {
               completion(.doNotRetry)
           }
       }
   }
}
