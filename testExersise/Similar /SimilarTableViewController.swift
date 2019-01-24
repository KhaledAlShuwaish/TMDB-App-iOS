//
//  SimilarTableViewController.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 21/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SimilarTableViewController: UITableViewController {
    @IBOutlet var Tableview: UITableView!
    var movies = [Movie]()
    var MovieDetails : Movie!
    var page = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RequestMovie()
    }
    
    func RequestMovie() {
        page = page + 1
        URLSession.shared.dataTask(with: URL(string: "https://api.themoviedb.org/3/movie/\(MovieDetails.id)/similar?api_key=54d967b50f9705aa762c1ebbd833a254&language=en-US&page=\(page)")!) { (data, response, error) in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimilarCell", for: indexPath) as! SimilarTableViewCell
        let title = movies[(indexPath as NSIndexPath).row].title
        cell.SimilarTitle?.text = title
        let PosterPath = movies[(indexPath as NSIndexPath).row].poster_path
        if let CheckPosterPath = PosterPath {
            ImageRequestForCell(cellForRowAt: indexPath, cell: cell, URL: CheckPosterPath)
            
        } else {
            cell.SimilarImage.image = UIImage(named: "EmptyPerson")
        }
        if indexPath.row == (movies.count - 1) {
            RequestMovie()
        }
        return cell
    }
    
    func ImageRequestForCell(cellForRowAt indexPath: IndexPath ,cell : SimilarTableViewCell , URL : String) {
        let PosterPath = ("https://image.tmdb.org/t/p/w500/" + URL) as URLConvertible
        Alamofire.request(PosterPath).responseImage { response  in
            if let image = response.result.value {
                cell.SimilarImage.image = image
            }
        }
    }
}
