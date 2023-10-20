//
//  DetailViewController.swift
//  WorldMart2
//
//  Created by Raghav Aggarwal on 4/16/21.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
class DetailViewController: UIViewController {

    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var shipping: UILabel!
    @IBOutlet weak var location: UILabel!
    
    var thisName:String?
    var thisPrice:String?
    var thisDescription:String?
    var thisSellerContactInformation:String?
    var thisShippingDetails:String?
    var thisWarehouseLocation:String?
    var thisImage:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.name.text = thisName!
        let thisRef = Database.database().reference()
        thisRef.observeSingleEvent(of: .value) { snapshot in
            for case let rest as DataSnapshot in snapshot.children {
               guard let restDict = rest.value as? [String: Any] else { continue }
                let username = restDict["name"] as? String
                if username == self.thisName
                {
                    self.thisPrice = restDict["price"] as? String
                    print(self.thisPrice!)
                    self.thisDescription = restDict["description"] as? String
                    self.thisShippingDetails = restDict["shippingDetails"] as? String
                    self.thisWarehouseLocation =  restDict["warehouseLocation"] as? String
                    self.thisSellerContactInformation =  restDict["sellerContactInformation"] as? String
                    self.thisImage = restDict["itemImageUrl"] as! String
                    break
                }
            }
            var storage:Storage = Storage.storage()
            let storageRef = storage.reference(forURL: self.thisImage!)
            storageRef.downloadURL(completion: { (url, error) in
                let data:Data?
                do
                {
                    data = try Data(contentsOf: url!)
                }
                catch _
                {
                    data = nil
                }
                let image = UIImage(data: data!)
                self.image.image = image
                self.desc.text = self.thisDescription!
                self.price.text = self.thisPrice!
                self.contact.text = self.thisSellerContactInformation!
                self.shipping.text = self.thisShippingDetails!
                self.location.text = self.thisWarehouseLocation
                let geoCoder = CLGeocoder();
                let addressString = self.thisWarehouseLocation
                //let addressString = address.text!
                CLGeocoder().geocodeAddressString(addressString!, completionHandler:
                    {(placemarks, error) in
                        
                        if error != nil {
                            print("Geocode failed: \(error!.localizedDescription)")
                        } else if placemarks!.count > 0 {
                            let placemark = placemarks![0]
                            let location = placemark.location
                            let coords = location!.coordinate
                            //print(location)
                            
//                            self.longi.text = String(location!.coordinate.longitude)
//
//                            self.lati.text = String(location!.coordinate.latitude)
                            
                            let span = MKCoordinateSpan.init(latitudeDelta: 0.05, longitudeDelta: 0.05)
                            let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                            self.map.setRegion(region, animated: true)
                            let ani = MKPointAnnotation()
                            ani.coordinate = placemark.location!.coordinate
                            ani.title = placemark.locality
                            ani.subtitle = placemark.subLocality
                            
                            self.map.addAnnotation(ani)
                            
                           
                        }
                })
            })
        }
        
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
