//
//  ListaController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/12/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
//Duhet te jete conform protocoleve per tabele

class ListaController: UIViewController,  UITableViewDelegate ,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    //Krijo IBOutlet tableView nga View
    //Krijo nje varg qe mban te dhena te tipit CoinCellModel
    var coinCell = [CoinCellModel]()
    //Krijo nje variable slectedCoin te tipit CoinCellModel
    var selectCoin:CoinCellModel!
    //kjo perdoret per tja derguar Controllerit "DetailsController"
    //me poshte, kur ndodh kalimi nga screen ne screen (prepare for segue)
    
    
    //URL per API qe ka listen me te gjithe coins
    //per me shume detaje : https://www.cryptocompare.com/api/
    let APIURL = "https://min-api.cryptocompare.com/data/all/coinlist"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //regjistro delegate dhe datasource per tableview
      tableView.delegate = self
       tableView.dataSource = self
        
        //regjistro custom cell qe eshte krijuar me NIB name dhe
        tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
        //reuse identifier
        
        //Thirr funksionin getDataFromAPI()
        getDataFromAPI()
    }
    
    //Funksioni getDataFromAPI()
    //Perdor alamofire per te thirre APIURL dhe ruan te dhenat
    //ne listen vargun me CoinCellModel
    //Si perfundim, thrret tableView.reloadData()
    func getDataFromAPI(){
        Alamofire.request(APIURL).responseData { (data) in
          
            if data.result.isSuccess {
                  let coinJSON = JSON(data.result.value!)
                for (key, value):(String, JSON) in coinJSON["Data"]{
                    let coin = CoinCellModel(coinName: value["CoinName"].stringValue, coinSymbol: value["Name"].stringValue, coinAlgo: value["Algorithm"].stringValue, totalSuppy: value["TotalCoinSuppy"].stringValue, imagePath: value["ImageUrl"].stringValue)
                    self.coinCell.append(coin)
                }
                self.tableView.reloadData()
            }
        }
    }

    //Shkruaj dy funksionet e tabeles ketu
    //cellforrowat indexpath dhe numberofrowsinsection
   
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
       cell.lblEmri.text = coinCell[indexPath.row].coinName
       cell.lblTotali.text = coinCell[indexPath.row].totalSuppy
        cell.lblSymboli.text = coinCell[indexPath.row].coinSymbol
        cell.lblAlgoritmi.text = coinCell[indexPath.row].coinAlgo
        cell.imgFotoja.af_setImage(withURL: URL(string: coinCell[indexPath.row].coinImage())!)
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinCell.count
    }
    
    
    //Funksioni didSelectRowAt indexPath merr parane qe eshte klikuar
    //Ruaj Coinin e klikuar tek selectedCoin variabla e deklarurar ne fillim
    //dhe e hap screenin tjeter duke perdore funksionin
    //performSeguew(withIdentifier: "EmriILidhjes", sender, self)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectCoin = coinCell[indexPath.row]
        performSegue(withIdentifier: "shfaqDetajet", sender: selectCoin)
    }
    
    //Beje override funksionin prepare(for segue...)
    //nese identifier eshte emri i lidhjes ne Storyboard.
    //controllerit tjeter ja vendosim si selectedCoin, coinin
    //qe e kemi ruajtur me siper
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shfaqDetajet" {
            let pick = segue.destination as! DetailsController
            pick.selectedCoin = selectCoin
            
    }
   
    }
}
