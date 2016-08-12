# iOS-grayscale-sample

This sample demonstrates how to get raw pixel data as array from UIImage, make the data grayscale, and put the data back in UIImage in Swift. 

このサンプルはUIImageのピクセルデータを直接操作します。一例として取得したデータをグレイスケールに変換してUIImageに戻しています。

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

![Screenshot](https://github.com/ueda-keisuke/iOS-grayscale-sample/blob/image/screenshot.png "Screenshot")
