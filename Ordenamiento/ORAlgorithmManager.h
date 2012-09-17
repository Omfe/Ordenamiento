//
//  ORAlgorithmManager.h
//  Ordenamiento
//
//  Created by Omar Gudino on 9/3/12.
//  Copyright (c) 2012 Omar Gudino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORAlgorithm;
@interface ORAlgorithmManager : NSObject

@property (strong, nonatomic, readonly) NSArray *algorithmsArray;
@property (strong, nonatomic) ORAlgorithm *currentAlgorithm;

@end
