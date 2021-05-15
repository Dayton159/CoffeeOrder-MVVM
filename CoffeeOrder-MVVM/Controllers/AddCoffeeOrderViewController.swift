//
//  AddOrderViewController.swift
//  CoffeeOrder-MVVM
//
//  Created by Dayton on 14/05/21.
//

import Foundation
import UIKit

protocol AddCoffeeOrderDelegate: AnyObject {
    func addCoffeeOrderViewControllerDidSave(order:Order,controller: UIViewController)
    func addCoffeeOrderViewControllerDidClose(controller:UIViewController)
}

class AddCoffeeOrderViewController : UIViewController {
    
    weak var delegate: AddCoffeeOrderDelegate?
    
    private var viewModel = AddCoffeeOrderViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var emailTextField:UITextField!
    
    private var coffeeSizesSegmentedControl: UISegmentedControl!
    
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Delegates already being set on storyboard
        
        setupUI()
    }
    
    //MARK: - Helpers
    
    private func setupUI() {
        coffeeSizesSegmentedControl = UISegmentedControl(items: self.viewModel.sizes)
        coffeeSizesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.coffeeSizesSegmentedControl)
        
        self.coffeeSizesSegmentedControl.topAnchor.constraint(equalTo: self.tableView.bottomAnchor, constant: 20).isActive = true
        self.coffeeSizesSegmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    //MARK: - Selectors
    
    @IBAction func close() {
        delegate?.addCoffeeOrderViewControllerDidClose(controller: self)
    }
    
    @IBAction func save() {
        let name = self.nameTextField.text
        let email = self.emailTextField.text
        
        let selectedSize = self.coffeeSizesSegmentedControl.titleForSegment(at: self.coffeeSizesSegmentedControl.selectedSegmentIndex)
        
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            return
        }
        self.viewModel.name = name
        self.viewModel.email = email
        self.viewModel.selectedSize = selectedSize
        self.viewModel.selectedType = self.viewModel.types[indexPath.row]
        
        
        WebService.load(resource: Order.create(viewModel: self.viewModel)) { result in
            switch result {
                case .success(let order):
                    guard let order = order else { return }
                    DispatchQueue.main.async {
                        self.delegate?.addCoffeeOrderViewControllerDidSave(order: order, controller: self)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}


extension AddCoffeeOrderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.types.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoffeeTypeTableViewCell", for: indexPath)
        
        cell.textLabel?.text = self.viewModel.types[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
