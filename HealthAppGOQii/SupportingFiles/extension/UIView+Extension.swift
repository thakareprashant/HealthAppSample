//
//  UIView+Extension.swift
//  HealthAppGOQii
//
//  Created by Apple on 26/03/24.
//

import Foundation
import UIKit
extension UIView{
    
    
    func addCornerRadiusWithBorder(borderWidth:CGFloat,cornerradius:CGFloat,borderHexColorStr:String){
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerradius
        self.layer.borderColor = UIColor(named: borderHexColorStr)?.cgColor
        self.layer.borderWidth = borderWidth
        
        
        
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func applyGradientColorstoView(colourTop: CGColor, colourBottom:CGColor){
        let colorTop =  colourTop//UIColor(red: 207.0/255.0, green: 249.0/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        let colorBottom = colourBottom//UIColor(red: 231.0/255.0, green: 234/255.0, blue: 234.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
        //        gradientLayer.type = .
        self.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    func applyGradientColorstoViewHorizontally(colourTop: CGColor, colourBottom:CGColor){
        let colorTop =  colourTop//UIColor(red: 207.0/255.0, green: 249.0/255.0, blue: 255/255.0, alpha: 1.0).cgColor
        let colorBottom = colourBottom//UIColor(red: 231.0/255.0, green: 234/255.0, blue: 234.0/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // Left side.
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = self.bounds
        //        gradientLayer.type = .
        self.layer.insertSublayer(gradientLayer, at:0)
        
    }
}
