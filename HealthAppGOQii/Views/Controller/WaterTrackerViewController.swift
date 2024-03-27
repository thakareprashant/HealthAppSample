//
//  WaterTrackerViewController.swift
//  HealthAppGOQii
//
//  Created by Apple on 27/03/24.
//

import UIKit
import CoreData

class WaterTrackerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel:WaterIntakeViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        viewModel?.waterEntries.bind { [weak self] _ in
            self?.tableView.reloadData()
            
        }
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    func registerCells(){
        tableView.register(cell: WaterTrackerTableViewCell.self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
   

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapUpdate(_ sender:UIButton){
        updateAction(tag: sender.tag)
    }
    @objc func didTapDelete(_ sender:UIButton){
        let tag = sender.tag // Get the sender's tag value
        deleteAction(senderTag: tag)
       
        
    }
    func updateAction(tag:Int) {
           // Create alert controller
           let alertController = UIAlertController(title: "Update Water Glasses", message: "", preferredStyle: .alert)
           
          
           alertController.addTextField { textField in
               textField.keyboardType = .numberPad
               textField.placeholder = "New value"
               textField.text = "\(self.viewModel?.waterEntries.value[tag].litre ?? 0)"
           }
           
           
           let updateAction = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
              
               if let newValue = alertController.textFields?.first?.text {
                   if Int(newValue) ?? 0 <= 0{
                       self?.view.makeToast("Please add value  greater than 0")
                   }
                   else{
                       self?.updateItem(with: newValue, tag: tag)
                   }
                  
                  
               }
           }
           alertController.addAction(updateAction)
           
           
           let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
           alertController.addAction(cancelAction)
           
           // Present the alert
           present(alertController, animated: true, completion: nil)
       }
    
    func updateItem(with newValue: String,tag:Int) {
        // Perform update logic here with new value
        guard let model = self.viewModel?.waterEntries.value[tag] else { return  }
        self.viewModel?.updateDatamodel(value: Int16(newValue) ?? 0, model: model)
        
        self.view.makeToast("Data updated successfully")
    }
    

    func deleteAction(senderTag: Int) {
            // Create alert controller
            let alertController = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
            
            // Add delete action
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                // Perform deletion action here with sender's tag
                self?.deleteItem(tag: senderTag)
            }
            alertController.addAction(deleteAction)
            
            // Add cancel action
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            // Present the alert
            present(alertController, animated: true, completion: nil)
        }
    func deleteItem(tag: Int) {
         
        guard let model = self.viewModel?.waterEntries.value[tag] else { return  }
        self.viewModel?.deleteData(model: model)
        
       }
        
    
}

extension WaterTrackerViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.waterEntries.value.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: WaterTrackerTableViewCell.self, for: indexPath)
        let data = self.viewModel?.waterEntries.value[indexPath.row]
        
        cell.currrentDateLbl.text = "\(self.viewModel?.getCurrentDateString(date: data?.time ?? Date() ) ?? "")"
        let str = self.viewModel?.getTimeString(from: data?.time ?? Date())
        cell.setupUI()
        cell.timeLbl.text = str
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(didTapUpdate), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
        cell.glassesLbl.text = "\(data?.litre ?? 0)"
        cell.selectionStyle = .none
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    
    
}
