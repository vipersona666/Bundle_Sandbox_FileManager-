//
//  LoginViewController.swift
//  File_Manager
//
//  Created by Андрей Байдаченко on 11.02.2023.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {
    
    var keyChain = KeychainWrapper.standard.string(forKey: "pass")
    var passwordCoun = 0
    var signUp: Bool = true{
        willSet{
            if newValue{
                passwordText.text = ""
                passwordButton.setTitle("Создать пароль", for: .normal)
            } else {
                passwordText.text = ""
                passwordButton.setTitle("Ввести пароль", for: .normal)
            }
            
        }
    }
    var repeatPass: Bool = true{
        willSet{
            if newValue{
                passwordText.text = ""
                passwordButton.setTitle("Повторите пароль", for: .normal)
            } else {
                passwordText.text = ""
                passwordButton.setTitle("Ввести пароль", for: .normal)
                let alarm = UIAlertController(title: "Пароли не совпадают, введите все заново", message: "", preferredStyle: .alert)
                let alarmAction = UIAlertAction(title: "Закрыть", style: .default)
                alarm.addAction(alarmAction)
                self.present(alarm, animated: true)
            }
            
        }
    }
    
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var passwordButton: UIButton!
    
    
    func checkLogin(){
        if UserDefaults.standard.bool(forKey: "password"){
            signUp = !signUp
        }else {
            signUp = true
            UserDefaults.standard.set(true, forKey: "password")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLogin()
        print("keyChain:",keyChain)
    }
    
    @IBAction func passwordAction(_ sender: UIButton) {
        //view.endEditing(true)
        if passwordText.text!.count >= 4{
            passwordCoun += 1
            if passwordCoun == 2{
                if passwordText.text == KeychainWrapper.standard.string(forKey: "key") {
                    print("Пароль записан в keychain")
                    KeychainWrapper.standard.set(passwordText.text!, forKey: "pass")
                    passwordCoun = 0
                    signUp = false
//                    let vc = ImageViewController()
//                    performSegue(withIdentifier: "goToTabbar", sender: nil)
//                    vc.modalPresentationStyle = .currentContext
//                    navigationController?.pushViewController(vc, animated: true)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController")
//                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    repeatPass = false
                    passwordCoun = 0
                    print("Пароли не совпадают")
                }
                
            }else {
                KeychainWrapper.standard.set(passwordText.text!, forKey: "key")
                passwordText.text = ""
                repeatPass = true
                print("Повторите пароль")
            }
            
        } else if passwordText.text!.count == 0{
            let alarm = UIAlertController(title: "Пароль не должен быть пустым", message: "", preferredStyle: .alert)
            let alarmAction = UIAlertAction(title: "Закрыть", style: .default)
            alarm.addAction(alarmAction)
            self.present(alarm, animated: true)
        } else {
            let alarm = UIAlertController(title: "Пароль должен быть не менее 4х символов", message: "", preferredStyle: .alert)
            let alarmAction = UIAlertAction(title: "Закрыть", style: .default)
            alarm.addAction(alarmAction)
            self.present(alarm, animated: true)
            passwordText.text = ""
        }
        
        
    }
  
}
