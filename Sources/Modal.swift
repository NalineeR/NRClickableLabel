//
//  Modal.swift
//  ClickableLabel
//
//  Created by Nalinee on 07/03/2023.
//

import UIKit


public struct NRTextAttribute{
    public var color: UIColor
    public var font: UIFont
    
    public init(textColor:UIColor = .black,
         textFont:UIFont = .systemFont(ofSize: 15)){
        
        color = textColor
        font = textFont
    }
}


public struct NRLinkAttribute{
    public var linkText: String
    public var textColor: UIColor?
    public var font: UIFont?
    public var link: URL?
    public var underlineColor : UIColor?
    
    /// init link text attributes' struct
    ///
    /// - Parameters:
    ///   - textToLink: the text which will be clickable
    ///   - linkURL: the url for the linked text
    ///   - font: font for linked text
    ///   - textColor: color of linked text
    ///   - underlineColr: under line color. If nil then underline will not be set.
    public init (linkText:String, link:URL?,
                 font:UIFont?=nil,textColor:UIColor?=nil,
                 underlineClr:UIColor?=nil){
        
        self.linkText = linkText
        self.link = link
        self.textColor = textColor
        self.font = font
        self.underlineColor = underlineClr
    }
}
