//
//  ViewController.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

import UIKit

final class FeedViewController: UIViewController {
    
    private let headerView = HeaderView()
    
    private let cache = NSCache<NSString, Tiles>()
    
    private var tiles: Tiles?
    
    private var imagesDict: [Int: UIImage?] = [:]
    
    private var shouldUseCache = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        
        makeTilesNetworkCall()
        
        Timer.scheduledTimer(timeInterval: 86400, target: self, selector: #selector(timerFetch), userInfo: nil, repeats: true)
    }
    
    @objc private func timerFetch() {
        shouldUseCache = false
        makeTilesNetworkCall()
    }
    
    private func getCachedTiles() {
        if let cachedVersion = cache.object(forKey: "Tiles") {
            tiles = cachedVersion
            print("Using cached version")
        } else {
            guard let fetchedTiles = tiles else { return }
            cache.setObject(fetchedTiles, forKey: "Tiles")
        }
    }
    
    
    private func makeTilesNetworkCall() {
        if shouldUseCache {
            getCachedTiles()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            return
        }
        
        guard let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/payback-test.appspot.com/o/feed.json?alt=media&token=3b3606dd-1d09-4021-a013-a30e958ad930") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                DispatchQueue.main.async {
                    self?.showInternetConnectionRetryAlert()
                }
            }
            guard let data = data else { return }
            
            do {
                let fetchedTiles: Tiles = try JSONDecoder().decode(Tiles.self, from: data)
                self?.tiles = fetchedTiles
                self?.sortTiles()
                self?.shouldUseCache = true
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch {
                return
            }
        }.resume()
    }
    
    private func showInternetConnectionRetryAlert() {
        let alert = UIAlertController(title: "No internet connection", message: "Check your internet connection", preferredStyle: .alert)
        let action = UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.makeTilesNetworkCall()
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func style() {
        view.addSubview(collectionView)
        
        //NavigationBar
        self.title = "1.357 P"
        navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        
        //HeaderView
        view.addSubview(headerView)
        headerView.addShadowToView(shadow_color: UIColor.gray, offset: CGSize(width: 0, height: 3), shadow_radius: 5.0, shadow_opacity: 0.5, corner_radius: 0.0)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            //Header
            headerView.heightAnchor.constraint(equalToConstant: 50),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            //collectionView
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func sortTiles() {
        tiles?.tiles.sort {
            $0.score > $1.score
        }
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tiles?.tiles[indexPath.item].name == "shopping_list" {
            let shoppingListVC = ShoppingListViewController()
            navigationController?.pushViewController(shoppingListVC, animated: true)
        }
        if tiles?.tiles[indexPath.item].name == "video" {
            let videoDetailVC = VideoDetailViewController()
            if let data = tiles?.tiles[indexPath.item].data {
                videoDetailVC.stringURL = data
            }
            navigationController?.pushViewController(videoDetailVC, animated: true)
        }
        if tiles?.tiles[indexPath.item].name == "image" {
            let imageDetailVC = ImageDetailViewController()
            if let image = imagesDict[indexPath.item] {
                if image == nil {
                    imageDetailVC.image = UIImage(systemName: "xmark.octagon.fill")
                } else {
                    imageDetailVC.image = image
                }
            }
            navigationController?.pushViewController(imageDetailVC, animated: true)
        } else if tiles?.tiles[indexPath.item].name == "website" {
            let webDetailVC = WebDetailViewController()
            if let data = tiles?.tiles[indexPath.item].data {
                webDetailVC.stringUrl = data
            }
            navigationController?.pushViewController(webDetailVC, animated: true)
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let tiles = tiles?.tiles else { return 0 }
        return tiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        cell.headlineView.label.text = tiles?.tiles[indexPath.item].headline
        if let subline = tiles?.tiles[indexPath.item].subline {
            cell.sublineView.label.text = subline
            cell.imageView.bottomAnchor.constraint(equalTo: cell.sublineView.topAnchor).isActive = true
        } else {
            cell.sublineView.isHidden = true
            cell.imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
        }
        if tiles?.tiles[indexPath.item].name == "shopping_list" {
            cell.imageView.image = UIImage(systemName: "list.bullet.circle")
        } else if tiles?.tiles[indexPath.item].name == "video" {
            cell.imageView.image = UIImage(systemName: "video")
        } else if tiles?.tiles[indexPath.item].name == "website" {
            cell.imageView.image = UIImage(systemName: "safari")
        } else if tiles?.tiles[indexPath.item].name == "image" {
            guard let data = tiles?.tiles[indexPath.item].data else { return cell }
            guard let url = URL(string: data) else { return cell }
            getData(from: url) { [weak self] data, response, error in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                self?.imagesDict[indexPath.item] = image
                DispatchQueue.main.async {
                    if image == nil {
                        cell.imageView.image = UIImage(systemName: "xmark.octagon.fill")
                    } else {
                        cell.imageView.image = image
                    }
                }
            }
        }
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 16, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 25, left: 8, bottom: 0, right: 8)
    }
}
