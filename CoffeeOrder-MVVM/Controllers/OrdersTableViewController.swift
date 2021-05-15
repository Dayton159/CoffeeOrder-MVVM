//
//  OrdersTableViewController.swift
//  CoffeeOrder-MVVM
//
//  Created by Dayton on 14/05/21.
//

import Foundation
import UIKit

class OrdersTableViewController:UITableViewController {
    
     var orderListViewModel = OrderListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateOrders()
    }
    
    private func populateOrders() {
       
        // using weak self or unowned because of self reference usage as result of web service
        WebService.load(resource: Order.all) { [weak self] result in
            // result datatype is Result<[Order], NetworkError>
            
            switch result {
            // catching [Orders] that came along with .success in a constant
            case .success(let orders):
                self?.orderListViewModel.orderViewModel = orders.map { OrderViewModel(order: $0)}
                self?.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController,
              let addOrderVC = navController.viewControllers.first as? AddCoffeeOrderViewController else { return }
        
        addOrderVC.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.orderViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        
        cell.textLabel?.text = viewModel.type
        cell.detailTextLabel?.text = viewModel.size
        
        return cell
    }
}

extension OrdersTableViewController: AddCoffeeOrderDelegate {
    func addCoffeeOrderViewControllerDidSave(order: Order, controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        let orderViewModel = OrderViewModel(order: order)
        self.orderListViewModel.orderViewModel.append(orderViewModel)
        self.tableView.insertRows(at: [IndexPath.init(row: self.orderListViewModel.orderViewModel.count - 1, section: 0)], with: .automatic)
    }
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
