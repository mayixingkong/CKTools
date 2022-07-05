//
//  CKHttpClient.swift
//  CKTools

import UIKit
import Alamofire

public class CKHttpClient: NSObject {
    
    public static let shared = CKHttpClient()
    private var requests = [CKRequest]()

    public func add(request:CKRequest) {
        
        requests.append(request)
        if let handler = request.multipartFormDataHandler() {
            
            let uploadRequest = manager().upload(multipartFormData: handler, to: request.requestUrl).redirect(using: request.redirect())
            request.set(dataRequest: uploadRequest)
            handleRequest(request: request, dataRequest: uploadRequest)
        }
        else {
            
            let dataRequest = manager().request(request.requestUrl, method: request.requestMethod(), parameters: request.requestParameters(), encoding: request.requestParametersEncoding(), headers: request.requestHeaders()).redirect(using: request.redirect())
            request.set(dataRequest: dataRequest)
            handleRequest(request: request, dataRequest: dataRequest)
        }
    }
    
    public func cancel() {
        
        for request in requests {
            request.cancel()
        }
    }
    
    private func handleRequest(request:CKRequest,dataRequest:DataRequest) {
        
        dataRequest.responseString(completionHandler: {
            [unowned self]
            dataResponse in
            self.handleResponse(request: request, dataResponse: dataResponse)
        })
    }
    
    private func handleResponse(request:CKRequest,dataResponse:AFDataResponse<String>? = nil) {
        
        request.set(dataResponse: dataResponse)
    }
    
    private func manager() -> Session{
        return AF
    }
}
