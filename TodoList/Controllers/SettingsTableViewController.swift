//
//  SettingsViewController.swift
//  TodoList
//
//  Created by Kathryn Verkhogliad on 16.10.2024.
//

import UIKit

enum UserDefaultKeys: String {
    case dbManager, localNotificationsAllowed
}

enum DBManagers: String, CaseIterable {
    case coreData = "CoreData"
    case realm = "Realm"
}

protocol SettingsTableViewControllerDelegate {
    func update()
}

class SettingsTableViewController: UITableViewController {

    var delegate: SettingsTableViewControllerDelegate?
    
    @IBOutlet weak var dbPicker: UIPickerView!
    
    @IBOutlet weak var allowLocalNotificationsSwitch: UISwitch!
    
    @IBAction func allowLocalNotificationsChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: UserDefaultKeys.localNotificationsAllowed.rawValue)
                
        delegate?.update()
    }
    
    override func viewDidLoad() {
        setupDbPicker()
        setupLocalNotificationsSwitch()
    }
    
    private func setupDbPicker() {
        let dbManagerRaw = UserDefaults.standard.string(forKey: UserDefaultKeys.dbManager.rawValue) ?? DBManagers.coreData.rawValue
        let dbManagerCase = DBManagers(rawValue: dbManagerRaw) ?? DBManagers.coreData
        let row = DBManagers.allCases.firstIndex(of: dbManagerCase) ?? 0
        
        dbPicker.selectRow(row, inComponent: 0, animated: false)
    }
    
    private func setupLocalNotificationsSwitch() {
        let allowed = UserDefaults.standard.bool(forKey: UserDefaultKeys.localNotificationsAllowed.rawValue)
        
        allowLocalNotificationsSwitch.setOn(allowed, animated: false)
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
        
        UserDefaults.standard.set(newDbManager.rawValue, forKey: UserDefaultKeys.dbManager.rawValue)
        
        delegate?.update()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        DBManagers.allCases[row].rawValue
    }
}
