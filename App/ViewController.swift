//
//  ViewController.swift
//  WorldMart2
//
//  Created by Raghav Aggarwal on 4/16/21.
//

//
//  ViewController.swift
//  WorldMart
//
//  Created by Raghav Aggarwal on 4/14/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var itemList:[Items] = []
    @IBOutlet weak var itemTable: UITableView!
    var ref: DatabaseReference?
    
    var newName:String?
    var newDescription:String?
    var newPrice:String?
    var newSellerContactInformation:String?
    var newShippingDetails:String?
    var newWarehouseLocation:String?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference() //Load the Firebase database
        
        //Load firebase databse to table view
        loading()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(itemList.count)
            return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        cell.itemName.text = itemList[indexPath.row].itemName
        cell.itemPrice.text = itemList[indexPath.row].itemPrice
        cell.itemShipping.text = itemList[indexPath.row].itemShippingDetails
    
        var storage:Storage = Storage.storage()
         let pu:String? = itemList[indexPath.row].itemImage
        //print(pu!)
        let storageRef = storage.reference(forURL: pu!)
        //print(storageRef)
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
            let image = UIImage(data: data as! Data)
            cell.itemImage.image = image
        })
        return cell
    }
    
    func loading()
    {
        ref!.observeSingleEvent(of: .value) { snapshot in
           // If the database is empty, add 6 default cities
            if snapshot.childrenCount == 0
            {
                self.defaultSixCities()
            }
            else
            {
                //Load data saved in databse
                for case let rest as DataSnapshot in snapshot.children {
                guard let restDict = rest.value as? [String: Any] else { continue }
                    let itemname = restDict["name"] as? String
                    print(itemname!)
                    let itemprice = restDict["price"] as! String
                    let itemdescription = restDict["description"] as! String
                    let itemsellercontactinformation = restDict["sellerContactInformation"] as! String
                    let itemshippingdetails = restDict["shippingDetails"] as! String
                    let itemwarehouselocation = restDict["warehouseLocation"] as! String

                    let itemimage = restDict["itemImageUrl"] as? String

                    let ci = Items(iname: itemname!, ip:itemprice, id: itemdescription, isi:itemsellercontactinformation, isd:itemshippingdetails, iwl:itemwarehouselocation, ci: itemimage!)
                    self.itemList.append(ci)
                }
                self.itemTable.reloadData()
           }
        }
    }
    
    func defaultSixCities()
    {
        let name = "BasketBall"
        let p = "$45"
        let des = "Official NBA size and weight: Size 7, 29.5 inch"
        let sellerinfo = "789 898 8909"
        let wareloc = "500-610 4th Ave. Grinnell, Iowa"
        let shipping = "USPS Free Shipping"
        let storageRef = Storage.storage().reference().child("download.jpeg")
        storageRef.downloadURL { (url, error) in
            if let err = error{
                print(err)
                return
            }
            let url = url
            let image = url
            let item1 = Items(iname: name, ip:p, id: des, isi:sellerinfo , isd:shipping, iwl:wareloc, ci: image!.absoluteString)
            //(cn: c1Name, cd: c1Des, ci: c1Image!.absoluteString)
            self.itemList.append(item1)
            //self.cityTable.reloadData()
            
            let indexPath = IndexPath (row: self.itemList.count - 1, section: 0)
            self.itemTable.beginUpdates()
            self.itemTable.insertRows(at: [indexPath], with: .automatic)
            self.itemTable.endUpdates()
            
            for i in self.itemList
            {
                print(i.itemName);
            }
            
            let c1 = self.ref?.child("1")
            c1!.child("name").setValue(name)
            c1!.child("price").setValue(p)
            c1!.child("description").setValue(des)
            c1!.child("sellerContactInformation").setValue(sellerinfo)
            c1!.child("shippingDetails").setValue(shipping)
            c1!.child("warehouseLocation").setValue(wareloc)
            c1!.child("itemImageUrl").setValue(url?.absoluteString)
    }
}
    
    
    @IBAction func add(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self

        let alert = UIAlertController(title: "Add an Item", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Enter Name of the Item Here"
        })

        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Enter Price of the Item Here"
        })
        
        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Enter Description of the Item Here"
        })
        
        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Enter Seller Contact Information of the Item Here"
        })
        
        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Enter Shipping Details of the Item Here"
        })
        
        alert.addTextField(configurationHandler: { textField1 in
            textField1.placeholder = "Enter Ware House Location of the Item Here"
        })

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in

            if let name = alert.textFields?[0].text,let price = alert.textFields?[1].text, let desc = alert.textFields?[2].text,let sellerInfo = alert.textFields?[3].text,let shipping = alert.textFields?[4].text, let warehouse = alert.textFields?[5].text{
                self.newName = name
                self.newPrice = price
                self.newDescription = desc
                self.newSellerContactInformation = sellerInfo
                self.newShippingDetails = shipping
                self.newWarehouseLocation = warehouse
                //self.newImage = img
//                let c7 = Items(iname: self.newName!, ip:self.newPrice!, id: self.newDescription!, isi:self.newSellerContactInformation!, isd:self.newShippingDetails!, iwl:self.newWarehouseLocation!, ci: "currentNoPicture")
//                self.itemList.append(c7)
            }

            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerController.SourceType.camera
                picker.cameraCaptureMode = .photo
                picker.modalPresentationStyle = .fullScreen
                self.present(picker,animated: true,completion: nil)
            }
            else
            {
                let alert = UIAlertController(title: "ERROR", message: "No Camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }))

        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in

            if let name = alert.textFields?[0].text,
               let price = alert.textFields?[1].text,
               let desc = alert.textFields?[2].text,
               let sellerInfo = alert.textFields?[3].text,
               let shipping = alert.textFields?[4].text,
               let warehouse = alert.textFields?[5].text
               {
                self.newName = name
                self.newPrice = price
                self.newDescription = desc
                self.newSellerContactInformation = sellerInfo
                self.newShippingDetails = shipping
                self.newWarehouseLocation = warehouse
                //let img = alert.textFields?[6].text
                //self.newImage = img
//                let c7 = Items(iname: self.newName!, ip:self.newPrice!, id: self.newDescription!, isi:self.newSellerContactInformation!, isd:self.newShippingDetails!, iwl:self.newWarehouseLocation!, ci: "currentNoPicture")
//                self.itemList.append(c7)
            }
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            picker.modalPresentationStyle = .popover
            self.present(picker, animated: true, completion: nil)

            }))

        self.present(alert, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker .dismiss(animated: true, completion: nil)
        if let _ = self.itemList.last, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).png") //Load the Firebase storage
            if let uploadData = image.pngData()
            {
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
                    if let error = err {
                        print(error)
                        return
                    }
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        guard let url = url else { return }
                        let newItem = self.ref!.child(String(self.itemList.count+1))
                        newItem.child("name").setValue(self.newName)
                        newItem.child("price").setValue(self.newPrice)
                        newItem.child("description").setValue(self.newDescription)
                        newItem.child("sellerContactInformation").setValue(self.newSellerContactInformation)
                        newItem.child("shippingDetails").setValue(self.newShippingDetails)
                        newItem.child("warehouseLocation").setValue(self.newWarehouseLocation)
                        newItem.child("itemImageUrl").setValue(url.absoluteString)
                        let c7 = Items(iname: self.newName!, ip:self.newPrice!, id: self.newDescription!, isi:self.newSellerContactInformation!, isd:self.newShippingDetails!, iwl:self.newWarehouseLocation!, ci: url.absoluteString)
                        //(cn: self.newCityName!, cd: self.newCityDescription!, ci: url.absoluteString)
                        self.itemList.append(c7)
                        
                        let indexPath = IndexPath (row: self.itemList.count - 1, section: 0)
                        self.itemTable.beginUpdates()
                        self.itemTable.insertRows(at: [indexPath], with: .automatic)
                        self.itemTable.endUpdates()
                    })
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toDetail"){
            let selectedIndex: IndexPath = self.itemTable.indexPath(for: sender as! UITableViewCell)!
            if let viewController: DetailViewController = segue.destination as? DetailViewController {
                viewController.thisName = self.itemList[selectedIndex.row].itemName
            }
        }
    }

}

