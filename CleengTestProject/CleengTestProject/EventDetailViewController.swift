//
//  EventDetailViewController.swift
//  CleengTestProject
//
//  Created by Cleeng on 28/06/16.
//  Copyright © 2016 Cleeng. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class EventDetailViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var EventImageView: UIImageView!
    @IBOutlet weak var EventTitleLabel: UILabel!
    @IBOutlet weak var EventDateLabel: UILabel!
    @IBOutlet weak var ReceiptNumField: UITextField!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    var timer: NSTimer!
    
    var eventImage:String!
    var eventTitle:String!
    var eventDate:String!
    var eventOfferID:String!
    var deviceID:String = "24356463h4kj63"
    var epocTime:Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.timerLabel.hidden = true
        self.EventTitleLabel.text = eventTitle
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let imageString = self.eventImage
            let imageUrl = NSURL(string:imageString)
            let imageData = NSData(contentsOfURL: imageUrl!)
            if(imageData != nil){
                self.EventImageView.image = UIImage(data:imageData!)
            }
        })
        self.EventDateLabel.text = eventDate
        
    }
    
    @IBAction func LinkButton(sender: AnyObject) {
        theAsyncManager.getCustomerTokenByTransactionID(ReceiptNumField.text!){
            (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
               do{
                    let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                        print(responseJSON!)
                        if responseJSON!["result"] != nil
                        {
                            let error = responseJSON!["error"]
                            if((error as? NSNull) == nil){
                                let message = error!["message"] as? String
                                print(message)
                                dispatch_async(dispatch_get_main_queue(), {
                                    let alertController = UIAlertController(title: "Alert", message:
                                        message, preferredStyle: UIAlertControllerStyle.Alert)
                                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                     self.presentViewController(alertController, animated: true, completion: nil)
                                })
                                
                               
                            }
                            else
                            {
                                let result = responseJSON!["result"]
                                let token = result!["token"] as! String
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.checkAccessGranted(token)
                                })
                                
                            }
                        }
                    
                }
                catch let error as NSError{
                    print("json error: \(error)")
                }
        }
        
    }
    
    
    func checkAccessGranted(token:String){
        theAsyncManager.getAccessGranted(token, eventOfferID: eventOfferID, deviceID: deviceID){
            (data, response, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            do{
                let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                print(responseJSON!)
                if responseJSON!["result"] != nil
                {
                    let error = responseJSON!["error"]
                    if((error as? NSNull) == nil){
                        let message = error!["message"] as? String
                        print(message)
                        dispatch_async(dispatch_get_main_queue(), {
                            let alertController = UIAlertController(title: "Alert", message:
                                message, preferredStyle: UIAlertControllerStyle.Alert)
                            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        })
                    }
                    else
                    {
                        let result = responseJSON!["result"]
                        let accessGranted = result!["accessGranted"] as! Int
                        if(accessGranted == 0){
                            dispatch_async(dispatch_get_main_queue(), {
                                print("Access not granted")
                            })
                        }
                        if(accessGranted == 1){
                            dispatch_async(dispatch_get_main_queue(), {
                                self.showTimer()
                            })
                        }
                        
                    }
                }
                
            }
            catch let error as NSError{
                print("json error: \(error)")
            }
        }
    }

    
    
    
    func timerResult()
    {
        let theDate = NSDate()
        let currentEpoc = theDate.timeIntervalSince1970
        let totalSeconds = self.epocTime - currentEpoc
        if(totalSeconds > 0)
        {
            let seconds = totalSeconds % 60;
            let minutes = (totalSeconds / 60) % 60;
            let hours = totalSeconds / 3600;
            let days = totalSeconds / 3600*24;
            
            timerLabel.text = "Event will start in: \(days) Days \(hours) Hours \(minutes) Mins \(seconds) Secs"
        }
        else{
            self.playVideo()
        }
    }
    
    func showTimer()
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(EventDetailViewController.timerResult), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func playVideo()
    {
        let videoURL = NSURL(string: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")
        let player = AVPlayer(URL: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.Default)
        {
            //implemnt yor Ibaction method here
            self.view.endEditing(true)
        }
        return true
    }
 
    
    
    
    
    
//    
//    
//    func getGoogleData(){
//        getRequest(){
//            (data, response, error) -> Void in
//            do{
//                let responseJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
//                print(responseJSON!)
//            }
//            catch let error as NSError{
//                print("json error: \(error)")
//            }
//        }
//    }
//    
//    func getRequest( completion : (Data:NSData?, Response:NSURLResponse?, Error:NSError?) -> Void)
//    {
//        let postEndpoint: String = "http://52.37.45.20/mock/response.json"
//        let url = NSURL(string: postEndpoint)
//        let urlRequest = NSURLRequest(URL: url!)
//        
//        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
//        let session = NSURLSession(configuration: config)
//        
//        let task = session.dataTaskWithRequest(urlRequest){
//            data, response, error in
//            completion(Data: data, Response: response, Error: error)
//        }
//        
//        task.resume()
//    }
//    
    
    
    
    
    
    
    
}
