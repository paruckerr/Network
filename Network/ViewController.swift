//
//  ViewController.swift
//  Network
//
//  Created by Eduardo Parucker on 27/10/14.
//  Copyright (c) 2014 Eduardo Parucker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiKey = "aabf85d2d2cf25a6ab284191078c01d4"
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var precipitationLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseUrl = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        let forecastURL = NSURL(string: "37.8267,-122.423", relativeToURL: baseUrl)
        println(forecastURL)
        let sharedSession = NSURLSession.sharedSession()
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(
            forecastURL!,
            completionHandler: {( location: NSURL!, response: NSURLResponse!, error: NSError!) -> Void in
                
                if (error == nil) {
                    
                    let dataObject = NSData(contentsOfURL: location)
                    
                    let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataObject!, options: nil, error: nil) as NSDictionary
                    
                    let currentWeather = Current(weatherDictionary: weatherDictionary)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.temperatureLabel.text = "\(currentWeather.temperature)"
                        self.iconView.image = currentWeather.icon!
                        self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                        self.humidityLabel.text = "\(currentWeather.humidity)"
                        self.precipitationLabel.text = "\(currentWeather.precipProbability)"
                        self.summaryLabel.text = "\(currentWeather.summary)"
                    })
                }
            })
        
        downloadTask.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

