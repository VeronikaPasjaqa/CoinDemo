//
//  ViewController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import SwiftyJSON
import CoreData
class DetailsController: UIViewController {

    //selectedCoin deklaruar me poshte mbushet me te dhena nga
    //controlleri qe e thrret kete screen (Shiko ListaController.swift)
    var selectedCoin:CoinCellModel!
    
    //IBOutlsets jane deklaruar me poshte
    @IBOutlet weak var imgFotoja: UIImageView!
    @IBOutlet weak var lblDitaOpen: UILabel!
    @IBOutlet weak var lblDitaHigh: UILabel!
    @IBOutlet weak var lblDitaLow: UILabel!
    @IBOutlet weak var lbl24OreOpen: UILabel!
    @IBOutlet weak var lbl24OreHigh: UILabel!
    @IBOutlet weak var lbl24OreLow: UILabel!
    @IBOutlet weak var lblMarketCap: UILabel!
    @IBOutlet weak var lblCmimiBTC: UILabel!
    @IBOutlet weak var lblCmimiEUR: UILabel!
    @IBOutlet weak var lblCmimiUSD: UILabel!
    @IBOutlet weak var lblCoinName: UILabel!
    
    //APIURL per te marre te dhenat te detajume per coin
    //shiko: https://www.cryptocompare.com/api/ per detaje
    let APIURL = "https://min-api.cryptocompare.com/data/pricemultifull"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //brenda ketij funksioni, vendosja foton imgFotoja Outletit
        //duke perdorur AlamoFireImage dhe funksionin:
        //af_setImage(withURL:URL)
        //psh: imgFotoja.af_setImage(withURL: URL(string: selectedCoin.imagePath)!)
        //Te dhenat gjenerale per coin te mirren nga objeti selectedCoin
        
        imgFotoja.af_setImage(withURL: URL(string: selectedCoin.coinImage())!)
        
        //Krijo nje dictionary params[String:String] per ta thirrur API-ne
        //parametrat qe duhet te jene ne kete params:
        //fsyms - Simboli i Coinit (merre nga selectedCoin.coinSymbol)
        //tsyms - llojet e parave qe na duhen: ""BTC,USD,EUR""
        
        //Thirr funksionin getDetails me parametrat me siper

       
            let fsyms = selectedCoin.coinSymbol
            let tsyms = "BTC,USD,EUR"
        
            getDetails(params: ["fsyms": fsyms, "tsyms": tsyms])
    

      
        }
        
    
  

    func getDetails(params:[String:String]){
        //Thrret Alamofire me parametrat qe i jan jap funksionit
        //dhe te dhenat qe kthehen nga API te mbushin labelat
        //dhe pjeset tjera te view
        Alamofire.request(APIURL, method: .get, parameters: params).responseData { (data) in
            
            if data.result.isSuccess {
                let coinJSON = try! JSON(data: data.result.value!)
                let coin = CoinDetailsModel(marketCap: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["MKTCAP"].stringValue,
                                            hourHigh: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["HIGH24HOUR"].stringValue,
                                            hourLow: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["LOW24HOUR"].stringValue,
                                            hourOpen: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["OPENHOUR"].stringValue,
                                            dayHigh: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["BTC"]["HIGHDAY"].stringValue,
                                            dayLow: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["BTC"]["LOWDAY"].stringValue,
                                            dayOpen: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["OPENDAY"].stringValue,
                                            priceEUR: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["BTC"]["PRICE"].stringValue,
                                            priceUSD: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["USD"]["PRICE"].stringValue,
                                            priceBTC: coinJSON["DISPLAY"][self.selectedCoin.coinSymbol]["EUR"]["PRICE"].stringValue)
                self.updateUI(coin: coin)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //IBAction mbylle - per butonin te gjitha qe mbyll ekranin
    @IBAction func mbylle(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateUI(coin:CoinDetailsModel) {
        
        lblCoinName.text = "\(selectedCoin.coinName)"
        lbl24OreLow.text = "\(coin.hourLow)"
        lblDitaHigh.text = "\(coin.dayHigh)"
        lblDitaLow.text = "\(coin.dayLow)"
        lblDitaOpen.text = "\(coin.dayOpen)"
        lblMarketCap.text = "\(coin.marketCap)"
        lbl24OreOpen.text = "\(coin.dayOpen)"
        lbl24OreHigh.text = "\(coin.hourHigh)"
        lblCmimiBTC.text = "\(coin.priceBTC)"
        lblCmimiEUR.text = "\(coin.priceEUR)"
        lblCmimiUSD.text = "\(coin.priceUSD)"
    
        
        
        
    }
    @IBAction func ruajFav(_ sender: Any) {
        
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let newCoin = NSEntityDescription.insertNewObject(forEntityName: "Favorites", into: context)
        newCoin.setValue(selectedCoin.coinAlgo, forKey: "coinAlgo")
        newCoin.setValue(selectedCoin.coinName, forKey: "coinName")
        newCoin.setValue(selectedCoin.imagePath, forKey: "imagePath")
         newCoin.setValue(selectedCoin.totalSuppy, forKey: "totalSuppy")
         newCoin.setValue(selectedCoin.coinSymbol, forKey: "coinSymbol")
        do {
            try context.save()
        } catch  {
            print("gabim")
        }
        
        
         }
}

