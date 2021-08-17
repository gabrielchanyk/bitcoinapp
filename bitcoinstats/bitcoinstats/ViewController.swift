//
//  ViewController.swift
//  bitcoinstats
//
//  Created by user196869 on 7/27/21.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblVal: UILabel!
    
    @IBOutlet weak var symPickerview: UIPickerView!
    @IBOutlet weak var bitImg: UIImageView!
    //object for service to point to the delegate
    lazy var bitcoinService : Service  = {
        let service = Service()
        service.delegate = self
        return service
    }()
    //reload pickerview if changes to countries, probably can do it at the service delegate
    var countries :[String]? {
        didSet {
            self.symPickerview .reloadAllComponents()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get list of symbols and update pickerview
        bitcoinService.getSymbInfo(url: "https://apiv2.bitcoinaverage.com/info/indices/ticker/global")
        bitcoinService.fetchImg(url: "https://media.istockphoto.com/photos/glowing-dark-background-with-bitcoin-symbol-picture-id1255216496") {(data) in
            DispatchQueue.main.async { [unowned self] in
                self.bitImg.image = UIImage(data:data)
            }
        }
    }
}
extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries![row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //get ask price of coin
        bitcoinService.getValue(url: "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(countries![row])") {(data) in
            DispatchQueue.main.async {
                [unowned self] in
                //update label with new ask value
                self.lblVal.text = "\(data.ask)"
            }
        }
    }
    
}

extension ViewController: ServiceDelegate{
    func getCountriesDidFinish(countrydata: Dictionary<String,Any>) {
        DispatchQueue.main.async {
            [unowned self] in
            self.countries = CountrySymb.ConvertDatatoBTCArray(countrydata: countrydata)
        }
    }
}
