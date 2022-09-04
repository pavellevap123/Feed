//
//  VideoDetailViewController.swift
//  Feed
//
//  Created by Pavel Poddubotskiy on 2.09.22.
//

import UIKit
import AVKit
import AVFoundation

final class VideoDetailViewController: UIViewController {
    
    var stringURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let optionalUrl = URL(string: stringURL)
        guard let url = optionalUrl else { return }
        playVideo(url: url)
    }
}

extension VideoDetailViewController {
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
}
