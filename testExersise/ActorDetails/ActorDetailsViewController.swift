//
//  ActorDetailsViewController.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 21/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class ActorDetailsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    @IBOutlet weak var ActorImage: UIImageView!
    var page = 0
    var movies = [Movie]()
    var ActorDetails :Cast!
    @IBOutlet weak var Tableview: UITableView!
    @IBOutlet weak var actorname: UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        actorname?.text = ActorDetails.name
    }
    
    func RequestMovies() {
        page = page + 1
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/person/\(ActorDetails.id)/movie_credits?api_key=54d967b50f9705aa762c1ebbd833a254&language=en-US")!) { (data, response, error) in
            do {
                let list = try JSONDecoder().decode(MovieCastResult.self, from: data!)
                self.movies.append(contentsOf: list.cast)
                DispatchQueue.main.async {
                    self.Tableview.reloadData()
                }
            } catch {
                print(error)
            }
            }.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActorDetailsTableViewCell", for: indexPath) as! ActorDetailsTableViewCell
        let title = movies[(indexPath as NSIndexPath).row].title
        cell.ActorName?.text = title
        let poster_path = movies[(indexPath as NSIndexPath).row].poster_path
        if let CheckPosterPath = movies[(indexPath as NSIndexPath).row].poster_path {
            ImageRequestForCell(cellForRowAt: indexPath, cell: cell, URL: CheckPosterPath)
        } else {
            cell.ActorImage.image = UIImage(named: "EmptyPerson")
        }
        return cell
    }
    
    func ImageRequestForCell(cellForRowAt indexPath: IndexPath ,cell : ActorDetailsTableViewCell , URL : String) {
        let PosterPath = ("https://image.tmdb.org/t/p/w500/" + URL) as URLConvertible
        Alamofire.request(PosterPath).responseImage { response  in
            if let image = response.result.value {
                cell.ActorImage.image = image
            }
        }
    }
    
    
    

}
