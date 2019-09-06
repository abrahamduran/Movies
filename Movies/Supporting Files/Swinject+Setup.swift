//
//  Swinject+Setup.swift
//  Movies
//
//  Created by Abraham Isaac Durán on 9/5/19.
//  Copyright © 2019 Abraham Isaac Durán. All rights reserved.
//

import Foundation
import Alamofire
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc static func setup() {
        
        // MARK: Discover Movies
        defaultContainer.storyboardInitCompleted(DiscoverViewController.self) { (r, c) in
            c.viewModel = r.resolve(DiscoverViewModelType.self)!
        }
        defaultContainer.register(DiscoverViewModelType.self) { r in
            return DiscoverViewModel(moviesService: r.resolve(MoviesServiceType.self)!)
        }
        
        // MARK: Favorite Movies
        defaultContainer.storyboardInitCompleted(FavoritesViewController.self) { (r, c) in
            c.viewModel = r.resolve(FavoritesViewModelType.self)!
        }
        defaultContainer.register(FavoritesViewModelType.self) { r in
            return FavoritesViewModel(moviesService: r.resolve(MoviesServiceType.self)!)
        }
        
        // MARK: Watch List Movies
        defaultContainer.storyboardInitCompleted(WatchListViewController.self) { (r, c) in
            c.viewModel = r.resolve(WatchListViewModelType.self)!
        }
        defaultContainer.register(WatchListViewModelType.self) { r in
            return WatchListViewModel(moviesService: r.resolve(MoviesServiceType.self)!)
        }
        
        // MARK: Movie Detail
        defaultContainer.storyboardInitCompleted(MovieDetailViewController.self) { (r, c) in
            c.viewModel = r.resolve(MovieDetailViewModelType.self)!
        }
        defaultContainer.register(MovieDetailViewModelType.self) { r in
            return MovieDetailViewModel(moviesService: r.resolve(MoviesServiceType.self)!)
        }
        
        // MARK: DataSource
        defaultContainer.register(MoviesServiceType.self) { r in
            return MoviesService(
                inMemory: InMemoryCacheService(),
                database: RealmService(),
                network: APIService(apiClient: r.resolve(APIClient.self)!),
                dispatchQueue: DispatchQueue.datasource)
        }.inObjectScope(.container)
        
        // MARK: API
        defaultContainer.register(APIClient.self) { r in
            let params = try! NetworkParameters.appConfiguration()
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = params.timeoutForRequest
            
            let manager = SessionManager(configuration: config)
            
            let requesAdapter = RequesAdapter(
                authKeyName: params.authKeys.keys.first!,
                authKeyValue: params.authKeys.values.first!)
            manager.adapter = requesAdapter
            
            return APIClient(baseUrl: params.apiUrl, manager: manager, reachability: ReachabilityManager.shared)
        }.inObjectScope(.container)
    }
}
