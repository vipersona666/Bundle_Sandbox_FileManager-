//
//  SettingsViewController.swift
//  File_Manager
//
//  Created by Андрей Байдаченко on 13.02.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var sort = true
    
    var imageVCDelegate: ImageViewController?
    
    @IBOutlet weak var sortSwitch: UISwitch!
    
    
    @IBOutlet weak var sortButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    
    @IBAction func switchAction(_ sender: Any) {
        if sortSwitch.isOn{
            UserDefaults.standard.set(true, forKey: "sortContent")
            //print("sort")
        } else {
            //print("notSort")
            UserDefaults.standard.set(false, forKey: "sortContent")
        }
        imageVCDelegate?.tableView.reloadData()
    }
    
    @IBAction func sortButtonAction(_ sender: Any) {
        if sort {
            //print("notSort")
                   UserDefaults.standard.set(false, forKey: "sortContent")
            sort = false
        } else {
            //print("sort")
                   UserDefaults.standard.set(true, forKey: "sortContent")
            sort = true
        }
    
        imageVCDelegate?.tableView.reloadData()
    }
    @IBAction func resetPasswordAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "goToChangePass")
        vc.modalPresentationStyle = .automatic
        self.present(vc, animated: true, completion: nil)
    }
  
}
