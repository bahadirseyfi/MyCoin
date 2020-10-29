//
//  ViewController.swift
//  MyCoin
//
//  Created by bahadir on 27.10.2020.
//

import UIKit

class ViewController: UIViewController{
    

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var coinManager = CoinManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    coinManager.delegate = self
    currencyPicker.dataSource = self
    currencyPicker.delegate = self
      
        //let sayi = CoinManager.parseJSON(Data)
    }
    @IBAction func segmented(_ sender: UISegmentedControl) {
        //let selectedSeg = sender.selectedSegmentIndex
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            dateLabel.text = "BTC";
            dateLabel.backgroundColor = .orange;
            
        case 1:
            dateLabel.text = "ETH";
            dateLabel.backgroundColor = .systemGreen;
                //UIColor(displayP3Red: 51, green: 51, blue: 255, alpha: 0.7);
        default:
            break
        }
    }
    

}
//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
  
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
}
//MARK: - UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        if segmentedControl.selectedSegmentIndex == 0 {
            coinManager.getCoinPrice(for: selectedCurrency, base: "BTC")
        } else {
            coinManager.getCoinPrice(for: selectedCurrency, base: "ETH")
        }
       
    }
    
}
