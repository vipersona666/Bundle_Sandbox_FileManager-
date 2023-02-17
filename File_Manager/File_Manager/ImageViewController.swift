//
//  ImageViewController.swift
//  File_Manager
//
//  Created by Андрей Байдаченко on 09.02.2023.
//

import UIKit

class ImageViewController: UITableViewController{
    
    var imageVCDelegate: SettingsViewController?
    
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var content: [String] {
        do{
            let content = try FileManager.default.contentsOfDirectory(atPath: path)
            
            return content
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Content", content)
        
    }
    
    private func sortContent() -> [String] {
           if UserDefaults.standard.bool(forKey: "sortContent") {
               let sortedContent = content.sorted(by: {$0 < $1})
               return sortedContent
           } else {
               let nonSortedContent = content
               return nonSortedContent
           }
       }
    
    //@IBAction func pushFileAction(_ sender: Any) {
    //}
    @IBAction func pushFileAction(_ sender: Any) {
        //let newPath = path + "/" + String(content.count) + ".jpeg"
        //let atPath = Bundle.main.path(forResource: "cat6", ofType: ".jpeg")!
        //let toPath =
        //try? FileManager.default.copyItem(atPath: atPath , toPath: newPath)
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
       //vc.allowsEditing = true
        tableView.reloadData()
        present(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        //count = content.count
        return content.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let sortContent = sortContent()
        cell.textLabel?.text = sortContent[indexPath.row]
        
        let fullPath = path + "/" + sortContent[indexPath.row]
        
        var isDirectory: ObjCBool = false
        
        FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDirectory)
        
        if isDirectory.boolValue {
            cell.detailTextLabel?.text = "Folder"
        } else {
            cell.detailTextLabel?.text = "File"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
  
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let sortContent = sortContent()
        if editingStyle == .delete {
            tableView.beginUpdates()
            let pathImage = path + "/" + sortContent[indexPath.row]
            try? FileManager.default.removeItem(atPath: pathImage)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        } else if editingStyle == .insert {
             //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

}
extension ImageViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage, let imageName = (info[.imageURL] as? URL)?.lastPathComponent , let imageData = pickedImage.jpegData(compressionQuality: 1){
            print("imageName", imageName)
//            UserDefaults.standard.set((currentCount ?? 0) + 1, forKey: countKey)
//            if UserDefaults.standard.bool(forKey: countKey){
//                currentCount? += 1
//                //UserDefaults.standard.set(currentCount, forKey: countKey)
//                print("-----")
//                //defaults.set(currentCount, forKey: )
//            } else {
//                currentCount = 1
//                UserDefaults.standard.set(currentCount, forKey: countKey)
//            }
            
            
            //print("countKey",defaults.integer(forKey: countKey))
            //count += 1
            
            //let name = String(imageName.count + 1) + ".jpeg"
            let imagePath = URL(fileURLWithPath: path).appendingPathComponent(imageName)
            print("imagePath", imagePath)
            
            do{
                try imageData.write(to: imagePath)
            } catch {
                print(error.localizedDescription)
            }
            
            
            
            //
            //let newPath = path + "/" + imageName
            //let atPath = Bundle.main.path(forResource: "cat6", ofType: ".jpeg")!
            //try? FileManager.default.copyItem(atPath: atPath , toPath: newPath)
            
            tableView.reloadData()
        }
        picker.dismiss(animated: true)
    }
    
}
