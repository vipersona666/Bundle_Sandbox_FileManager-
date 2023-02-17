//
//  LoginViewController.swift
//  File_Manager
//
//  Created by Андрей Байдаченко on 11.02.2023.
//

import UIKit
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

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
                let alarm = UIAlertController(title: "Пароли не совпадают, введите заново", message: "", preferredStyle: .alert)
                let alarmAction = UIAlertAction(title: "Закрыть", style: .default)
                alarm.addAction(alarmAction)
                self.present(alarm, animated: true)
            }
            
        }
    }
    
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var passwordButton: UIButton!
    
    
    func checkLogin(){
        if (KeychainWrapper.standard.string(forKey: "pass") != nil){
            signUp = !signUp
        }else {
            signUp = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Удаление пароля из кейчейн, для проверки входа
        //KeychainWrapper.standard.remove(forKey: "pass")
        checkLogin()
    }
    
    @IBAction func passwordAction(_ sender: UIButton) {
       //если пароль еще не записан в кейчейн
        if KeychainWrapper.standard.string(forKey: "pass") == nil {
            if passwordText.text!.count >= 4{
                passwordCoun += 1
                if passwordCoun == 2{
                    if passwordText.text == KeychainWrapper.standard.string(forKey: "key") {
                        print("Пароль записан в keychain")
                        KeychainWrapper.standard.set(passwordText.text!, forKey: "pass")
                        passwordCoun = 0
                        signUp = false
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
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
            
        // пароль уже был записан в кейчейн
        } else {
            if passwordText.text!.count >= 4{
                    if passwordText.text == KeychainWrapper.standard.string(forKey: "pass") {
                        print("Пароль введен верно")
                        signUp = false
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "tabBarController")
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        repeatPass = false
                        print("Пароль введен неверно")
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
  
}
