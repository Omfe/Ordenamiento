//
//  ORAlgorithmManager.m
//  Ordenamiento
//
//  Created by Omar Gudino on 9/3/12.
//  Copyright (c) 2012 Omar Gudino. All rights reserved.
//

#import "ORAlgorithmManager.h"
#import "ORAlgorithm.h"

@implementation ORAlgorithmManager


- (id)init
{
    ORAlgorithm *bubbleAlgorithm;
    ORAlgorithm *selectionAlgorithm;
    ORAlgorithm *insertionAlgorithm;
    ORAlgorithm *shellSortAlgorithm;
    
    self = [super init];
    if (self) {
        bubbleAlgorithm = [[ORAlgorithm alloc] initWithAlgorithmName:ORBubbleSortAlgorithmName];
        selectionAlgorithm = [[ORAlgorithm alloc] initWithAlgorithmName:ORSelectionSortAlgorithmName];
        insertionAlgorithm = [[ORAlgorithm alloc] initWithAlgorithmName:ORInsertionSortAlgorithmName];
        shellSortAlgorithm = [[ORAlgorithm alloc] initWithAlgorithmName:ORShellSortAlgorithmName];
        _algorithmsArray = @[ bubbleAlgorithm, selectionAlgorithm, insertionAlgorithm, shellSortAlgorithm ];
        self.currentAlgorithm = [_algorithmsArray objectAtIndex:0];
    }
    return self;
    
}

@end
