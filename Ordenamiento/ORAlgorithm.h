//
//  ORAlgorithm.h
//  Ordenamiento
//
//  Created by Omar Gudino on 9/3/12.
//  Copyright (c) 2012 Omar Gudino. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ORAlgorithm;
@class ORBarView;

extern NSString *ORBubbleSortAlgorithmName;
extern NSString *ORSelectionSortAlgorithmName;
extern NSString *ORInsertionSortAlgorithmName;
extern NSString *ORShellSortAlgorithmName;
extern NSString *ORMergeSortAlgorithmName;

@protocol ORAlgorithmDelegate <NSObject>

@required
- (void)algorithmHasStoppedSorting:(ORAlgorithm *)algorithm;
- (void)algorithm:(ORAlgorithm *)algorithm didSelectBar:(ORBarView *)bar;
- (void)algorithm:(ORAlgorithm *)algorithm swappedBar:(ORBarView *)bar withBar:(ORBarView *)oldBar;

@end

@interface ORAlgorithm : NSObject

@property (strong, nonatomic, readonly) NSString *algorithmName;
@property (assign, nonatomic, readonly) NSInteger sortingTime;
@property (assign, nonatomic, readonly) NSInteger lastSortNumberOfBars;
@property (assign, nonatomic) id<ORAlgorithmDelegate> delegate;

- (id)initWithAlgorithmName:(NSString *)algorithmName;
- (void)starSortingBarsArray:(NSMutableArray *)barsArray;
- (void)stopSorting;

@end
