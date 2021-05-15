//
//  OrderViewModel.swift
//  CoffeeOrder-MVVM
//
//  Created by Dayton on 14/05/21.
//

import Foundation

//MARK: - Parent ViewModel

struct OrderListViewModel {
    var orderViewModel: [OrderViewModel]
    
    init() {
        self.orderViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    
    func orderViewModel(at index:Int) -> OrderViewModel{
        return self.orderViewModel[index]
    }
}

//MARK: - Child ViewModel
struct OrderViewModel {
    let order:Order
}

extension OrderViewModel {
    var name:String {
        return self.order.name
    }
    
    var email:String {
        return self.order.email
    }
    
    var type:String {
        return self.order.type.rawValue.capitalized
    }
    
    var size:String {
        return self.order.size.rawValue.capitalized
    }
}
