//
//  DragFlowLayout.swift
//  SHLDragDemo
//
//  Created by shl on 16/8/29.
//  Copyright © 2016年 deppon. All rights reserved.
//

import UIKit

class DragFlowLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate{

    struct DragModel {
        var indexPath: IndexPath?
        var cell: DragCell?
        var imgv: UIImageView?
    }
    
    private var model: DragModel = DragModel(indexPath: nil, cell: nil, imgv: nil)
    
    override func prepare() {
        super.prepare()
        
        let ges = UILongPressGestureRecognizer(target: self, action: #selector(DragFlowLayout.gesture(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(gesture(_:)))
        pan.delegate = self
        collectionView?.addGestureRecognizer(ges)
        collectionView?.addGestureRecognizer(pan)

        collectionView?.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
    }
    
    func gesture(_ ges: UIGestureRecognizer) -> Void {
        
        func began(ges: UIGestureRecognizer) -> Void {
            
            let point = ges.location(in: collectionView)
            reset(ges: ges)
            /* 获取当前长按的图标. */
            for cell in (collectionView?.visibleCells())! {
                
                if cell.frame.contains(point) {
                    
                    /* 将当前图标隐藏，并创建一个可拖动的图片. */
                    model.cell = cell as? DragCell
                    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.isOpaque, 0)
                    cell.layer.render(in: UIGraphicsGetCurrentContext()!)
                    let img = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    let imgv = UIImageView(frame: cell.frame)
                    imgv.image = img
                    model.imgv = imgv
                    model.indexPath = collectionView?.indexPath(for: cell)
                    
                    collectionView?.addSubview(imgv)
                    cell.isHidden = true
                    
                    if ges.classForCoder === UILongPressGestureRecognizer.classForCoder() {
                        model.cell?.isShake = true
                    }
                    
                    if ges.classForCoder === UIPanGestureRecognizer.classForCoder() {
                        
                    }
                }
            }
        }
        
        func reset(ges: UIGestureRecognizer) {
            if ges.classForCoder === UILongPressGestureRecognizer.self || ges.classForCoder === UITapGestureRecognizer.self {
                if let cell = self.model.cell {
                    cell.isShake = false
                }
            }
        }
        
        func change(ges: UIGestureRecognizer) {
            let point = ges.location(in: collectionView)
            model.imgv?.frame.origin = point
            
            for cell in (collectionView?.visibleCells())! {
                let cellFrame = cell.frame
                if cell != model.cell && cellFrame.contains(point) {
                    let desIndex = collectionView?.indexPath(for: cell)!
                    collectionView?.moveItem(at: model.indexPath!, to: desIndex!)
                    model.indexPath = desIndex
                }
            }
        }
        
        func end(ges: UIGestureRecognizer) -> Void {
            model.cell?.isHidden = false
            model.imgv?.removeFromSuperview()
        }
        
        switch ges.state {
            
        case .began:
            began(ges: ges)
            
        case .ended:
            end(ges: ges)
            
        case .changed:
            change(ges: ges)
            
        default:
            break
        }
        

    }
}

extension DragFlowLayout {
    
    @objc(gestureRecognizer:shouldReceiveTouch:) func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let cell = self.model.cell {
            if cell.isShake {
                let point = gestureRecognizer.location(in: collectionView)
                if cell.frame.contains(point) {
                    return true
                }
            }
        }
        return false
    }
    
}

extension DragFlowLayout {
    
    override func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutablePointer<Void>?) {

        guard let _ = model.cell else {
            return
        }
        model.cell?.isShake = false
    }
}
