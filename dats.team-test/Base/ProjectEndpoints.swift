//
//  ProjectEndpoints.swift
//  dats.team-test
//
//  Created by Artamonov Aleksandr on 07.01.2021.
//

import Foundation
import Moya

public enum ProjectEndpoints {
    
    // MARK: - Image
    /// Get image data from url
    /// - url: image url
    case image(url: URL)

}

extension ProjectEndpoints: TargetType {
    public var baseURL: URL {
        switch self {
            case .image(let url):
                return url
        }
    }
    
    public var path: String {
        switch self {
            case .image:
                return ""
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
            case .image:
                return .requestPlain
        }
        
    }
    
    public var headers: [String : String]? {
        return [
            "Accept": "image/webp"
        ]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
