//
//  ViewController.swift
//  NRClickableLabel
//
//  Created by NalineeR on 03/10/2023.
//  Copyright (c) 2023 NalineeR. All rights reserved.
//

import UIKit
import NRClickableLabel

class ViewController: UIViewController {

    @IBOutlet weak var clickablV:NRClickableLabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let arrLinks = [URL(string: "https://www.google.co.in")!,
                        URL(string: "https://www.apple.com")!]
        
        let attr = NSMutableAttributedString(string: "I am Google. I am Apple. I am Alert")
        attr.addAttributes([.foregroundColor: UIColor.magenta], range: NSRange(location: 5, length: 6))
        attr.addAttributes([.font: UIFont.systemFont(ofSize: 23, weight: .thin)], range: NSRange(location: 25, length: 10))
        
        
        clickablV.fullAttributedText = attr
        //------------prepare the list of link and attributes------------
        let linkFont:UIFont = .systemFont(ofSize: 23, weight: .bold)
        //Note:pass link as nil if there is no link but you want to handle the tap
        let arr = [NRLinkAttribute(linkText: "Apple",link: arrLinks[1]
                                    ,font:linkFont,textColor: UIColor.brown,
                                   underlineClr: UIColor.red),
                    NRLinkAttribute(linkText: "Google", link: arrLinks[0]),
                    NRLinkAttribute(linkText: "I am Alert", link: nil)]

        clickablV.arrLinkAttributes = arr
        //----------set normal text attribute if required----------
//        let normaFont:UIFont = .systemFont(ofSize: 20, weight: .thin)
//        clickablV.normalTextAttributes = NRTextAttribute(textColor: .purple, textFont: normaFont)

        //-----------process and handle the link------------
        clickablV.process(tapHandler: {[weak self] (link,linkedText) in
            if let url = link, !url.absoluteString.isEmpty{
                self?.openLink(link: url)
            }else{
                self?.showAlert(strMessage: linkedText)
            }
        })
    }
    
    
    func openLink(link:URL){
        
        if UIApplication.shared.canOpenURL(link){
            UIApplication.shared.open(link)
        }
    }
    func showAlert(strMessage:String){
        let alertView = UIAlertController(title: "Alert" , message: strMessage, preferredStyle: .alert)
        
        alertView.addAction(UIAlertAction(title: "Got It", style: UIAlertAction.Style.default, handler:{(action) in
            
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

