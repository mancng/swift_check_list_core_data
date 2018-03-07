//
//  ViewController.swift
//  check-list
//
//  Created by Rachel Ng on 1/22/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

protocol AddViewControllerDelegate: class {
    func addItem(by contoller: UIViewController, title: String?, descriptions: String?, due_date: Date?, status: Bool?, didEdit: Tasks?)
}

import UIKit

class AddViewController: UIViewController {
    
    var itemTitle: String?
    var itemDescription: String?
    var itemDue_date: Date?
    var itemStatus: Bool?
    var itemToEdit: Tasks?
    
    weak var delegate: AddViewControllerDelegate?
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionsTextField: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
    
        let item = titleTextField.text!
        let descriptions = descriptionsTextField.text!
        let due_date = datePicker.date

        
        if item.count > 0 && descriptions.count > 0 {
            delegate?.addItem(by: self, title: item, descriptions: descriptions, due_date: due_date, status: false, didEdit: itemToEdit)
            print(due_date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.layer.borderWidth = 1
        descriptionsTextField.layer.borderWidth = 1
        self.hideKeyboardWhenTappedAround()
        
        if let myItem = itemToEdit {
            titleTextField.text = myItem.title
            descriptionsTextField.text = myItem.descriptions
            datePicker.date = myItem.due_date!
            itemStatus = false
            addButton.setTitle("Save", for: .normal)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

