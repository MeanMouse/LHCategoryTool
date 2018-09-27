//
//  UIImage+LHTool.m
//  LHCategoryTool
//
//  Created by 梁辉 on 2018/4/16.
//  Copyright © 2018年 ElonZung. All rights reserved.
//

#import "UIImage+LHTool.h"

@implementation UIImage (LHTool)

/**
 *  图片切圆
 */
- (UIImage *)corner
{
    return [self scaleImageToSize:self.size cornerRadius:self.size.width/2.f];
}

/**
 *  @brief 按size比例图片缩放
 *  @param size 目标尺寸
 */
- (UIImage *)scaleImageToSize:(CGSize)size
{
    return [self scaleImageToSize:size cornerRadius:0.f];
}

/**
 *  @brief 按size比例图片缩放
 *  @param size 目标尺寸
 *  @param radius 图片圆角
 */
- (UIImage *)scaleImageToSize:(CGSize)size cornerRadius:(CGFloat)radius {
    
    CGSize originImageSize = self.size;
    
    CGRect newRect = CGRectMake(0,0,size.width,size.height);
    
    //根据当前屏幕scaling factor创建一个透明的位图图形上下文(此处不能直接从UIGraphicsGetCurrentContext获取,原因是UIGraphicsGetCurrentContext获取的是上下文栈的顶,在drawRect:方法里栈顶才有数据,其他地方只能获取一个nil.详情看文档)
    
    UIGraphicsBeginImageContextWithOptions(newRect.size,NO,0.0);
    
    //保持宽高比例,确定缩放倍数
    
    //(原图的宽高做分母,导致大的结果比例更小,做MAX后,ratio*原图长宽得到的值最小是40,最大则比40大,这样的好处是可以让原图在画进40*40的缩略矩形画布时,origin可以取=(缩略矩形长宽减原图长宽*ratio)/2 ,这样可以得到一个可能包含负数的origin,结合缩放的原图长宽size之后,最终原图缩小后的缩略图中央刚好可以对准缩略矩形画布中央)
    
    float ratio = MAX(newRect.size.width/ originImageSize.width, newRect.size.height/ originImageSize.height);
    
    //创建一个圆角的矩形UIBezierPath对象
    
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newRect cornerRadius:radius];
    
    //用Bezier对象裁剪上下文
    
    [path addClip];
    
    //让image在缩略图范围内居中()
    
    CGRect projectRect;
    
    projectRect.size.width= originImageSize.width* ratio;
    
    projectRect.size.height= originImageSize.height* ratio;
    
    projectRect.origin.x= (newRect.size.width- projectRect.size.width) /2;
    
    projectRect.origin.y= (newRect.size.height- projectRect.size.height) /2;
    
    //在上下文中画图
    
    [self drawInRect:projectRect];
    
    //从图形上下文获取到UIImage对象,赋值给thumbnai属性
    
    UIImage * smallImg =UIGraphicsGetImageFromCurrentImageContext();

    
    //清理图形上下文(用了UIGraphicsBeginImageContext需要清理)
    
    UIGraphicsEndImageContext();
    return smallImg;
    
}

/**
 *  @brief 按指定位置大小裁剪图片
 *  @param clipRect 指定位置
 */
- (UIImage *)clipWithRect:(CGRect)clipRect
{
    
    UIImage *imageTemp = [self fixOrientation];
    CGImageRef clipRef = CGImageCreateWithImageInRect([imageTemp CGImage], clipRect);
    UIImage *clipImage = [UIImage imageWithCGImage:clipRef];
    CGImageRelease(clipRef);
    return clipImage;
}

/**
 *  @brief 按指定压缩率压缩图片
 *  @param quality  指定压缩率 （质量最差）0-1（质量最高）
 */
- (UIImage *)compressWithQuality:(CGFloat)quality
{
    
    NSData *imageData = UIImageJPEGRepresentation(self, quality);
    UIImage *compressImage =[UIImage imageWithData:imageData];
    return compressImage;
}

/**
 *用相机拍摄出来的照片含有EXIF信息，UIImage的imageOrientation属性指的就是EXIF中的orientation信息。
 *如果我们忽略orientation信息，而直接对照片进行像素处理或者drawInRect等操作，得到的结果是翻转或者旋转90之后的样子。这是因为我们执行像素处理或者drawInRect等操作之后，imageOrientaion信息被删除了，imageOrientaion被重设为0，造成照片内容和imageOrientaion不匹配。
 所以，在对照片进行处理之前，先将照片旋转到正确的方向，并且返回的imageOrientaion为0。
 * 修正拍摄产生的图片的方向
 */
- (UIImage *)fixOrientation {
    
    UIImage *aImage = self;
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *  @brief 创建纯色图片
 *  @param imageSize  图片尺寸
 */
+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)imageSize;
{
    CGRect rect = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
