import Foundation

class ErrorParser: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return result
    }
    
    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        guard let response = response else {
           return error
        }
        let errorSource = HTTPStatusCodeGroup(code: response.statusCode)
        switch errorSource {
        case .Client:
            return serializeError(data: data)
        default:
            return nil
        }
    }
    func serializeError(data: Data?) -> ApiError {
        guard let data = data else {
            return ApiUnkownError()
        }
        do {
            let value = try JSONDecoder().decode(ErrorApi.self, from: data)
            return ApiClientError(errorDescription: value.error)
        } catch {
            return ApiUnkownError()
        }
    }
}
protocol ApiError: LocalizedError {
}

struct ErrorApi: Decodable {
    let error: String
}

struct ApiClientError: ApiError {
    var errorDescription: String
}
struct ApiUnkownError: ApiError {
    var errorDescription = "Unkown server error"
}

enum HTTPStatusCodeGroup: Int {
    case Info = 100
    case Success = 200
    case Redirect = 300
    case Client = 400
    case Server = 500
    case Unknown = 999
    
    init(code: Int) {
        switch code {
        case 100...199: self = .Info
        case 200...299: self = .Success
        case 300...399: self = .Redirect
        case 400...499: self = .Client
        case 500...599: self = .Server
        default: self = .Unknown
        }
    }
}


