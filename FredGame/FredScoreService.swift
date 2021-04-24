//
//  FredScoreService.swift
//  FredGame
//
//  Created by user188455 on 4/18/21.
//

import Foundation

class FredScoreService {
        public typealias UpdateListClosure = ([Score]) -> Void
    
        func makeGetCall(_ scoreList: [Score], _ handler: @escaping UpdateListClosure) {
            let top10Endpoint: String = "https://fredscores.herokuapp.com/scores/top10"
            guard let url = URL(string: top10Endpoint) else {
                print("Error: cannot create URL")
                return
            }
        
            let urlRequest = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
                
            let task = session.dataTask(with: urlRequest) {
                (data, response, error) in
                guard error == nil else {
                    print("error calling GET on /scores/top10")
                    print(error!)
                    return
                }
                
                guard let responseData = data else {
                    print("Error: did not receive data")
                    return
                }
                
                do {
                    guard let top10Response = try JSONSerialization.jsonObject(with: responseData, options: [])
                        as? [[String: Any]] else {
                            print("error trying to convert data to JSON")
                            return
                    }
                    
                    var top10List : [Score] = []
                    for (index, element) in top10Response.enumerated() {
                        print(index, ":", element)
                        let score = Score(name: "GROGU", date: Date(), points: 200)

                        top10List.append(score)
                    }
                    
                    handler(top10List)
                } catch  {
                    print("error trying to convert data to JSON")
                    return
                }
            }
            task.resume()
      }

    func makePostCall(newScore: Score) {
        let newScoreEndpoint: String = "https://fredscores.herokuapp.com/scores"
        guard let url = URL(string: newScoreEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let dateF = DateFormatter()
        dateF.dateFormat = "YYYY-MM-dd"
        //dateF.string(from: newScore.date)
        let rawData:[String: Any] = ["name":newScore.name, "points":String(newScore.points),"date":dateF.string(from: newScore.date)]
        let data = try? JSONSerialization.data(withJSONObject: rawData)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = data
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
            
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /scores")
                print(error!)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
            }
        }
        task.resume()
  }
}
