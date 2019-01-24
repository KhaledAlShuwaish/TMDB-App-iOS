//
//  TableViewController.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 20/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TableViewController: UITableViewController {
    var movies = [Movie]()
    var page = 0
    @IBOutlet var Tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestMovies()
    }

   
    func RequestMovies() {
        page = page + 1
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=54d967b50f9705aa762c1ebbd833a254&language=en-US&page=\(page)")!) { (data, response, error) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let title = movies[(indexPath as NSIndexPath).row].title
        cell.MovieTitle?.text = title
        let poster_path = movies[(indexPath as NSIndexPath).row].poster_path
        if let CheckPosterPath = poster_path {
            ImageRequestForCell(cellForRowAt: indexPath, cell: cell, URL: CheckPosterPath)
        } else {
            cell.MovieImage.image = UIImage(named: "EmptyPerson")
        }
        if indexPath.row == (movies.count - 1) {
            RequestMovies()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let DetailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "DViewController") as! DetailsViewController
        DetailsViewController.MoviewDetails = self.movies[indexPath.row]
        let poster_path = movies[(indexPath as NSIndexPath).row].poster_path
        
        if let CheckPosterPath = poster_path {
            ImageRequestForVC(cellForRowAt: indexPath, VC: DetailsViewController, URL: CheckPosterPath)
        } else {
            DetailsViewController.MoviewImage?.image = UIImage(named: "EmptyPerson")
        }
        self.navigationController?.pushViewController(DetailsViewController, animated: true)
    }
    
    func ImageRequestForCell(cellForRowAt indexPath: IndexPath ,cell : TableViewCell , URL : String) {
        let PosterPath = ("https://image.tmdb.org/t/p/w500/" + URL) as URLConvertible
        Alamofire.request(PosterPath).responseImage { response  in
            if let image = response.result.value {
                cell.MovieImage.image = image
            }
        }
    }
    
    func ImageRequestForVC(cellForRowAt indexPath: IndexPath ,VC : DetailsViewController , URL : String) {
        let PosterPath = ("https://image.tmdb.org/t/p/w500/" + URL) as URLConvertible
        Alamofire.request(PosterPath).responseImage { response  in
            if let image = response.result.value {
                VC.MoviewImage?.image = image
            }
        }
    }
    
    @IBAction func SearchButton(_ sender: Any) {
        let SearchMovieTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchMovieTableViewController") as! SearchMovieTableViewController
        self.navigationController?.pushViewController(SearchMovieTableViewController, animated: true)
    }
}
