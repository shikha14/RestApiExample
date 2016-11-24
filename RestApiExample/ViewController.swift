//
//  ViewController.swift
//  RestApiExample
//
//  Created by Shikha Gupta on 22/11/16.
//  Copyright © 2016 shikha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum URLENDPOINTS :String {
        case GET_TODO_LIST = "http://jsonplaceholder.typicode.com/todos"
        case GET_TODO = ""
        case POST_TODO = "http://jsonplaceholder.typicode.com/posts"
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let todoEndPoint :String = URLENDPOINTS.GET_TODO_LIST.rawValue
        performGetRequest(url: todoEndPoint)
        
        let json : [String :Any] = ["title": "Android TO DO","body": "Learn material design" ,"userId": 1147, "id": 200]
        let todoPostEndPoint :String = URLENDPOINTS.POST_TODO.rawValue
        performPostRequest(url: todoPostEndPoint, params: json)
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    public func getUrlRequest(url: URL,httpMethod:String) -> URLRequest
    {
        
        var urlRequest = URLRequest(url: url)
        
        switch httpMethod {
        case "POST":
            urlRequest.httpMethod = httpMethod
        default:
            print("Inside default of get url request")
        }
        
        return urlRequest
        
    }
    
    
    public func getUrl(url: String) -> URL?{
        
        guard let urlEndPoint = URL(string: url) else {
            print("Error in converting string url to url")
            return nil
        }
        
        return urlEndPoint
        
        
        
    }
    
    public func toJsonData(json: [String : Any]) -> Data?
    {
        do {
            let json =  try JSONSerialization.data(withJSONObject: json, options: [])
            return json
            
        } catch {
            print("Caught Error : Cannot convert into json data ")
            return nil
        }
        
    }
    
    
    public func getUrlSession() -> URLSession
    {
        let config = URLSessionConfiguration.default
        let urlSession = URLSession(configuration: config)
        // Can be used as an alternative of above
        // let session = URLSession.shared
        return urlSession
        
    }
    
    
    public func performPostRequest(url :String,params : [String: Any])
    {
        guard let urlEndPoint = getUrl(url: url) else {
            print("Error : converting string url to url")
            return
        }
        
        var urlRequest = getUrlRequest(url: urlEndPoint, httpMethod: "POST")
        let jsonData = toJsonData(json: params)
        urlRequest.httpBody = jsonData
        
        let urlSession = getUrlSession()
        
        let task = urlSession.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            
            guard error == nil else {
                print("Error : Occured while data task ::" +  (error?.localizedDescription)!)
                return
            }
            
            guard let dataResponse = data else {
                print("Error : did not received data")
                return
            }
            
            
            do{
                let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? [String : Any]
                
                print(jsonResponse ?? "default value")
            }catch{
                print("Error : Unable to convert dataResponse to json")
                return
            }
            
        })
        
        
        task.resume()
    }
    
    
 
    
    public func performGetRequest(url : String)
    {
        
        
        guard let urlEndPoint = getUrl(url: url) else {
            print("Error : converting string url to url")
            return
        }
        
        let urlRequest = getUrlRequest(url: urlEndPoint, httpMethod: "GET")
        let urlSession = getUrlSession()
        
        //
        //        //1. Create urlRequest
        //        let urlRequest = URLRequest(url: url)
        //
        //
        //        //2. Create url config : default means for get request
        //        let urlConfig = URLSessionConfiguration.default
        //
        //        //3. Create url session using url congig
        //        let urlSession = URLSession(configuration: urlConfig)
        //
        //        //3.1 Can be used as an alternative of above
        //        // let session = URLSession.shared
        
        //4. Create data task using urlrequest
        let task = urlSession.dataTask(with: urlRequest, completionHandler:  { (data, response, error) in
            //            print(error)
            //            print(response)
            
            //4.1. checking for any erros
            guard error == nil else{
                print(error)
                return
            }
            
            //4.2. Make sure we got data
            guard let responseData = data else {
                print("Error : Did not received data")
                return
            }
            
            //4.3 Parsing json
            
            do{
                guard let jsonArray = try JSONSerialization.jsonObject(with: responseData, options: []) as? NSArray else{
                    print("Error : In converting data to Json")
                    return
                }
                
                //print(json.description)
                
                
                
                
                for json in jsonArray{
                    //                    print(json)
                    
                    
                    guard let todo = json as? [String : Any] else
                    {
                        print("Error : JSON Can not be casted in disctionary")
                        return
                    }
                    
                    guard let title = todo["title"]  as? String else{
                        print("Error : value of title not found")
                        return
                        
                    }
                    print("Title of todo :\(title)")
                    
                }
                
                
                
                
                
            }catch
            {
                print("Error : Caught Error while converting data to json")
                return
                
            }
            
            
            
            
            
        })
        
        // 5. Execute data task
        task.resume()
        
        
    }
    
    
    
}

