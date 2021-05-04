//
//  DataError.swift
//  SimpleAppWithMoya
//
//  Created by Viennarz Curtiz on 5/4/21.
//

import Foundation

public struct DataError: Error, Decodable {
    private var extra: Extra!
    
    public var title: String
    public var message: String
    public var errorCode: Int

    // MARK: - Keys
    private enum DataErrorKeys: String, CodingKey {
        case errorCode
        case message
        case extra
    }
    
    // This is use for API Server Response Error
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DataErrorKeys.self)
        
        self.title = "Error"
        self.errorCode = try container.decode(Int.self, forKey: .errorCode)
        
        do {
            self.extra = try container.decode(Extra.self, forKey: .extra)
            self.message = self.extra.userErrorMessage
        } catch let decodeError {
            let apiError = ApiErrorCode.init(rawValue: self.errorCode)
            
            if apiError != nil {
                // This will never fail
                self.message = try! container.decode(String.self, forKey: .message)
            } else {
                throw decodeError
            }
        }
        
    }
    
    // This is use for Client Side Response Error
    public init(title: String, message: String, errorCode: Int? = -1) {
        self.title = title
        self.message = message
        self.errorCode = errorCode!
    }
}

public enum ApiErrorCode: Int {
    case serverError = 50001
    
    case invalidApiKey = 40001
    case invalidRequest = 40002
    case invalidParameter = 40003
    
    case unauthenticatedAccess = 40101
    case invalidAccessToken = 40102
    case invalidRefreshToken = 40103
    
    case unauthorizedAccess = 40301
    
    case resourceNotFound = 40401
    
    public var code: Int {
        return self.rawValue
    }
}


public struct Extra: Decodable {
    public var userErrorMessage: String = "Unable to parse"
    public var otherMessage: String = "Encountered Error"
    
    // MARK: - Keys
    private enum ExtraKeys: String, CodingKey {
        case userErrorMessage = "user_error_message"
        case emailAddress = "email_address"
        case password
        case newPassword = "new_password"
        case oldPassword = "old_password"
        case enforced
        case firstname = "first_name"
        case lastname = "last_name"
        case subject
        case message
        case promoter
        case refreshToken = "refresh_token"
        case grant
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ExtraKeys.self)
        
        let keys = container.allKeys
        
        for index in 0..<keys.count {
            if let errorMessage = try? container.decode(String.self, forKey: keys[index]) {
                self.otherMessage = errorMessage
                break
            }
        }
        
        self.userErrorMessage = try container.decode(String.self, forKey: .userErrorMessage)
        
    }
}
