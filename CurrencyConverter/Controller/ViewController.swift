//
//  ViewController.swift
//  ByteCoin
//
//  Created by Ali Tamoor on 11/04/2022


import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var fromTxtField: UITextField!
    @IBOutlet weak var toTxtField: UITextField!
    @IBOutlet weak var fromCurrency: UILabel!
    @IBOutlet weak var toCurrency: UILabel!
    var coinManager = CoinManager()
    var toFromFlag:Bool = true
    var coinModel = CoinModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        coinManager.delegate = self
        fromTxtField.delegate = self
        toTxtField.delegate = self
        coinManager.performRequestForCurrencyCode(pickerview: self.pickerView)
    }
    @IBAction func fromTxtFieldEditingChanged(_ sender: UITextField) {
        if sender == fromTxtField{
            coinModel.fromCurrencyLbl = fromCurrency.text ?? ""
            coinModel.toCurrencyLbl = toCurrency.text ?? ""
        } else {
            coinModel.fromCurrencyLbl = toCurrency.text ?? ""
            coinModel.toCurrencyLbl = fromCurrency.text ?? ""
        }
        coinManager.performRequest(coinModel: coinModel)
    }
}

// MARK: - TextField Delegate Methods

extension ViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fromTxtField{
            toFromFlag = true
        } else {
            toFromFlag = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fromTxtField{
            coinModel.fromCurrencyLbl = fromCurrency.text ?? ""
            coinModel.toCurrencyLbl = toCurrency.text ?? ""
            coinManager.performRequest(coinModel: coinModel)
        } else {
            coinModel.fromCurrencyLbl = toCurrency.text ?? ""
            coinModel.toCurrencyLbl = fromCurrency.text ?? ""
            coinManager.performRequest(coinModel: coinModel)
        }
        return true
    }
}
// MARK: - PickerView DataSource Methods

extension ViewController:UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
}

// MARK: - PickerView Delegate Methods

extension ViewController:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(coinManager.currencyArray[row])
        if toFromFlag {
            fromCurrency.text = coinManager.currencyArray[row]
        } else {
            toCurrency.text = coinManager.currencyArray[row]
        }
        coinModel.fromCurrencyLbl = fromCurrency.text ?? ""
        coinModel.toCurrencyLbl = toCurrency.text ?? ""
        coinManager.performRequest(coinModel: coinModel)
    }
}

// MARK: - CoinManager Delegate Methods

extension ViewController:CoinManagerDelegate{
    func updateCoinResults(results: Double) {
        if toFromFlag {
            let results = results * (Double(fromTxtField.text!) ?? 0)
            toTxtField.text = String(format: "%.6f", results)
        } else {
            let results = results * (Double(toTxtField.text!) ?? 0)
            fromTxtField.text = String(format: "%.6f%", results)
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

