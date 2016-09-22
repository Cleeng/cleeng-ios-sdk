//
//  ViewController.swift
//  CleengTestProject
//
//  Created by Cleeng on 28/06/16.
//  Copyright © 2016 Cleeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var EventCollectionView: UICollectionView!
    
    
    //MARK:- Private area
    var eventArray:[Event] = []
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getEvents()
    }

    func getEvents(){
        // 1
        
        let url = NSBundle.mainBundle().URLForResource("Data", withExtension: "json")
        let data = NSData(contentsOfURL: url!)
        
            do{
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                //create event array for future use
                if let eventData:NSArray = jsonResult["events"] as? NSArray{
                    for event in eventData{
                        
                        let epoc = event["startTime"] as? Double
                        //                        print(event)
                        let offerID = (event["offerId"] as? String)!
                        let title = (event["title"] as? String)!
                        let description = self.getLongDate(epoc!)
                        let imageUrl = (event["posterHD"] as? String)!
                        
                        self.eventArray.append(Event(Title:title , Description:description , PosterImage: imageUrl, EventDate: description, EventOfferID: offerID, EpocTime: epoc!))
                    }
                }
                //}
                
            } catch let error as NSError{
                print("json error: \(error)")
            }
        
            self.EventCollectionView.reloadData()
        
    }
    
    func getLongDate(epoc: Double)-> String{
        let date = NSDate(timeIntervalSince1970: epoc)
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "E, d MMM yyyy H:mm a"
        
        let dateString = dayTimePeriodFormatter.stringFromDate(date)
        //        print( " _ts value is \(epoc)")
        //        print( " _ts value is \(dateString)")
        
        return dateString
    }
    
    
    //MARK:- CollectionView Methods
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("EventCell", forIndexPath: indexPath) as! EventCellView
        
        cell.event = self.eventArray[indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegueWithIdentifier("EventDetal", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "EventDetal")
        {
            let event = self.eventArray[self.selectedIndex]
            print(event)
            print(event.Title)
            print(event.Description)
            print(event.PosterImage)
            
            
            let vc = segue.destinationViewController as! EventDetailViewController
            vc.eventImage = event.PosterImage
            vc.eventTitle = event.Title
            vc.eventDate = event.EventDate
            vc.eventOfferID = event.EventOfferID
            vc.epocTime = event.EpocTime
        }
        
    }
    

}

