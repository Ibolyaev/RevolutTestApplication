import Alamofire
@testable import RevolutTestApplication
import OHHTTPStubs

class RequestFactoryMock {
    
    func makeErrorParser() -> AbstractErrorParser {
        return ErrorParserStub()
    }
    
    lazy var commonSessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.ephemeral
        OHHTTPStubs.isEnabled(for: configuration)
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
    let sessionQueue = DispatchQueue.global(qos: .utility)
    
    func makeCurrenciesListRequestFactory() -> CurrenciesListRequestFactory {
        let errorParser = makeErrorParser()
        return CurrenciesListRequestFactoryDefault(
            errorParser: errorParser,
            sessionManager: commonSessionManager,
            queue: sessionQueue
        )
    }
}
