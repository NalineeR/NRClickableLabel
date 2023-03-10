//
//  NRClickableLabel.swift
//
//  Created by Nalinee on 07/03/2023.
//

import UIKit

public class NRClickableLabel:UITextView{
    ///holds the full text
    public var fullText = String()
    /// holds array of NRLinkAttribute. Which will be used to create link in text
    public var arrLinkAttributes = [NRLinkAttribute]()
    /// holds attribute for complete text.
    public var normalTextAttributes = NRTextAttribute()
    
    ///link tap handler. Called when the link is tapped. Returns the clicked Link
    public var linkHandler:((_ link:URL)->())? = nil
    
    //MARK: init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initialSetup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    //MARK: private functions
    private func initialSetup(){
        //remove default padding
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
        isEditable = false
        isSelectable = true
        isScrollEnabled = false
        delegate = self
        dataDetectorTypes = [.link]
        linkTextAttributes = [:]
    }
    /// init link text attributes' struct
    ///
    /// - Parameters:
    ///   - textToLink: the text which will be clickable
    ///   - linkURL: the url for the linked text
    ///   - font: font for linked text
    ///   - textColor: color of linked text
    ///   - underlineColr: under line color. If nil then underline will not be set.
    public func process(tapHandler handler: ((URL)->())?){
        let attrString = NSMutableAttributedString(string: fullText,
                                                   attributes: [.foregroundColor:normalTextAttributes.color,
                                                                .font:normalTextAttributes.font])
        for obj in arrLinkAttributes{
            if let rangeVal = attrString.string.range(of: obj.linkText){
                
                let nsRange = NSRange(rangeVal, in: attrString.string)
                attrString.addAttribute(.link, value: obj.link, range: nsRange)
                attrString.addAttribute(.font, value: obj.font, range: nsRange)
                attrString.addAttribute(.foregroundColor, value: obj.textColor, range: nsRange)
                
                if let underlineColor = obj.underlineColor{
                    attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: nsRange)
                    attrString.addAttribute(.underlineColor, value: underlineColor, range: nsRange)
                }
            }
        }
        self.attributedText = attrString
        updateHeight()
        linkHandler = handler
    }
    /// update the text frame
    private func updateHeight(){
        sizeToFit()
        if let index = self.constraints.firstIndex(where: {$0.firstAttribute == .height}){
            self.constraints[index].constant = self.contentSize.height
        }else{
            var updatedFrame = self.frame
            updatedFrame.size.height = self.contentSize.height
            self.frame = updatedFrame
        }
    }
}

extension NRClickableLabel:UITextViewDelegate{
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        linkHandler?(URL)
        return linkHandler == nil
    }
}
