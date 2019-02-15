//
//  MLVC.swift
//  MLTryApp
//
//  Created by Ali Dhanani on 15/02/2019.
//  Copyright © 2019 Ali Dhanani. All rights reserved.
//

import UIKit

class MLVC: UIViewController {
    
    @IBOutlet var imageView: UIImageView! // Image Show
    @IBOutlet weak var navBar: UINavigationItem!
    
    var value: [String] = ["Value"]
    var descript: [String] = ["Description"]
    
    let CellReuseIdentifer = "Cell"
    
    @IBOutlet var tableView: UITableView! // Table View
    
    var mobile = MobileNet()
    
    let imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        // Do any additional setup after loading the view.
        navBar.title = "None"
        ShowData()
    }
    
    @IBAction func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            showCameraNotAvailableAlert()
        }
    }
    
    private func recongnize(image: UIImage) -> String {
        if let pixelBufferImage = ImageToPixelBufferConverter.convertToPixelBuffer(image: image) {
            if let predication = try? self.mobile.prediction(image: pixelBufferImage) {
                return predication.classLabel
            }
        }
        return ""
    }
    
    @IBAction func addValue() {
        if(navBar.title != "None") {
            CoreService.shared.CreateUser(Value: navBar.title!, Description: "Fruit") {
                self.value.removeAll()
                self.descript.removeAll()
                self.ShowData()
            }
        }
    }
    
    @IBAction func selectPhoto() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func ShowData() {
        CoreService.shared.printNotes { (value, desc) in
            self.value = value
            self.descript = desc
            self.tableView.reloadData()
        }
    }
    
    
    private func showRecognitionFailureAlert() {
        let alertController = UIAlertController.init(title: "Recognition Failure", message: "Please try another image.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func showCameraNotAvailableAlert() {
        let alertController = UIAlertController.init(title: "Camera Not Available", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

extension MLVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageSelected = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = imageSelected
            
            if let topPrediction = recongnize(image: imageSelected) as? String{
                print("Result: \(topPrediction)")
                navBar.title = topPrediction
            } else {
                showRecognitionFailureAlert()
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MLVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ItemCell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifer) as! UITableViewCell
            ItemCell.textLabel?.text = value[indexPath.row]
        return ItemCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreService.shared.DeleteUser(Position: indexPath.row) {
                self.value.removeAll()
                self.descript.removeAll()
                self.ShowData()
            }
        }
    }
    
}
