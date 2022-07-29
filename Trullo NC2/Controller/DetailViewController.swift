//
//  DetailViewController.swift
//  Trullo NC2
//
//  Created by Mikhael Adiputra on 28/07/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var bgCard: UIView!
    @IBOutlet weak var reminderTitleTextfield: UITextField!
    @IBOutlet weak var reminderTypeTextfield: UITextField!
    @IBOutlet weak var reminderDesc: UITextView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private let detailViewModel      = DetailViewModel()
    var titleString = String()
    var pickerView  = UIPickerView()
    
    override func viewWillAppear(_ animated: Bool) {
        self.refetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.reminderTitleTextfield.delegate = self
        self.reminderTypeTextfield.delegate  = self
        self.reminderDesc.delegate           = self
        self.pickerView.delegate             = self
        self.pickerView.dataSource           = self
        self.bgCard.setCustomRadius(9)
        self.reminderTypeTextfield.inputView = pickerView
    }
    
    private func refetchData() {
        if titleString.count == 0 {
            self.disableUIViewState(reminderTypeEnabled: true, reminderTitleEnabled: true, reminderDescEnabled: true, deleteButtonEnabled: false, saveButtonEnabled: true)
        }else {
            self.disableUIViewState(reminderTypeEnabled: false, reminderTitleEnabled: false, reminderDescEnabled: false, deleteButtonEnabled: true, saveButtonEnabled: false)
            detailViewModel.getReminderID(titleString) {
                self.reminderTitleTextfield.text = self.detailViewModel.reminderObject?.title
                self.reminderTypeTextfield.text  = self.detailViewModel.reminderType
                self.reminderDesc.text           = self.detailViewModel.reminderObject?.desc
            }
        }
    }
    
    private func disableUIViewState(reminderTypeEnabled : Bool, reminderTitleEnabled : Bool, reminderDescEnabled : Bool, deleteButtonEnabled : Bool, saveButtonEnabled : Bool) {
        self.reminderTypeTextfield.isEnabled  = reminderTypeEnabled
        self.reminderTitleTextfield.isEnabled = reminderTitleEnabled
        self.reminderDesc.isEditable = reminderDescEnabled
        self.deleteButton.isEnabled  = deleteButtonEnabled
        self.saveButton.isEnabled    = saveButtonEnabled
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
        detailViewModel.deleteReminder(self.detailViewModel.reminderObject!.title!) { result in
            DispatchQueue.main.async {
                switch result {
                case true:
                    self.navigationController?.popViewController(animated: true)
                case false:
                    self.present(createAlert(titleAlert: "Gagal Hapus", messageAlert: "Gagal nenghapus data, silahkan recheck kembali database anda", okayAction: "Ok"), animated: true)
                }
            }
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        detailViewModel.addReminder(self.reminderTitleTextfield.text ?? "", self.reminderDesc.text, Date(), reminderType: self.reminderTypeTextfield.text ?? "") { result in
            DispatchQueue.main.async {
                switch (result) {
                case .success:
                    self.present(createAlert(titleAlert: "Berhasil!", messageAlert: "Reminder Berhasil Dimasukkan!", okayAction: "Ok"), animated: true) {
                        self.navigationController?.popViewController(animated: true)
                    }
                case .gagalAddData:
                    self.present(createAlert(titleAlert: "Gagal Menambahkan File!", messageAlert: "Terdapat kesalahaan saat melakukan penyimpanan data", okayAction: "Ok"), animated: true)
                case .salahInputType:
                    self.present(createAlert(titleAlert: "Invalid Data!", messageAlert: "Data yang diberikan tidak lengkap, silahkan isi semua textfield yang harus diisi!", okayAction: "Ok"), animated: true)
                }
            }
        }
    }
}

extension DetailViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}

extension DetailViewController : UITextViewDelegate {
}

extension DetailViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return detailViewModel.numberOfRowInComponent()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return detailViewModel.didSelectPicker(indexpath: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.reminderTypeTextfield.text = detailViewModel.didSelectPicker(indexpath: row)
        self.reminderTypeTextfield.resignFirstResponder()
    }
}
