//
//  MainTableViewCell.swift
//  RxSwiftDemo
//
//  Created by Steven Hsieh on 2020/6/18.
//  Copyright © 2020 Steven Hsieh. All rights reserved.
//

import UIKit
import SDWebImage

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {  //重點一行 避免cell出問題
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
    }
    
    func setUp(model: PhotoModel){
        titleLabel.text = model.title
        albumLabel.text = "Album id: \(model.albumId)"
        idLabel.text = "ID: \(model.id)"
        imgView.sd_setImage(with: URL(string: model.url), completed: nil)
    }
    
}
