//
//  DDProgressView.m
//  DDProgressView
//
//  Created by Damien DeVille on 3/13/11.
//  Copyright 2011 Snappy Code. All rights reserved.
//

#import "DDProgressView.h"

#define kDefaultProgressBarHeight   22.0f
#define kProgressBarWidth           160.0f

@implementation DDProgressView

@synthesize innerColor ;
@synthesize outerColor ;
@synthesize emptyColor ;
@synthesize progress ;
@synthesize preferredFrameHeight ;

- (id)init
{
	return [self initWithFrame: CGRectZero] ;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame: frame] ;
	if (self)
	{
		self.backgroundColor = [UIColor clearColor] ;
		self.innerColor = [UIColor lightGrayColor] ;
		self.outerColor = [UIColor lightGrayColor] ;
		self.emptyColor = [UIColor clearColor] ;
        self.preferredFrameHeight = kDefaultProgressBarHeight;
		if (frame.size.width == 0.0f)
			frame.size.width = kProgressBarWidth ;
	}
	return self ;
}


- (void)setProgress:(float)theProgress
{
	// make sure the user does not try to set the progress outside of the bounds
	if (theProgress > 1.0f)
		theProgress = 1.0f ;
	if (theProgress < 0.0f)
		theProgress = 0.0f ;
	
	progress = theProgress ;
	[self setNeedsDisplay] ;
}

- (void)setCacheProgress:(float)cacheProgress {
    // make sure the user does not try to set the progress outside of the bounds
    if (cacheProgress > 1.0f)
        cacheProgress = 1.0f ;
    if (cacheProgress < 0.0f)
        cacheProgress = 0.0f ;
    
    _cacheProgress = cacheProgress ;
    [self setNeedsDisplay] ;
}


- (void)setFrame:(CGRect)frame
{
	// we set the height ourselves since it is fixed
	frame.size.height = self.preferredFrameHeight ;
	[super setFrame: frame] ;
}

- (void)setBounds:(CGRect)bounds
{
	// we set the height ourselves since it is fixed
	bounds.size.height = self.preferredFrameHeight ;
	[super setBounds: bounds] ;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext() ;
	
	// save the context
	CGContextSaveGState(context) ;
	
	// allow antialiasing
	CGContextSetAllowsAntialiasing(context, TRUE) ;
	
	// we first draw the outter rounded rectangle
	rect = CGRectInset(rect, 1.0f, 1.0f) ;
	CGFloat radius = 0.5f * rect.size.height ;
//
	[outerColor setFill] ;
	CGContextSetLineWidth(context, 2.0f) ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
    CGContextFillPath(context) ;
    
    // draw the empty rounded rectangle (shown for the "unfilled" portions of the progress
    CGRect   cacherect = CGRectInset(rect, 1.0f, 1.0f) ;
	radius = 0.5f * cacherect.size.height ;
    cacherect.size.width *= _cacheProgress ;
    if (cacherect.size.width < 2 * radius)
        cacherect.size.width = 2 * radius ;
    if(isnan(rect.size.width)){
        cacherect.size.width = 14;
    }
    
	[emptyColor setFill] ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(cacherect), CGRectGetMidY(cacherect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(cacherect), CGRectGetMinY(cacherect), CGRectGetMidX(cacherect), CGRectGetMinY(cacherect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(cacherect), CGRectGetMinY(cacherect), CGRectGetMaxX(cacherect), CGRectGetMidY(cacherect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(cacherect), CGRectGetMaxY(cacherect), CGRectGetMidX(cacherect), CGRectGetMaxY(cacherect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(cacherect), CGRectGetMaxY(cacherect), CGRectGetMinX(cacherect), CGRectGetMidY(cacherect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
    
	// draw the inside moving filled rounded rectangle
//    当前播放进度
	radius = 0.5f * rect.size.height ;
    rect = CGRectInset(rect, 3.0f, 3.0f) ;

	// make sure the filled rounded rectangle is not smaller than 2 times the radius
	rect.size.width *= progress ;
	if (rect.size.width < 2 * radius)
		rect.size.width = 2 * radius ;
	if(isnan(rect.size.width)){
		rect.size.width = 14;
	}
	[innerColor setFill] ;
	
	CGContextBeginPath(context) ;
	CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMidY(rect)) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMidX(rect), CGRectGetMinY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMidY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMidX(rect), CGRectGetMaxY(rect), radius) ;
	CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMidY(rect), radius) ;
	CGContextClosePath(context) ;
	CGContextFillPath(context) ;
	
	// restore the context
	CGContextRestoreGState(context) ;
}

@end
