//
//  TopNavigationController.swift
//  CaracasChronicles-iOS
//
//  Created by Alejandro on 1/21/16.
//
//

import UIKit

class TopNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        setNavigationBarColors()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func setNavigationBarColors() {
        self.navigationBar.setBackgroundImage(makeGradientLayerImage(Size.NavigationBarHeight), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.translucent = false
        
        // Remove the bottom border
        self.navigationBar.shadowImage = UIImage()
        
        // Make text white
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func makeGradientLayerImage(height: CGFloat) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, height)
        gradientLayer.colors = [Color.DarkYellow.CGColor, Color.LightYellow.CGColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        // Render the gradient to UIImage
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}