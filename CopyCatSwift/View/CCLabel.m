//
//  CCLabel.m
//  CameraOverlay
//
//  Created by Baiqi Zhang on 7/16/15.
//  Copyright (c) 2015 Baiqi Zhang. All rights reserved.
//

#import "CCLabel.h"
#import <CoreText/CoreText.h>

@implementation CCLabel

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Prepare font
    CTFontRef ctfont = CTFontCreateWithName( (__bridge CFStringRef)self.font.fontName, self.font.pointSize, nil);
    CGColorRef ctColor = [[UIColor clearColor] CGColor];//[[UIColor whiteColor] CGColor];
    CGFloat number = 0.5;//[NSLocalizedString(@"FontSpacing", nil)intValue];
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberCGFloatType,&number);

    // Create an attributed string
    CFStringRef keys[] = { kCTFontAttributeName,kCTForegroundColorAttributeName,kCTKernAttributeName};
    CFTypeRef values[] = { ctfont,ctColor,num};
    CFDictionaryRef attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFStringRef ctStr = CFStringCreateWithCString(nil, [self.text UTF8String], kCFStringEncodingUTF8);
    CFAttributedStringRef attrString = CFAttributedStringCreate(NULL,ctStr, attr);
    CTLineRef line = CTLineCreateWithAttributedString(attrString);

    CGContextSetTextMatrix(context, CGAffineTransformScale(CGAffineTransformIdentity, 0.8f, -1.f ));
    
    CGPoint p =CGContextGetTextPosition(context);
    float centeredY = (self.font.pointSize + (self.frame.size.height- self.font.pointSize)/2)-2;

    CGContextSetTextPosition(context, 0, centeredY);
    CTLineDraw(line, context);
    
    CFRelease(line);
    CFRelease(attrString);
    CFRelease(ctStr);
    
    // calculate width and draw shadow.
    CGPoint v =CGContextGetTextPosition(context);
    float width = v.x - p.x;
    float centeredX =(self.frame.size.width- width)/2;
    
    ctColor = [[UIColor colorWithWhite:0.4 alpha:1] CGColor];
    values[1] = ctColor;
    attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    ctStr = CFStringCreateWithCString(nil, [self.text UTF8String], kCFStringEncodingUTF8);
    attrString = CFAttributedStringCreate(NULL,ctStr, attr);
    line = CTLineCreateWithAttributedString(attrString);

    CGContextSetTextPosition(context, centeredX+1.5, centeredY+1.5);
    CTLineDraw(line, context);

    CFRelease(line);
    CFRelease(attrString);
    CFRelease(ctStr);

    // Draw Real Text
    ctColor = [[UIColor whiteColor] CGColor];
    values[1] = ctColor;
    attr = CFDictionaryCreate(NULL, (const void **)&keys, (const void **)&values,
                              sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    ctStr = CFStringCreateWithCString(nil, [self.text UTF8String], kCFStringEncodingUTF8);
    attrString = CFAttributedStringCreate(NULL,ctStr, attr);
    line = CTLineCreateWithAttributedString(attrString);
    
    CGContextSetTextPosition(context, centeredX, centeredY);
    CTLineDraw(line, context);
    
    CFRelease(line);
    CFRelease(attrString);
    CFRelease(ctStr);

    // Clean up
    CFRelease(num);
    CFRelease(attr);
    CFRelease(ctfont);
    
}
@end
