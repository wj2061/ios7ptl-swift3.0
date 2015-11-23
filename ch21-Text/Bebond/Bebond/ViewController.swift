//
//  ViewController.swift
//  Bebond
//
//  Created by WJ on 15/11/23.
//  Copyright © 2015年 wj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let string = "Be Bold! And a little color wouldn’t hurt either."
        let attr = [NSFontAttributeName: UIFont.systemFontOfSize(36)]
        
        let  at = NSMutableAttributedString(string: string, attributes: attr)
        at.addAttribute(NSFontAttributeName,
            value: UIFont.boldSystemFontOfSize(36),
            range: (string as NSString).rangeOfString("Bold!"))
        
        at.addAttribute(NSForegroundColorAttributeName,
            value: UIColor.blueColor(),
            range: (string as NSString).rangeOfString("little color"))
        
        at.addAttribute(NSFontAttributeName,
            value: UIFont.systemFontOfSize(18),
            range: (string as NSString).rangeOfString("little"))
        
        at.addAttribute(NSFontAttributeName,
            value: UIFont(name: "Papyrus", size: 36)!,
            range: (string as NSString).rangeOfString("color"))
        
        label.attributedText = at
    }



    @IBAction func toggleItalic(sender: UIButton) {
        let at = NSMutableAttributedString(attributedString:label.attributedText!)
        at.enumerateAttribute(NSFontAttributeName,
            inRange: NSMakeRange(0,at.length),
            options: NSAttributedStringEnumerationOptions.LongestEffectiveRangeNotRequired)
            { (value , range , stop ) -> Void in
                if let font = value as? UIFont{
                    let descriptor = font.fontDescriptor()
                    let traits = descriptor.symbolicTraits.union(UIFontDescriptorSymbolicTraits.TraitItalic)
                    let toggledDescriptor = descriptor.fontDescriptorWithSymbolicTraits(traits)
                    
                    let italicFont = UIFont(descriptor: toggledDescriptor, size: 0)
                    if italicFont.pointSize != 0{
                        print(italicFont.pointSize)
                        at.addAttribute(NSFontAttributeName,
                            value: italicFont,
                            range: range  )
                    }
                }
        }
        label.attributedText = at
    }

}

