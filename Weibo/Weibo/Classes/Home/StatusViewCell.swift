//
//  StatusViewCell.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/4.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import UIKit
import SDWebImage

private let edgeMargin: CGFloat = 15
private let itemMargin: CGFloat = 10

class StatusViewCell: UITableViewCell {

    @IBOutlet weak var contentLabelWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var verifiedView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var vipView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var retweetedContentL: UILabel!
    @IBOutlet weak var picView: PicCollectionView!
    @IBOutlet weak var picViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var picViewWidthCons: NSLayoutConstraint!
    var viewModel:StatusViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            iconView.sd_setImage(with: viewModel.profileURL as? URL, placeholderImage: UIImage(named: "avatar_default_small"))
            
            verifiedView.image = viewModel.verifiedImage
            screenNameLabel.text = viewModel.status?.user?.screen_name
            vipView.image = viewModel.vipImage
            timeLabel.text = viewModel.createAtText
            sourceLabel.text = viewModel.sourceText
            contentLabel.text = viewModel.status?.text
            screenNameLabel.textColor = viewModel.vipImage == nil ? UIColor.black : UIColor.orange
            let picViewSize = calculate(picCount: viewModel.picURLs.count)
            picViewWidthCons.constant = picViewSize.width
            picViewHeightCons.constant = picViewSize.height
            picView.picURLs = viewModel.picURLs
            if viewModel.status?.retweeted_status != nil {
                if let screenName = viewModel.status?.retweeted_status?.user?.screen_name, let retweetedText = viewModel.status?.retweeted_status?.text {
                    retweetedContentL.text = "@" + screenName + ":" + retweetedText
                }

                
            } else {
                retweetedContentL.text = nil
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabelWidthCons.constant = UIScreen.main.bounds.size.width - 2*edgeMargin
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



// MARK: - calculate collectionView size
extension StatusViewCell {
    func calculate(picCount: Int) -> CGSize {
        //no pic, 1 pic, 4 pics, other
        if picCount == 0 {
            return .zero
        }
        
        let layout = picView.collectionViewLayout as! UICollectionViewFlowLayout
        
        
        if picCount == 1 {
            let image = SDWebImageManager.shared().imageCache.imageFromDiskCache(forKey: viewModel?.picURLs.last?.absoluteString)
            layout.itemSize = (image?.size)!
            return (image?.size)!
        }
        
        
        let imageWH = (UIScreen.main.bounds.size.width - 2*edgeMargin - 2*itemMargin) / 3
        layout.itemSize = CGSize(width: imageWH, height: imageWH)
        
        if picCount == 4 {
            let picViewWH = 2*imageWH + itemMargin
            return CGSize(width: picViewWH, height: picViewWH)
        }
        
        let rows = CGFloat((picCount - 1) / 3 + 1)
        let picViewH = rows * imageWH + (rows - 1) * itemMargin
        let picViewW = UIScreen.main.bounds.size.width - 2 * edgeMargin
        return CGSize(width: picViewW, height: picViewH)
    }
}




















