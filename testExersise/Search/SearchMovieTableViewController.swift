//
//  SearchMovieTableViewController.swift
//  testExersise
//
//  Created by Khaled Shuwaish on 20/01/2019.
//  Copyright © 2019 Khaled Shuwaish. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class SearchMovieTableViewController: UITableViewController , UISearchBarDelegate {
    @IBOutlet weak var Search: UISearchBar!
    @IBOutlet var Tableview: UITableView!
    
    var movies = [Movie]()
    var page = 0
    var CompareText = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Tableview.reloadData()
    }
   
    @IBAction func start(_ sender: Any) {
        load(newQuery: Search.text ?? "error")
        Tableview.reloadData()
    }
    
    func load(newQuery : String){
        page = page + 1
        CompareText = Search.text ?? "error"
        let BasedUrl = "https://api.themoviedb.org/3/search/movie?api_key=54d967b50f9705aa762c1ebbd833a254&language=en-US&query=\(newQuery)&page=\(page)&include_adult=false"
        let NewURL = BasedUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
         URLSession.shared.dataTask(with: URL(string: NewURL!)!) { (data, response, error) in
            do {
                let list = try JSONDecoder().decode(MovieResult.self, from: data!)
                print(list)
                if newQuery == self.CompareText{
                    self.movies.append(contentsOf: list.results)
                }else{
                    self.movies = list.results
                }
                DispatchQueue.main.async(execute: {
                    self.Tableview.reloadData()
                })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "sCell", for: indexPath) as! SearchTableViewCell
        let title = movies[(indexPath as NSIndexPath).row].title
        cell.MovieTitleSearch?.text = title
        let PosterPath = movies[(indexPath as NSIndexPath).row].poster_path
        if let NewPosterPath = PosterPath {
            ImageRequestForCell(cellForRowAt: indexPath, cell: cell, URLl: NewPosterPath)
        } else {
            cell.ImageViewSearch.image = UIImage(named: "EmptyPerson")
        }
        if indexPath.row == (movies.count - 1) {
            load(newQuery: Search.text ?? "error")
        }
        return cell
    }
    

    override func viewWillAppear(_ animated: Bool) {
        Tableview.reloadData()
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
    }

    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        load(newQuery: Search.text!)
        Tableview.reloadData()
        return true
    }
    
    func ImageRequestForCell(cellForRowAt indexPath: IndexPath ,cell : SearchTableViewCell , URLl : String) {
        let PosterPath = ("https://image.tmdb.org/t/p/w500/" + URLl) as URLConvertible
        Alamofire.request(PosterPath).responseImage { response  in
            if let image = response.result.value {
                cell.ImageViewSearch.image = image
            }
        }
    }
    
    
    func alert(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }

    
    
}
