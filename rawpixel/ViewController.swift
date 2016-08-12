//
//  ViewController.swift
//  rawpixel
//
//  Created by keta on 2016/08/12.
//  Copyright © 2016年 keta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        image.image = UIImage(named: "cat")
    }


    @IBAction func click(sender: UIButton) {
        
        var data = intensityValuesFromImage(image.image)
        
//        for( var count = 0; count < data.width * data.height * 4; count += 4 )
        0.stride(to: data.width * data.height * 4, by: 4).forEach
        {
            let count = $0
            let r = Double(data.pixelValues![count + 0])
            let g = Double(data.pixelValues![count + 1])
            let b = Double(data.pixelValues![count + 2])
            let a = Double(data.pixelValues![count + 3])
            
            let gray = 0.2989 * r + 0.5870 * g + 0.1140 * b
            
            data.pixelValues![count + 0] = UInt8(gray)
            data.pixelValues![count + 1] = UInt8(gray)
            data.pixelValues![count + 2] = UInt8(gray)
            data.pixelValues![count + 3] = UInt8(a)
            
        }
        
        if let pixelValues = data.pixelValues
        {
            let img = imageFromRGBA32Bitmap(pixelValues, width: data.width, height: data.height)
            image.image = img
        }
    }
    
    
    @IBAction func reload(sender: AnyObject) {
        image.image = UIImage(named: "cat")
    }
    
    func intensityValuesFromImage(image: UIImage?) -> (pixelValues: [UInt8]?, width: Int, height: Int)
    {
        var width = 0
        var height = 0
        var pixelValues: [UInt8]?
        if (image != nil) {
            let imageRef = image!.CGImage
            width = CGImageGetWidth(imageRef)
            height = CGImageGetHeight(imageRef)
            
            let bytesPerPixel = 4
            let bytesPerRow = bytesPerPixel * width
            let bitsPerComponent = 8
            let totalBytes = width * height * bytesPerPixel
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            pixelValues = [UInt8](count: totalBytes, repeatedValue: 0)
            
            let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.ByteOrder32Big.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue)
            let contextRef = CGBitmapContextCreate(&pixelValues!, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo.rawValue)
            CGContextDrawImage(contextRef, CGRectMake(0.0, 0.0, CGFloat(width), CGFloat(height)), imageRef)
        }
        
        return (pixelValues, width, height)
    }
    
    func imageFromRGBA32Bitmap(pixels:[UInt8], width:Int, height:Int)-> UIImage? {
        let bitsPerComponent: Int = 8
        let bitsPerPixel: Int = 32
        let bpp = 4
        
        assert(pixels.count == Int(width * height) * bpp)
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof([UInt8]))
        )
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo.ByteOrder32Big.rawValue | CGImageAlphaInfo.PremultipliedLast.rawValue)
        let cgim = CGImageCreate(
            width,
            height,
            bitsPerComponent,
            bitsPerPixel,
            width * bpp,
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            nil,
            true,
            CGColorRenderingIntent.RenderingIntentDefault
        )
        if (cgim != nil) {
            return UIImage(CGImage: cgim!)
        }
        return nil
    }
}

