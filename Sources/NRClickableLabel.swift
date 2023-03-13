//
//  NRClickableLabel.swift
//
//  Created by Nalinee on 07/03/2023.
//

import UIKit

public class NRClickableLabel:UITextView{
    
    public typealias linkTapCallback = ((_ urlValue:URL?,_ linkedText:String)->())
    
    ///holds the full text
    public var fullAttributedText = NSMutableAttributedString()
    /// holds array of NRLinkAttribute. Which will be used to create link in text
    public var arrLinkAttributes = [NRLinkAttribute]()
    /// holds attribute for complete text.
    public var normalTextAttributes:NRTextAttribute? = nil
//    ///Holds the bool value for whether the normal text attributes should be applied or not
//    public var shouldApplyNormalAttributes = false
    
    ///link tap handler. Called when the link is tapped. Returns the clicked Link
    public var linkHandler:linkTapCallback? = nil
    
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
    public func process(tapHandler handler: linkTapCallback?){
        
        let attrString = fullAttributedText.mutableCopy() as! NSMutableAttributedString
        if let normalAttr = normalTextAttributes{
            let fullRange = NSRange(location: 0, length: attrString.length)
            attrString.addAttributes([.foregroundColor:normalAttr.color,
                                      .font:normalAttr.font], range: fullRange)
        }
        
        for obj in arrLinkAttributes{
            if let rangeVal = attrString.string.range(of: obj.linkText){
                
                let nsRange = NSRange(rangeVal, in: attrString.string)
                if let linkVal = obj.link {
                    attrString.addAttribute(.link, value: linkVal, range: nsRange)
                }else{
                    attrString.addAttribute(.link, value: "", range: nsRange)
                }
                //---------add if provided by user--------
                if let linkFont = obj.font{
                    attrString.addAttribute(.font, value: linkFont, range: nsRange)
                }
                if let linkTextColor = obj.textColor{
                    attrString.addAttribute(.foregroundColor, value: linkTextColor, range: nsRange)
                }
                if let underlineColor = obj.underlineColor{
                    attrString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: nsRange)
                    attrString.addAttribute(.underlineColor, value: underlineColor, range: nsRange)
                }
            }
        }
        let attrFinal = self.attributedText.mutableCopy() as! NSMutableAttributedString
        attrFinal.append(attrString)
        self.attributedText = attrFinal
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
        var linkedText = ""
        if let range = Range(characterRange, in: fullAttributedText.string){
            linkedText = String(fullAttributedText.string[range])
        }
        linkHandler?(URL,linkedText)
        return linkHandler == nil
    }
}
