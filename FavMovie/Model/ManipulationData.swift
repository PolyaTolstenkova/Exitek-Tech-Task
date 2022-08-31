//
//  ManipulationData.swift
//  FavMovie
//
//  Created by Полина Толстенкова on 31.08.2022.
//

import Foundation

struct ManipulationData {
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
