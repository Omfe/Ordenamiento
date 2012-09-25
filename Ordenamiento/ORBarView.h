//
//  ORBar.h
//  Ordenamiento
//
//  Created by Omar Gudino on 9/3/12.
//  Copyright (c) 2012 Omar Gudino. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ORBarView : UIView <NSCopying>

@property (assign, nonatomic) NSInteger currentPosition;

+ (id)barViewWithFrame:(CGRect)frame;
- (NSInteger)barHeight;

@end
