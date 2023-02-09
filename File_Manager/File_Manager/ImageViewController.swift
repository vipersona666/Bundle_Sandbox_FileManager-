//
//  ImageViewController.swift
//  File_Manager
//
//  Created by Андрей Байдаченко on 09.02.2023.
//

import UIKit

class ImageViewController: UITableViewController{
    
    var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    var file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    var content: [String] {
        do{
            
            return try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            print(error.localizedDescription)
            return []
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        print("Content", content)
       
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
        // #warning Incomplete implementation, return the number of rows
        return content.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = content[indexPath.row]
        
        let fullPath = path + "/" + content[indexPath.row]
        
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
        if editingStyle == .delete {
            tableView.beginUpdates()
            let pathImage = path + "/" + content[indexPath.row]
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
        if let pickedImage = info[.originalImage] as? UIImage, let imageName = (info[.imageURL] as? URL)?.lastPathComponent, let imageData = pickedImage.jpegData(compressionQuality: 1){
            print("imageName", imageName)
            
            let imagePath = URL(fileURLWithPath: path).appendingPathComponent(imageName)
            print("imagePath", imagePath)
            
            do{
                try imageData.write(to: imagePath)
            } catch {
                print(error.localizedDescription)
            }
            //let newPath = path + "/" + imageName
            //let atPath = Bundle.main.path(forResource: "cat6", ofType: ".jpeg")!
            //try? FileManager.default.copyItem(atPath: atPath , toPath: newPath)
            
            tableView.reloadData()
        }
        picker.dismiss(animated: true)
    }
    
}
