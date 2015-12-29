/*

//  BackgroundAudioPlayer.h

Copyright 2015 Pralancer. All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/

import UIKit
import CoreImage

/** 
Set of UIImage extensions to get different kinds of images from a existing UIImage
*/
extension UIImage
{
    /** This is the default blur radius used wherever required */
    var defaultBlurRadius:CGFloat {
        return 8
    }
    
    /** Private function that draws the inner shadown */
    private func drawInnerShadowInContext(context:CGContextRef, path:CGPathRef, shadowColor:CGColorRef, offset:CGSize, blurRadius:CGFloat)
    {
        CGContextSaveGState(context);
        
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        let opaqueShadowColor:CGColorRef = CGColorCreateCopyWithAlpha(shadowColor, 1.0)!
        
        CGContextSetAlpha(context, CGColorGetAlpha(shadowColor));
        CGContextBeginTransparencyLayer(context, nil);
        CGContextSetShadowWithColor(context, offset, blurRadius, opaqueShadowColor);
        CGContextSetBlendMode(context, CGBlendMode.SourceOut);
        CGContextSetFillColorWithColor(context, opaqueShadowColor);
        CGContextAddPath(context, path);
        CGContextFillPath(context);
        CGContextEndTransparencyLayer(context);
        
        CGContextRestoreGState(context);
    }
    
    /** Returns a rounded area of the original image based on the radius passed to this function. If the radius is more
     * than the minimum dimension (width or height) then the radius is automatically set to half the minimum dimension
     so that the maximum circular area is covered. If its lesser then the specified radius is used.
     
     @param radius : Radius of the new image. Its also the square size of the new image
     @param withShadow: If you want the inner shadow on the image
     @borderThickness: If you want a border around the image specify a value greater than 0
     @borderColor: Color of the border
     
    */
    func roundedImageWithRadius(radius:CGFloat, withShadow:Bool=true, shadowColor:UIColor=UIColor.blackColor(), borderThickness:CGFloat=0.0, borderColor:UIColor = UIColor.whiteColor()) -> UIImage!
    {
        //actual size of the image is a square twice the radius
        let diameter = radius * 2
        
        //create a new image context with a square of specified radius
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(diameter, diameter), false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        //calculate the smaller dimension of the image to ensure that radius is within the size of the image
        let halfOfsmallerDimension = (self.size.width > self.size.height ? self.size.height : self.size.width)/2.0
        var radius1:CGFloat = 0.0
        radius1 = radius > halfOfsmallerDimension ? halfOfsmallerDimension : radius //if the input radius is greater than the smallest dimension then use the samller dimension as the radius

        //determine the area of the image to draw from the center of the image
        let rectOfImageToDraw = CGRectMake(self.size.width*self.scale/2.0-radius1, self.size.height*self.scale/2.0-radius1, radius1*2, radius1*2)
        //extract the square part of the image from the center
        let subimage = CGImageCreateWithImageInRect(self.CGImage, rectOfImageToDraw)

        //create a circular clip area of diameter size
        let imageRect = CGRectMake(0, 0, diameter, diameter)
        let oval = UIBezierPath(ovalInRect: imageRect)
        oval.addClip()
        
        //Context has bottom left as origin. So translate. Otherwise the image will be flipped
        CGContextTranslateCTM(context, 0, CGFloat(CGImageGetHeight(subimage)))
        CGContextScaleCTM(context, 1, -1)
        
        //draw that part of the image into the context
        CGContextDrawImage(context, imageRect, subimage)

        //if we have a border then draw it
        if borderThickness > 1
        {
            CGContextSetLineWidth(context, borderThickness)
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor)
            CGContextStrokeEllipseInRect(context, imageRect)
        }
        
        //if we have a shadow then draw the shadow
        if withShadow
        {
            //round shadow
            let shadowOffset = CGSizeMake(borderThickness/2, borderThickness/2)
            let shadowOval = UIBezierPath(ovalInRect: CGRectInset(imageRect, shadowOffset.width, shadowOffset.height))
            drawInnerShadowInContext(context, path: shadowOval.CGPath, shadowColor: shadowColor.CGColor, offset: CGSizeZero, blurRadius: defaultBlurRadius)
        }
        
        //extract the image and return it
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /*** This function returns the rounded image using the minimum dimension as the diameter of the circle.
        @param withShadow: If you want the inner shadow on the image.
        @borderThickness: If you want a border around the image specify a value greater than 0
        @borderColor: Color of the border
    */
    func roundedImage(withShadow:Bool=true, shadowColor:UIColor = UIColor.blackColor(), borderThickness:CGFloat=0.0, borderColor:UIColor = UIColor.redColor()) -> UIImage!
    {
        let halfOfsmallerDimension = (self.size.width > self.size.height ? self.size.height : self.size.width)/2.0
        return roundedImageWithRadius(halfOfsmallerDimension, withShadow: withShadow, shadowColor:shadowColor, borderThickness: borderThickness, borderColor: borderColor)
    }

    /** This function returns an image with darkened borders around the edges that creates a depth for the image */
    func innerShadowedImage() -> UIImage!
    {
        let imageRect = CGRectMake(0, 0, self.size.width, self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 0, self.size.height)
        CGContextScaleCTM(UIGraphicsGetCurrentContext(), 1, -1)
        CGContextDrawImage(UIGraphicsGetCurrentContext(), imageRect, self.CGImage)
        let shadowRect = CGRectInset(imageRect, 0, 0)
        drawInnerShadowInContext(UIGraphicsGetCurrentContext()!, path: UIBezierPath(rect: shadowRect).CGPath, shadowColor: UIColor.blackColor().CGColor, offset: CGSizeZero, blurRadius: 8)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

}
