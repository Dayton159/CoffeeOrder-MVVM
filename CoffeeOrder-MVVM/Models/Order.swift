//
//  Order.swift
//  CoffeeOrder-MVVM
//
//  Created by Dayton on 14/05/21.
//

import Foundation

// enum case must be same to the value of API for it being successfully decoded and mapped into the enum type
enum CoffeeType:String, Codable, CaseIterable {
    case cappuccino
    case latte
    case espresso
    case americano
}

enum CoffeeSize: String, Codable, CaseIterable {
    case small
    case medium
    case large
}

struct Order:Codable {
    let name, email : String
    let type: CoffeeType
    let size: CoffeeSize
}

extension Order {
    
    // Creating a resource and define what kind of result you're expecting
    static var all: Resource<[Order]> = {
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else { fatalError("URL is incorrect") }
        
        return Resource<[Order]>(url: url)
    }()
    
    static func create(viewModel: AddCoffeeOrderViewModel) -> Resource<Order?> {
        
        let order = Order(viewModel)
        guard let url = URL(string: "https://guarded-retreat-82533.herokuapp.com/orders") else { fatalError("URL is incorrect") }
        
        guard let data = try? JSONEncoder().encode(order) else { fatalError("Error Encoding Order")}
        
        var resource = Resource<Order?>(url: url)
        resource.httpMethod = .post
        resource.body = data
        
        return resource
    }
}


extension Order {
    // Optional Initializer for Post HTTP Request
    init?(_ viewModel: AddCoffeeOrderViewModel) {
       
        guard let name = viewModel.name,
              let email = viewModel.email,
              let typeString = viewModel.selectedType,
              let sizeString = viewModel.selectedSize,
              let type = CoffeeType(rawValue: typeString.lowercased()),
              let size = CoffeeSize(rawValue: sizeString.lowercased()) else { return nil }
        
        self.name = name
        self.email = email
        self.type = type
        self.size = size
            
    }
}

