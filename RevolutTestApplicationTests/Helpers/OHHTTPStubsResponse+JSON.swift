//
//  OHHTTPStubsResponse+JSON.swift
//  IbolyaevTests
//
//  Created by Ronin on 15/07/2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import OHHTTPStubs

extension OHHTTPStubsResponse {
    
    static func defaultStubFor(pathEnd: String) {
        let resourceArr = pathEnd.split(separator: ".")
        let fileName = String(resourceArr[0])
        let fileExtension = String(resourceArr[1])
        
        stub(condition: isMethodGET() && pathEndsWith(pathEnd)) { _ in
            let fileUrl = Bundle.main.url(
                forResource: fileName,
                withExtension: fileExtension
                )! // swiftlint:disable:this force_unwrapping
            return OHHTTPStubsResponse(
                fileURL: fileUrl,
                statusCode: 200,
                headers: nil
            )
        }

    }
    
}
