//
//  ViewController.swift
//  RestApiExample
//
//  Created by Shikha Gupta on 22/11/16.
//  Copyright © 2016 shikha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let todoEndPoint :String = "http://jsonplaceholder.typicode.com/todos"
        
        guard let url = URL(string: todoEndPoint) else {
            print("Error : Unable to create url")
            return
        }
        
        performGetRequest(url: url)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func performGetRequest(url : URL)
    {
        //1. Create urlRequest
        let urlRequest = URLRequest(url: url)
        
        //2. Create url config : default means for get request
        let urlConfig = URLSessionConfiguration.default
        
        //3. Create url session using url congig
        let urlSession = URLSession(configuration: urlConfig)
        
        //3.1 Can be used as an alternative of above
        // let session = URLSession.shared
        
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
                    
                    
                    guard let todo = json as? [String : AnyObject] else
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

