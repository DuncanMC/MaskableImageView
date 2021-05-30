## MaskableImageView


This project demonstrates how to use a `CALayer` to mask a `UIView`.

It defines a custom subclass of UIImageView, `MaskableView`.

The `MaskableView ` class has a property `maskLayer` that contains a CALayer. 

`MaskableView ` defines a `didSet` method on its `bounds` property so that when the view's bounds change, it resizes the mask layer to match the size of the image view.

The `MaskableView ` has a method `installSampleMask` which builds an image the same size as the image view, mostly filled with opaque black, but with a small rectangle in the center filled with black at an alpha of 0.7. The translucent center rectangle causes the image view to become partly transparent and show the view underneath.

The demo app installs a couple of subviews into the `MaskableView`, a sample image of Scampers, one of my dogs, and a UILabel. It also installs an image of a checkerboard under the `MaskableView ` so that you can see the translucent parts more easily.

The next step will be to add an option to add an eraser/un-eraser tool to the app. The eraser tool would draw with clear into the mask image, masking pixels in picture, and the un-eraser would draw with black (or any other opaque color) which would reveal pixels in the image view. 

The app's screen looks like this:


![](MaskableImageView.png)