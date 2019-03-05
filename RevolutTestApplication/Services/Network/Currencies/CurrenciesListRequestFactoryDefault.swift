import Foundation
import Alamofire

class CurrenciesListRequestFactoryDefault: BasicFactory {
}

extension CurrenciesListRequestFactoryDefault: CurrenciesListRequestFactory {
    
    func getList(baseCurrency: String, completionHandler: @escaping (DataResponse<CurrenciesList>) -> Void) {
        let requestModel = CurrenciesListRequest(baseUrl: configuration.baseUrl, baseCurrency: baseCurrency)
        self.request(reques: requestModel, completionHandler: completionHandler)
    }
}
extension CurrenciesListRequestFactoryDefault {
    struct CurrenciesListRequest: RequestRouter {
        let baseUrl: URL
        let method: HTTPMethod = .get
        let path: String = Api.latestCurrencies
        let baseCurrency: String
        var parameters: Parameters? {
            return [
                "base": baseCurrency
            ]
        }
    }
}
