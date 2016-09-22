//
//  EventCellView.swift
//  CleengTestProject
//
//  Created by Cleeng on 28/06/16.
//  Copyright © 2016 Cleeng. All rights reserved.
//

import UIKit

class EventCellView: UICollectionViewCell {
    
    var event:Event!{
        didSet{
            UpdateUI()
        }
    }
    
    @IBOutlet weak var EventImageView: UIImageView!
    @IBOutlet weak var EventTitle: UILabel!
    
    
    private func UpdateUI(){
        print(event.Title)
        print(event.PosterImage)
            
        EventTitle?.text! = event.Title
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let imageString = self.event.PosterImage
            let imageUrl = NSURL(string:imageString)
            let imageData = NSData(contentsOfURL: imageUrl!)
            if(imageData != nil){
                self.EventImageView.image = UIImage(data:imageData!)
            }
        })
        
            
    }
}
