//
//  ORBar.m
//  Ordenamiento
//
//  Created by Omar Gudino on 9/3/12.
//  Copyright (c) 2012 Omar Gudino. All rights reserved.
//

#import "ORBarView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ORBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ORBarView *barView;
    
    barView = [ORBarView barViewWithFrame:self.frame];
    barView.currentPosition = self.currentPosition;
    barView.layer.borderColor = self.layer.borderColor;
    barView.layer.borderWidth = self.layer.borderWidth;
    barView.backgroundColor = self.backgroundColor;
    
    return barView;
}

+ (id)barViewWithFrame:(CGRect)frame
{
    return [[ORBarView alloc] initWithFrame:frame];
}

#pragma mark - Public Methods
- (NSInteger)barHeight
{
    return self.frame.size.height;
}


@end
