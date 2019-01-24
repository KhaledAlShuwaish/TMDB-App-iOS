//
//  FavouriteViewController.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 23/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SafariServices

class FavouriteViewController: UIViewController  , SFSafariViewControllerDelegate{

    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestMovies()
    }
    
    func RequestMovies() {
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/authentication/token/new?api_key=54d967b50f9705aa762c1ebbd833a254")!) { (data, response, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    let json = JSON(jsonResult)
                    print(json)
                    let requestToken = json["request_token"].stringValue
                    print(requestToken)
                    self.defaults.set(requestToken, forKey: "request_token")
                }
                DispatchQueue.main.async {
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func RequestAccount() {
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/account?api_key=54d967b50f9705aa762c1ebbd833a254&session_id=\(self.defaults.object(forKey: "session_id") as! String)")!) { (data, response, error) in
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    print(jsonResult)
                    let json = JSON(jsonResult)
                    print("\n\n\n\nthis is json from session id  \(json)")
                    let AccountID = json["id"].intValue
                    self.defaults.set(AccountID, forKey: "AccountID")
                }
                DispatchQueue.main.async {
                }
            } catch {
                print(error)
            }
            }.resume()
    }

    func requestSessionID2(){
        let requestToken =  self.defaults.object(forKey: "request_token") as! String

        let parameters = ["request_token": requestToken]
        let url = URL(string: "https://api.themoviedb.org/3/authentication/session/new?api_key=54d967b50f9705aa762c1ebbd833a254")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                    print(jsonResult)
                    DispatchQueue.main.sync {

                    let json        = JSON(jsonResult)
                    let statusCode  = json["status_code"].intValue
                    if statusCode == 17{
                        print("Soooooory")
                    }
                    else{
                        let sessionID   = json["session_id"].stringValue
                        self.defaults.set(true, forKey: "Log-in")
                        self.defaults.set(sessionID, forKey: "session_id")
                        print("this is you want \(self.defaults.object(forKey: "session_id") as! String)")
                        self.RequestAccount()
                        self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    @IBAction func Redirect(_ sender: Any) {
        authorizeRequestToken()
    }
    
    func authorizeRequestToken(){
        let requestToken = self.defaults.object(forKey: "request_token") as! String
        if let url = URL(string: "https://www.themoviedb.org/authenticate/\(requestToken)") {
            let svc = SFSafariViewController(url: url)
            svc.delegate = self
            present(svc, animated: true, completion: nil)
    }
}
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
        print("Baaaaack")
        requestSessionID2()
    }
   
}


