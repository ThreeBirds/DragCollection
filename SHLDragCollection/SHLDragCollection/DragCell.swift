//
//  DragCell.swift
//  SHLDragDemo
//
//  Created by shl on 16/8/29.
//  Copyright © 2016年 shl. All rights reserved.
//

import UIKit

class DragCell: UICollectionViewCell {
    
    var title: String {
        didSet {
            lab.text = title
        }
    }
    
    var isShake: Bool {
        
        didSet {
            shake(shake: isShake)
        }
    }
    
    var lab: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        title = ""
        isShake = false
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.green()
        
        lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(lab)
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: ["view":lab]))
        
    }
    
    func shake(shake: Bool) -> Void {
        
        if shake {
            let ani = CABasicAnimation(keyPath: "transform.rotation.z")
            ani.fromValue       = -M_PI_4/8
            ani.toValue         = M_PI_4/8
            ani.duration        = 0.1
            ani.autoreverses    = true
            ani.repeatCount     = MAXFLOAT
            self.layer.add(ani, forKey: "ani")
            return
        }
        
        self.layer.removeAllAnimations()
    }
    
}
