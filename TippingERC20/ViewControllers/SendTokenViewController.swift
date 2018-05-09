//
//  SendTokenViewController.swift
//  TippingERC20
//
//  Created by 辻林 大揮 on 2018/05/09.
//  Copyright © 2018年 chocovayashi. All rights reserved.
//

import UIKit
import BigInt
import web3swift

class SendTokenViewController: UIViewController {

    @IBOutlet weak var addressTextView: UITextView!
    
    @IBOutlet weak var valueTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addressTextView.layer.borderWidth = 1
        addressTextView.layer.borderColor = UIColor.black.cgColor
        
        sendButton.addTarget(self, action: #selector(SendEthViewController.send), for: .touchUpInside)
    }
    
    @objc func send() {
        let address = addressTextView.text ?? ""
        let value = valueTextField.text ?? ""
        addressTextView.text = ""
        valueTextField.text = ""
        
        var options = Web3Options.defaultOptions()
        options.from = Config.myAddress
        guard let intValue = Int(value) else { return }
        let bigValue = BigUInt(intValue * Int(pow(10, Config.decimal).description)!) as AnyObject
        Config.network.addKeystoreManager(Config.keystoreManager)
        let contract = Config.network.contract(Config.contractAbi, at: Config.contractAddress, abiVersion: 2)!
        let parameters: [AnyObject] = [address as AnyObject, bigValue]
        let intermediate = contract.method("transfer", parameters: parameters, options: options)
        guard let password = Config.password else {
            fatalError("環境変数をセットしてください")
        }
        guard let sendTokenResult = intermediate?.send(password: password) else { return }
        switch sendTokenResult {
        case .success(let r):
            print(r)
        case .failure(let err):
            print(err)
        }
    }
}
