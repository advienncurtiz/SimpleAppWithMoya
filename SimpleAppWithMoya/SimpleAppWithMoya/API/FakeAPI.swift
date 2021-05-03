//
//  APIClient.swift
//  SimpleAppWithMoya
//
//  Created by Viennarz Curtiz on 5/3/21.
//

import Foundation
import Moya

enum FakeAPI {
    case getList
}

extension FakeAPI: TargetType {
    var baseURL: URL {
        let baseUrl = "http://localhost:3000"
        return URL.init(string: baseUrl)!
    }
    
    var path: String {
        switch self {
            case .getList:
                return "game_list"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .getList:
                return .get
        }
    }
    
    var sampleData: Data {
        return Data("default data".utf8)
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        nil
    }
    
    
}

struct FakeWorker: FakeWorkerType {
    private let provider: MoyaProvider<FakeAPI>
    
    init() {
        self.provider = MoyaProvider<FakeAPI>()
    }
    
    
    func fetchGames(completion: @escaping (Result<[GameItem], Error>) -> Void) {
        self.provider.request(.getList) { result in
            switch result {
            
            case .success(let response):
                do {
                    let response = try JSONDecoder().decode([GameItem].self, from: response.data)
                    completion(.success(response))
                } catch let decodeError {
                    debugPrint(decodeError)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}

protocol FakeWorkerType: FakeStore { }

protocol FakeStore {
    func fetchGames(completion: @escaping (Result<[GameItem], Error>) -> Void)
}

struct GameItem: Decodable {
    let id: UUID
    let title: String
    let description: String
    
    // MARK: - Keys
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
    }
    
}
