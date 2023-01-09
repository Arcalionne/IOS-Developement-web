//
//  ScheduleAPI.swift
//  Event_Efrei
//
//  Created by CGalbon on 17/12/2022.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum CustomError: Error {
    case requestError
    case statusCodeError
    case parsingError
}

class ScheduleApiCall {
    internal func prepareRequest(urlStr:String, requestType: RequestType, params: [String]?) -> URLRequest
    {
        var baseURL = URL(string:urlStr)!
        if let params = params {
                    var urlParams = urlStr
                    for param in params {
                        urlParams = urlParams + "/" + param
                    }
                    baseURL = URL(string: urlParams)!
                }
        var request = URLRequest(url:baseURL)
        request.setValue("Bearer keymaCPSexfxC2hF9", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 100
        request.httpMethod=requestType.rawValue
        return request
    }
    func getSchedule(callback:@escaping ((errorType:CustomError?,errorMessage:String?),[EventRecord]?) -> ()) {
        let url="https://api.airtable.com/v0/appLxCaCuYWnjaSKB/%F0%9F%93%86%20Schedule?view=Full%20schedule" 
        let session=URLSession(configuration: .default)
        let _: Void = session.dataTask(with: prepareRequest(urlStr: url, requestType: .get, params:nil)) { (data, headersResponse, errors) in

            if let data = data, errors==nil{
                if let responseHTTP = headersResponse as? HTTPURLResponse{
                    if responseHTTP.statusCode == 200{
                        let jd: JSONDecoder =  JSONDecoder()
                        jd.dateDecodingStrategy = .customISO8601
                        if let response = try?
                            jd.decode(EventRecords.self, from:data){
                            callback((nil,nil), response.records)
                        }
                        else{
                            callback((CustomError.parsingError, "Parsing error"), nil)
                        }
                    }
                    else
                    {
                        callback((CustomError.statusCodeError, "Status code error"), nil)
                    }
                }
            }
            else{
                callback((CustomError.requestError,errors.debugDescription), nil)
            }
            
        }
        .resume()
    }
    func getSpeakers(callback:@escaping ((errorType:CustomError?,errorMessage:String?),[SpeakerRecord]?) ->()){
        let url = "https://api.airtable.com/v0/appLxCaCuYWnjaSKB/%F0%9F%8E%A4%20Speakers?&view=All%20speakers"
        
        let session=URLSession(configuration: .default)
        let _: Void = session.dataTask(with: prepareRequest(urlStr: url, requestType: .get, params:nil)) { (data, headersResponse, errors) in
            if let data = data, errors==nil{
                if let responseHTTP = headersResponse as? HTTPURLResponse{
                    if responseHTTP.statusCode == 200{
                        let jd: JSONDecoder =  JSONDecoder()
                        jd.dateDecodingStrategy = .customISO8601
                        if let response = try?
                            jd.decode(SpeakerRecords.self, from:data){
                            callback((nil,nil), response.records)
                        }
                        else{
                            callback((CustomError.parsingError, "Parsing error"), nil)
                        }
                    }
                    else
                    {
                        callback((CustomError.statusCodeError, "Status code error"), nil)
                    }
                }
            }
            else{
                callback((CustomError.requestError,errors.debugDescription), nil)
            }
            
        }
        .resume()
    }
    
    func getEventFromID(eventID: String, callback:@escaping ((errorType:CustomError?,errorMessage:String?),EventRecord?) ->()){
        let url = "https://api.airtable.com/v0/appLxCaCuYWnjaSKB/%F0%9F%93%86%20Schedule"
        
        let session=URLSession(configuration: .default)
        let _: Void = session.dataTask(with: prepareRequest(urlStr: url, requestType: .get, params:[eventID])) { (data, headersResponse, errors) in
            if let data = data, errors==nil{
                if let responseHTTP = headersResponse as? HTTPURLResponse{
                    if responseHTTP.statusCode == 200{
                        let jd: JSONDecoder =  JSONDecoder()
                        jd.dateDecodingStrategy = .customISO8601
                        if let response = try?
                            jd.decode(EventRecord.self, from:data){
                            callback((nil,nil), response)
                        }
                        else{
                            callback((CustomError.parsingError, "Parsing error"), nil)
                        }
                    }
                    else
                    {
                        callback((CustomError.statusCodeError, "Status code error"), nil)
                    }
                }
            }
            else{
                callback((CustomError.requestError,errors.debugDescription), nil)
            }
            
        }
        .resume()
    }
    func getSpeakerFromID(speakerID: String, callback:@escaping ((errorType:CustomError?,errorMessage:String?),SpeakerRecord?) ->()){
        let url = "https://api.airtable.com/v0/appLxCaCuYWnjaSKB/%F0%9F%8E%A4%20Speakers"
        
        let session=URLSession(configuration: .default)
        let _: Void = session.dataTask(with: prepareRequest(urlStr: url, requestType: .get, params:[speakerID])) { (data, headersResponse, errors) in
            if let data = data, errors==nil{
                if let responseHTTP = headersResponse as? HTTPURLResponse{
                    if responseHTTP.statusCode == 200{
                        let jd: JSONDecoder =  JSONDecoder()
                        jd.dateDecodingStrategy = .customISO8601
                        if let response = try?
                            jd.decode(SpeakerRecord.self, from:data){
                            callback((nil,nil), response)
                        }
                        else{
                            callback((CustomError.parsingError, "Parsing error"), nil)
                        }
                    }
                    else
                    {
                        callback((CustomError.statusCodeError, "Status code error"), nil)
                    }
                }
            }
            else{
                callback((CustomError.requestError,errors.debugDescription), nil)
            }
            
        }
        .resume()
    }
}
