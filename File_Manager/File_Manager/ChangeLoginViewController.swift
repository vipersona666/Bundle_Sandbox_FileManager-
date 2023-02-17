//
//  ChangeLoginViewController.swift
//  File_Manager
//
//  Created by Андрей Байдаченко on 17.02.2023.
//

import UIKit
import SwiftKeychainWrapper

class ChangeLoginViewController: UIViewController {
    
    var passwordCount = 0
    
    var repeatPass: Bool = true{
        willSet{
            if newValue{
                passTextField.text = ""
                passButton.setTitle("Повторите пароль", for: .normal)
            } else {
                passTextField.text = ""
                passButton.setTitle("Ввести пароль", for: .normal)
                let alarm = UIAlertController(title: "Пароли не совпадают, введите заново", message: "", preferredStyle: .alert)
                let alarmAction = UIAlertAction(title: "Закрыть", style: .default)
                alarm.addAction(alarmAction)
                self.present(alarm, animated: true)
            }
        }
    }
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var passButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    
    @IBAction func passButtonAction(_ sender: UIButton) {
        
        if passTextField.text!.count >= 4{
            passwordCount += 1
            if passwordCount == 2{
                if passTextField.text == KeychainWrapper.standard.string(forKey: "pass") {
                    print("Пароль изменен в keychain")
                    KeychainWrapper.standard.set(passTextField.text!, forKey: "pass")
                    passTextField.text = ""
                    passwordCount = 0
                    passTextField.text = ""
                    navigationController?.popViewController(animated: true)
                    dismiss(animated: true, completion: nil)
                } else {
                    repeatPass = false
                    passwordCount = 0
                    print("Пароли не совпадают")
                }
            }else {
                if passTextField.text == KeychainWrapper.standard.string(forKey: "pass") {
                    let alarm = UIAlertController(title: "Старый пароль совпадает с новым.", message: "Введите заново", preferredStyle: .alert)
                    let alarmAction = UIAlertAction(title: "Закрыть", style: .default)
                    alarm.addAction(alarmAction)
                    self.present(alarm, animated: true)
                    passTextField.text = ""
                    passwordCount = 0
                } else {
                    KeychainWrapper.standard.set(passTextField.text!, forKey: "pass")
                    passTextField.text = ""
                    repeatPass = true
                    print("Повторите пароль")
                }
                
            }
            
        } else if passTextField.text!.count == 0{
            let alarm = UIAlertController(title: "Пароль не должен быть пустым", message: "", preferredStyle: .alert)
            let alarmAction = UIAlertAction(title: "Закрыть", style: .default)
            alarm.addAction(alarmAction)
            self.present(alarm, animated: true)
        } else {
            let alarm = UIAlertController(title: "Пароль должен быть не менее 4х символов", message: "", preferredStyle: .alert)
            let alarmAction = UIAlertAction(title: "Закрыть", style: .default)
            alarm.addAction(alarmAction)
            self.present(alarm, animated: true)
            passTextField.text = ""
        }
        
        
    }
    
    
}
