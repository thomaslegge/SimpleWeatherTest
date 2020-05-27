//
//  WeatherTableViewController.swift
//  SimpleWeatherTest
//
//  Created by Thomas Legge on 27/05/20.
//  Copyright © 2020 Thomas Legge. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var weatherData:Welcome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        updateWeatherForLocation(location: "Auckland")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func Refresh(_ sender: UIRefreshControl) {
        if searchBar.text == nil || searchBar.text == "" {
            updateWeatherForLocation(location: "Auckland")
        } else {
            updateWeatherForLocation(location: searchBar.text!)
        }
        
        sender.endRefreshing()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let locationString = searchBar.text, !locationString.isEmpty {
            updateWeatherForLocation(location: locationString)
            
        }
    }
    
    func updateWeatherForLocation(location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    WeatherResquest.forecast(location: location.coordinate) { result in
                        switch result {
                        case .failure(let error):
                            print("NewsViewModel Error: ", error)
                        case .success(let weather):
                            self.weatherData = weather
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                print("Reloaded Data")
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return weatherData?.list?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = weatherData?.list?[section].dtTxt ?? ""
        return date
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let weatherObject = weatherData?.list?[indexPath.section]
        let temp = (weatherObject?.main?.temp ?? 0) - 273.15 //Kelvin to Celsius
        let desc = weatherObject?.weather?[0].weatherDescription ?? ""
        
        var weatherIconName = ""
        
        if self.weatherData != nil {
            switch weatherObject!.weather![0].id! {
            case 200...299:
                //print("Thunderstorms")
//                self.weatherBringJacket = "Avoid the lightning"
                weatherIconName = "cloud.bolt.rain.fill"
            case 300...399:
                //print("Drizzle")
//                self.weatherBringJacket = "Bring a light jacket"
                weatherIconName = "cloud.drizzle.fill"
            case 500...599:
                //print("Rain")
//                self.weatherBringJacket = "Bring a raincoat"
                weatherIconName = "cloud.rain.fill"
            case 600...699:
                //print("Snow")
//                self.weatherBringJacket = "Bring a snow jacket!"
                weatherIconName = "cloud.snow.fill"
            case 700...799:
                //print("Atmosphere")
//                self.weatherBringJacket = "Exercise Caution"
                weatherIconName = "tornado"
            case 800:
                //print("Clear")
//                self.weatherBringJacket = "Enjoy the weather!"
                weatherIconName = "sun.max.fill"
            case 801...809:
                //print("Clouds")
//                self.weatherBringJacket = "Bring a light jacket"
                weatherIconName = "cloud.fill"
            default:
                //print("Default")
//                self.weatherBringJacket = "Enjoy the weather!"
                weatherIconName = "sun.max.fill"
            }
    }
        cell.textLabel?.text = desc
        cell.detailTextLabel?.text = String(format: "%.2f", temp) + "°C"
        cell.imageView?.image = UIImage(systemName: weatherIconName)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
