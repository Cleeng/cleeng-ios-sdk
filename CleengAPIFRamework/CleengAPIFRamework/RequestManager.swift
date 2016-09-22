//
//  RequestManager.swift
//  CleengAPIFRamework
//
//  Created by Cleeng on 11/07/16.
//  Copyright © 2016 Cleeng. All rights reserved.
//

import Foundation

//
//  AsyncManager.swift
//  CleengAPIFRamework
//
//  Created by Cleeng on 11/07/16.
//  Copyright © 2016 Cleeng. All rights reserved.
//

import Foundation

public class AsyncManager
{
    public init(){
        
    }
    
    /**
     This function simulates an async call from cleeng server to get the CustomerToken.
     
     :param: **receiptNumber**: the receiptNumber entered by user.
     
     :param: **completion**: a closure to execute once the request is comlete.
     
     :returns: No return value
     
     The completion block takes 3 parameters, the data, response, error.
     */
    
    public func getCustomerTokenByTransactionID(receiptNumber:String, completion : (Data:NSData?, Response:NSURLResponse?, Error:NSError?) -> Void)
    {
        let baseUrl = "https://api.cleeng.com/3.0/json-rpc"
        let mapDict = [ "transactionId":"T"+receiptNumber]
        let json = [ "id":"1",
                     "json-rpc":"2.0",
                     "method":"generateCustomerTokenFromTransactionId",
                     "params":mapDict
        ]
        print(json)
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            // create post request
            let url = NSURL(string: baseUrl)!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            // insert json data to the request
            request.HTTPBody = jsonData
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:completion)
            //            { data, response, error in
            //                completion(Data: data, Response: response, Error: error)
            //            }
            task.resume()
        }
        catch let err as NSError{
            completion(Data: nil, Response: nil, Error: err)
        }
        
    }
    
    
    
    /**
     This function simulates an async call from cleeng server to check the accessGrant for any customer by using customerToken.
     
     :param: **customerToken**: the customerToken received in above function.
     
     :param: **eventOfferID**: the eventOfferID of any Event.
     
     :param: **deviceID**: the deviceID of your device.

     :param: **completion**: a closure to execute once the request is comlete.
     
     :returns: No return value
     
     The completion block takes 3 parameters, the data, response, error.
     */
    
    public func getAccessGranted(customerToken:String, eventOfferID:String, deviceID:String,  completion : (Data:NSData?, Response:NSURLResponse?, Error:NSError?) -> Void)
    {
        let baseUrl = "https://api.cleeng.com/3.0/json-rpc"
        // prepare json data
        let mapDict = [ "customerToken":customerToken,
                        "offerId":eventOfferID,
                        "deviceId":deviceID,
                        "deviceType":"iPhone"
        ]
        let json = [ "id":"1",
                     "json-rpc":"2.0",
                     "method":"getAccessStatus",
                     "params":mapDict
        ]
        print(json)
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            // create post request
            let url = NSURL(string: baseUrl)!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            
            // insert json data to the request
            request.HTTPBody = jsonData
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:completion)
            //            { data, response, error in
            //                completion(Data: data, Response: response, Error: error)
            //            }
            task.resume()
        }
        catch let err as NSError{
            completion(Data: nil, Response: nil, Error: err)
        }
        
    }
    
}