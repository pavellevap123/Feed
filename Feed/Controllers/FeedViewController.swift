//
//  ViewController.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 1.09.22.
//

import UIKit

final class FeedViewController: UIViewController {
    
    private let headerView = HeaderView()
    
    private var tiles: [Tile] = []
    
    private var imagesDict: [Int: UIImage?] = [:]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/payback-test.appspot.com/o/feed.json?alt=media&token=3b3606dd-1d09-4021-a013-a30e958ad930")!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            
            let fetchedTiles: Tiles = try! JSONDecoder().decode(Tiles.self, from: data)
            self.tiles = fetchedTiles.tiles
            self.sortTiles()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

        task.resume()
    }
    
    func style() {
        
        //CollectionView
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
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
            
            //Header
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func sortTiles() {
        tiles.sort {
            $0.score > $1.score
        }
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if tiles[indexPath.item].name == "image" {
            let imagedetailVC = ImageDetailViewController()
            if let image = imagesDict[indexPath.item] {
                if image == nil {
                    imagedetailVC.image = UIImage(systemName: "xmark.octagon.fill")
                } else {
                    imagedetailVC.image = image
                }
            }
            navigationController?.pushViewController(imagedetailVC, animated: true)
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
        if tiles[indexPath.item].name == "image" {
            cell.headlineView.label.text = tiles[indexPath.item].headline
            if let subline = tiles[indexPath.item].subline {
                cell.sublineView.label.text = subline
                cell.imageView.bottomAnchor.constraint(equalTo: cell.sublineView.topAnchor).isActive = true
            } else {
                cell.sublineView.isHidden = true
                cell.imageView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor).isActive = true
            }
            let url = URL(string: tiles[indexPath.item].data!)!
            getData(from: url) { data, response, error in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                self.imagesDict[indexPath.item] = image
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
