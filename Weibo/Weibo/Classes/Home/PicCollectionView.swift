//
//  PicCollectionView.swift
//  Weibo
//
//  Created by han xuelong on 2017/1/5.
//  Copyright © 2017年 han xuelong. All rights reserved.
//

import UIKit

class PicCollectionView: UICollectionView {

    var picURLs: [URL] = [URL]() {
        didSet {
            self.reloadData()
        }
    }
    
    
    override func awakeFromNib() {
        dataSource = self
        register(PicCollectionViewCell.self, forCellWithReuseIdentifier: "picCell")
    }

}

extension PicCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! PicCollectionViewCell
        cell.picURL = picURLs[indexPath.item]
        return cell
    }
}


class PicCollectionViewCell: UICollectionViewCell {
    let imgView: UIImageView! = UIImageView()
    var picURL: URL? {
        didSet {
            guard let picURL = picURL else {
                return
            }
            imgView.sd_setImage(with: picURL, placeholderImage: UIImage(named: "empty_picture"))
            imgView.contentMode = .scaleAspectFit
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let rect = self.frame
        imgView.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        addSubview(imgView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












