import Alamofire

// Класс базовой фабрики, прочие классы сущностей наследуются от него

class BasicFactory: AbstractRequestFactory {
    
    let errorParser: AbstractErrorParser
    let sessionManager: SessionManager
    let queue: DispatchQueue?
    let configuration: Configuration
    
    init(
        errorParser: AbstractErrorParser,
        sessionManager: SessionManager,
        queue: DispatchQueue? = DispatchQueue.global(qos: .utility)) {
        
        self.errorParser = errorParser
        self.sessionManager = sessionManager
        self.queue = queue
        self.configuration = Configuration()
    }
}
