//
//  SendEthViewController.swift
//  TippingERC20
//
//  Created by 辻林 大揮 on 2018/05/09.
//  Copyright © 2018年 chocovayashi. All rights reserved.
//

import UIKit
import BigInt
import web3swift

class SendEthViewController: UIViewController {

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
        
        let coldWalletABI = "[{\"payable\":true,\"type\":\"fallback\"}]"
        var options = Web3Options.defaultOptions()
        guard let intValue = Int(value) else { return }
        options.value = BigUInt(intValue * Int(pow(10, Config.decimal).description)!)
        options.from = Config.myAddress
        let toAddress = EthereumAddress(address)
        let intermediate = Config.network.contract(coldWalletABI, at: toAddress, abiVersion: 2)!.method(options: options)!
        guard let password = Config.password else {
            fatalError("環境変数をセットしてください")
        }
        let sendResult = intermediate.send(password: password)
        switch sendResult {
        case .success(let r):
            print(r)
        case .failure(let err):
            print(err)
        }
    }
}
