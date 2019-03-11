import OHHTTPStubs
import XCTest

@testable import RevolutTestApplication

class CurrenciesListRequestFactoryTest: XCTestCase {
    
    var factory: CurrenciesListRequestFactory!
    override func setUp() {
        super.setUp()
        let factoryMock = RequestFactoryMock()
        factory = factoryMock.makeCurrenciesListRequestFactory()        
    }
    
    override func tearDown() {
        factory = nil
        super.tearDown()
    }
    
    func testGetList() {
        let exp = expectation(description: "")
        var result: CurrenciesList?
        OHHTTPStubsResponse.defaultStubFor(pathEnd: ApiMock.latestCurrencies)
        factory.getList(baseCurrency: ApiMock.defaultBaseCurrency) { (response) in
            exp.fulfill()
            result = response.value
        }
        wait(for: [exp], timeout: 1.0)
        XCTAssertNotNil(result)
    }
    
}
