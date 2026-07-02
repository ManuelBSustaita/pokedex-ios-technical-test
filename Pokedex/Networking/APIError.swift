//  Created by Manuel Sustaita on 02/07/26.

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed
    case unknown
}
