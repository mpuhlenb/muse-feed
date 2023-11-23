//
//  DetailViewController.swift
//  musefeed
//
//  Created by Morris Uhlenbrauck on 11/22/23.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    var museItem: MuseItem?
    var coordinator: MainCoordinator?
    @IBOutlet var detailImageView: PanZoomImageView?
    @IBOutlet var creatorLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = museItem?.title
        creatorLabel?.text = "Creator: " + (museItem?.maker ?? "")
        setImage()
        // Do any additional setup after loading the view.
    }
    
    
    func setImage() {
        guard let item = museItem, let imageUrl = item.itemImageUrl else { return }
        detailImageView?.imageUrl = imageUrl
        
//            Task {
//                do {
//                    let data = try await detailImageView.downloadImageData(from: imageUrl)
//                    let image = UIImage(data: data)
//                    
//                    detailImageView.image = image
//                } catch  {
//                    print("Error: \(error.localizedDescription)")
//                }
//            }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
