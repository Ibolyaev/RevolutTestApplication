import Foundation
import Alamofire

protocol CurrenciesListRequestFactory {
    func getList(baseCurrency: String, completionHandler: @escaping (DataResponse<CurrenciesList>) -> Void)
}
