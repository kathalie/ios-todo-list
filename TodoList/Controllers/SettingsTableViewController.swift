//
//  SettingsViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 16.10.2024.
//

import UIKit

protocol SettingsTableViewControllerDelegate {
    func update()
}

class SettingsTableViewController: UITableViewController {

    var delegate: SettingsTableViewControllerDelegate?
    
    @IBOutlet weak var dbPicker: UIPickerView!
    
    @IBOutlet weak var allowLocalNotificationsSwitch: UISwitch!
    
//    @IBAction func allowLocalNotificationsChanged(_ sender: UISwitch) {
//        Task {
//            if sender.isOn {
//                await SettingsProvider.allowLocalNotifications()
//            } else {
//                await SettingsProvider.denyLocalNotifications()
//            }
//        }
//        
//        delegate?.update()
//    }
    
    private func setupDbPicker() {
        let dbManagerRaw = SettingsProvider.currentDbManagerRaw
        let dbManagerCase = DBManagers(rawValue: dbManagerRaw)!
        let row = DBManagers.allCases.firstIndex(of: dbManagerCase) ?? 0
        
        dbPicker.selectRow(row, inComponent: 0, animated: false)
    }
    
//    private func setupLocalNotificationsSwitch() {
//        Task { [weak self] in
//            let allowed = SettingsProvider.localNotificationsAllowed
//            
//            DispatchQueue.main.async {[weak self] in
//                self?.allowLocalNotificationsSwitch.setOn(allowed, animated: false)
//            }
//        }
//    }
    
    override func viewDidLoad() {
        setupDbPicker()
//        setupLocalNotificationsSwitch()
    }
}

extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        DBManagers.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newDbManager = DBManagers.allCases[row]
        
        SettingsProvider.updateDbManager(to: newDbManager)
        
        delegate?.update()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        DBManagers.allCases[row].rawValue
    }
}
