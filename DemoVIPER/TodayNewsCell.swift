//
//  TodayNewsCell.swift
//  DemoVIPER
//
//  Created by JOYAL SERRAO on 06/12/19.
//  Copyright © 2019 Joyal Serrao. All rights reserved.
//

import UIKit

enum TodayNewsCellTag : String, CustomStringConvertible {
    case Title
    case Author
    case Description
    var description: String {
        return NSLocalizedString(self.rawValue, comment: "")+": "
    }
}

class TodayNewsCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func updateView(model:Articles) {
        imageIcon.downloaded(from: model.urlToImage ?? "")
        labelTitle.attributedText = self.attributedJoint(model.title ?? "", .Title)
        labelAuthor.attributedText = self.attributedJoint(model.author ?? "", .Author)
        labelDescription.attributedText = self.attributedJoint(model.description ?? "", .Description)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}


extension TodayNewsCell {
    func attributedJoint(_ description:String,_ type:TodayNewsCellTag) -> NSAttributedString {
        let attributesTitle = [NSAttributedString.Key.foregroundColor: UIColor.green,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let attributesDisc = [NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
     
        let attributedString = NSAttributedString(string:description,
                                                  attributes:attributesDisc)
        let tag = NSMutableAttributedString(string:type.description,
                                            attributes:attributesTitle)
        tag.append(attributedString)
        return tag.copy() as! NSAttributedString
    }
}
