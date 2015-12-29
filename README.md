# UIImageUtils
Set of UIImage extensions to create some modified and shadow images in Swift. This is an extension to the UIImage class to create some images that are rounded and has a inner shadow and a border based on the params you pass to the functions.  It also returns a inner shadowed image of the original image as well.  You use the functions of this extension on a instance of UIImage.

## Functions

```sh
func roundedImageWithRadius(radius:CGFloat, withShadow:Bool=true, shadowColor:UIColor=UIColor.blackColor(), borderThickness:CGFloat=0.0, borderColor:UIColor = UIColor.whiteColor()) -> UIImage!
```
This function will return a rounded image centered on the original image with the specified radius. If the radius is greater than the minimum dimension of the image (width or height depending on whether the image is portrait or landscape) then the minimum dimension will be used as the radius. Otherwise the specified radius will be used. All other parameters have default values which you can override if required.

```sh
func roundedImage(withShadow:Bool=true, shadowColor:UIColor = UIColor.blackColor(), borderThickness:CGFloat=0.0, borderColor:UIColor = UIColor.redColor()) -> UIImage!
```
This is a convenience method to get the center area of the image as a circular image. You can invoke this as *image.roundedImage()* to get a new UIImage instance that contains the circular center area of the original image

```sh
func innerShadowedImage() -> UIImage!
```
This function returns the original image but with a innner shadow. Default params are used internally.

## Sample 

Sample Image created using this extension. The top image is the original image. The second image below it is the roundedImage and the last image is the innerShadowedImage.

![sample](https://cloud.githubusercontent.com/assets/15045249/12038783/dfb1af58-ae80-11e5-8e95-d7ebe795c3cc.png)
