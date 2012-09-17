//
//  ORAlgorithm.m
//  Ordenamiento
//
//  Created by Omar Gudino on 9/3/12.
//  Copyright (c) 2012 Omar Gudino. All rights reserved.
//

#import "ORAlgorithm.h"
#import "ORBarView.h"

NSString *ORBubbleSortAlgorithmName = @"Burbuja";
NSString *ORSelectionSortAlgorithmName = @"Selección";
NSString *ORInsertionSortAlgorithmName = @"Inserción";
NSString *ORShellSortAlgorithmName = @"Shell Sort";

@interface ORAlgorithm ()

@property (strong, nonatomic) NSMutableArray *barsArray;
@property (strong, nonatomic) NSDate *sortingStartTimeDate;

@end


@implementation ORAlgorithm

- (id)initWithAlgorithmName:(NSString *)algorithmName
{
    self = [super init];
    if (self)
    {
        _algorithmName = algorithmName;
    }
    return self;
}

- (id)init
{
    self = [self initWithAlgorithmName:@"omarSorting"];
    return self;
}


#pragma mark - Public Methods
- (void)starSortingBarsArray:(NSMutableArray *)barsArray
{
    self.barsArray = barsArray;
    _lastSortNumberOfBars = self.barsArray.count;
    
    self.sortingStartTimeDate = [NSDate date];
    
    if ([_algorithmName isEqualToString:ORBubbleSortAlgorithmName]) {
        [self startBubbleSort];
    } else if ([_algorithmName isEqualToString:ORSelectionSortAlgorithmName]) {
        [self startSelectionSort];
    } else if ([_algorithmName isEqualToString:ORInsertionSortAlgorithmName]) {
        [self startInsertionSort];
    } else if ([_algorithmName isEqualToString:ORShellSortAlgorithmName]) {
        [self startShellSort];
    }
}

- (void)stopSorting
{
    _sortingTime = [[NSDate date] timeIntervalSinceDate:self.sortingStartTimeDate];
    [self.delegate algorithmHasStoppedSorting:self];
}

#pragma mark - Private Methods
- (void)startBubbleSort
{
    BOOL didSwap;
    ORBarView *currentBarView;
    ORBarView *nextBarView;
    ORBarView *previousBarView;
    
    didSwap = YES;
    
    while (didSwap) {
        didSwap = NO;
        for (NSInteger i = 0; i < self.barsArray.count - 1; i++) {
            currentBarView = [self.barsArray objectAtIndex:i];
            nextBarView = [self.barsArray objectAtIndex:i + 1];
            [self.delegate algorithm:self didSelectBar:currentBarView andDidDeselectBar:previousBarView];
            if (currentBarView.barHeight > nextBarView.barHeight) {
                didSwap = YES;
                [self.barsArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                currentBarView.currentPosition = i+1;
                nextBarView.currentPosition = i;
                [self.delegate algorithm:self swappedBar:currentBarView withBar:nextBarView];
            }
            previousBarView = currentBarView;
        }
    }
    [self stopSorting];
}

- (void)startSelectionSort
{
    ORBarView *barView;
    ORBarView *shortestBarView;
    ORBarView *originalShortestBarView;
    NSInteger firstPosition;
    NSInteger secondPosition;
    
    for (NSInteger i = 0; i < self.barsArray.count - 1; i++) {
        shortestBarView = [self.barsArray objectAtIndex:i];
        [self.delegate algorithm:self didSelectBar:shortestBarView andDidDeselectBar:originalShortestBarView];
        originalShortestBarView = [self.barsArray objectAtIndex:i];
        
        for (NSInteger j = i + 1; j < self.barsArray.count; j++) {
            barView = [self.barsArray objectAtIndex:j];
            if (barView.barHeight < shortestBarView.barHeight) {
                shortestBarView = barView;
            }
        }
        
        if (shortestBarView != originalShortestBarView) {
            firstPosition = [self.barsArray indexOfObject:originalShortestBarView];
            secondPosition = [self.barsArray indexOfObject:shortestBarView];
            
            [self.barsArray exchangeObjectAtIndex:firstPosition withObjectAtIndex:secondPosition];
            shortestBarView.currentPosition = firstPosition;
            originalShortestBarView.currentPosition = secondPosition;
            [self.delegate algorithm:self swappedBar:shortestBarView withBar:originalShortestBarView];
            
        }
    }
    
    [self stopSorting];
}

- (void)startInsertionSort
{
    ORBarView *emptySpace;
    ORBarView *shortestbarView;
    
    for (NSInteger i = 1; i < self.barsArray.count; i++) {
        shortestbarView = [self.barsArray objectAtIndex:i];
        
    }
    
    [self stopSorting];
}

- (void)startShellSort
{
    [self stopSorting];
}



@end
