//
//  FavouriteTableViewController.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 23/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class FavouriteTableViewController: UITableViewController {
    var movies = [Movie]()
    var page = 0
    let UserDefulte = UserDefaults.standard
    var islogin = false
    @IBOutlet var Tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestMovies()
    }

    func RequestMovies() {
        page = page + 1
        let defult = UserDefaults.standard
        var login = defult.bool(forKey: "Log-in")
        islogin = login
        if (islogin){
            let vcc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteViewController") as! FavouriteViewController
            self.present(vcc, animated: true, completion: nil)
        }
        
        URLSession.shared.dataTask(with: URL(string:"https://api.themoviedb.org/3/account/\(UserDefulte.integer(forKey: "AccountID"))/favorite/movies?api_key=54d967b50f9705aa762c1ebbd833a254&session_id=\(UserDefulte.object(forKey: "session_id")as! String)&language=en-US&sort_by=created_at.asc&page=\(page)")!) { (data, response, error) in
            do {
                let list = try JSONDecoder().decode(MovieResult.self, from: data!)
                self.movies.append(contentsOf: list.results)
                DispatchQueue.main.async {
                    self.Tableview.reloadData()
                }
            } catch {
                print(error)
            }
            }.resume()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavouriteTableViewCell
        let title = movies[(indexPath as NSIndexPath).row].title
        cell.TitleFavoMovie?.text = title
        let poster_path = movies[(indexPath as NSIndexPath).row].poster_path
        if let CheckPosterPath = poster_path {
            ImageRequestForCell(cellForRowAt: indexPath, cell: cell, URL: CheckPosterPath)
        } else {
            cell.ImageFavoMovie.image = UIImage(named: "EmptyPerson")
        }
        if indexPath.row == (movies.count - 1) {
            RequestMovies()
        }
        return cell
    }
    
    func ImageRequestForCell(cellForRowAt indexPath: IndexPath ,cell : FavouriteTableViewCell , URL : String) {
        let PosterPath = ("https://image.tmdb.org/t/p/w500/" + URL) as URLConvertible
        Alamofire.request(PosterPath).responseImage { response  in
            if let image = response.result.value {
                cell.ImageFavoMovie.image = image
            }
        }
    }

    
}
