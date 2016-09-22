//
//  Event.swift
//  CleengTestProject
//
//  Created by Cleeng on 28/06/16.
//  Copyright © 2016 Cleeng. All rights reserved.
//

import UIKit

class Event
{
    var Title:String!
    var Description:String!
    var PosterImage:String!
    var EventDate:String!
    var EventOfferID:String!
    var EpocTime:Double!
    
    init(Title:String, Description:String, PosterImage:String, EventDate:String, EventOfferID:String, EpocTime:Double)
    {
        self.Title = Title
        self.Description = Description
        self.PosterImage = PosterImage
        self.EventDate = EventDate
        self.EventOfferID = EventOfferID
        self.EpocTime = EpocTime
    }
    
}
