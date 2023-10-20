//
//  Items.swift
//  WorldMart2
//
//  Created by Raghav Aggarwal on 4/16/21.
//

import Foundation
import Firebase
import FirebaseDatabase
class Items{
    var itemName:String
    var itemPrice:String
    var itemDescription:String
    var itemSellerContactInformation:String
    var itemShippingDetails:String
    var itemWarehouseLocation:String
    var itemImage:String
    
    func toJson() -> [String:Any]
    {
        return [
            "name":itemName,
            "price":itemPrice,
            "description":itemDescription,
            "sellerContactInformation":itemSellerContactInformation,
            "shippingDetails":itemShippingDetails,
            "warehouseLocation": itemWarehouseLocation,
            "image":itemImage
        ]
    }
    
    init(snapshot:DataSnapshot)
    {
        let itemDictionary = snapshot.value as! [String:Any]
        self.itemName = itemDictionary["name"] as! String
        self.itemPrice = itemDictionary["price"] as! String
        self.itemDescription = itemDictionary["description"] as! String
        self.itemSellerContactInformation = itemDictionary["sellerContactInformation"] as! String
        self.itemShippingDetails = itemDictionary["shippingDetails"] as! String
        self.itemWarehouseLocation = itemDictionary["warehouseLocation"] as! String
        self.itemImage = itemDictionary["itemImageUrl"] as! String
    }
    
    init(iname: String, ip:String, id: String, isi:String, isd:String, iwl:String, ci: String)
    {
        self.itemName = iname
        self.itemPrice = ip
        self.itemDescription = id
        self.itemSellerContactInformation = isi
        self.itemShippingDetails = isd
        self.itemWarehouseLocation = iwl
        self.itemImage = ci
    }
}
