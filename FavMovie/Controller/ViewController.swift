//
//  ViewController.swift
//  FavMovie
//
//  Created by Полина Толстенкова on 31.08.2022.
//

import UIKit
import CoreData
import SwipeCellKit

class ViewController: UIViewController {

@IBOutlet weak var TableView: UITableView!
@IBOutlet weak var TitleTextField: UITextField!
@IBOutlet weak var YearTextField: UITextField!
@IBOutlet weak var AddButton: UIButton!
@IBOutlet weak var ErrorLabel: UILabel!

var movieArray = [Movie]()
let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

override func viewDidLoad() {
    super.viewDidLoad()
    AddButton.layer.cornerRadius = 5
    TableView.rowHeight = 70.0
    TableView.dataSource = self
    loadMovies()
}

//MARK: - Add New Movies

@IBAction func AddButtonPressed(_ sender: UIButton) {
    let title = TitleTextField.text!
    let year = YearTextField.text!
    
    clear()
    if title == "" || year == "" {
       ErrorLabel.text = "You can't add empty field"
    }else if Int(year) == nil{
        ErrorLabel.text = "Year must be a number"
    }else if year.count != 4 {
        ErrorLabel.text = "Year must contain 4 symbols"
    }else{
        let newMovie = Movie(context: self.context)
        newMovie.title = title
        newMovie.year = Int16(year)!
        movieArray.append(newMovie)
        for i in 0..<movieArray.count-1 {
            if newMovie.title == movieArray[i].title && newMovie.year == movieArray[i].year {
                ErrorLabel.text = "You have already added this movie"
                context.delete(newMovie)
                movieArray.remove(at: movieArray.count-1)
            }
        }
        saveMovies()
    }
}
 
func clear() {
    ErrorLabel.text = ""
    TitleTextField.text = ""
    YearTextField.text = ""
    TitleTextField.endEditing(true)
    YearTextField.endEditing(true)
}

//MARK: - Model Manipulation Data

func saveMovies() {
    do {
        try context.save()
    }catch{
        print("Error saving context: \(error)")
    }
    
    TableView.reloadData()
}

func loadMovies() {
    let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        do {
            movieArray = try context.fetch(request)
        }catch{
            print("error fetching context: \(error)")
        }
        TableView.reloadData()
    }
}





//MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavMovieCell") as! SwipeTableViewCell
        
        let movie = movieArray[indexPath.row]
        cell.delegate = self
        
        if let safeMovieTitle = movie.title {
            cell.textLabel!.text = "\(safeMovieTitle) \(movie.year)"
        }
        
        return cell
    }

}

//MARK: - SwipeTableViewCellDelegate

extension ViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.context.delete(self.movieArray[indexPath.row])
            self.movieArray.remove(at: indexPath.row)
            self.saveMovies()
        }

        deleteAction.image = UIImage(named: "delete-icon")
        return [deleteAction]
    }
    
}



