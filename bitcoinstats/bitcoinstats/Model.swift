//
//  Model.swift
//  bitcoinstats
//
//  Created by user196869 on 7/28/21.
//

import Foundation

class CountrySymb
{
    //convert data into string array for pickerview
    static func ConvertDatatoBTCArray(countrydata: Dictionary<String,Any>) -> [String]?  {
        var countBTCSymb:[String]? = []
        guard let countSymb = countrydata["symbols"]  as? [String]
        else{return nil}
        for countsym in countSymb
        {
        let symb:NSString = countsym as NSString
        let symbtext = symb .substring(with: NSMakeRange(0, 3))
        if (symbtext == "BTC")
        {
            countBTCSymb?.append(symb .substring(with: NSMakeRange(3, symb.length - 3)))
        }
        }
        return countBTCSymb
        }
        
}
//class might not be needed just wanted to try it out
class BitcoinValue :Codable
{
    var ask: Double
}

