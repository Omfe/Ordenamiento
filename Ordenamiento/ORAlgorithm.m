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
NSString *ORMergeSortAlgorithmName = @"Merge Sort";

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
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self startBubbleSort];
        });
    } else if ([_algorithmName isEqualToString:ORSelectionSortAlgorithmName]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self startSelectionSort];
        });
    } else if ([_algorithmName isEqualToString:ORInsertionSortAlgorithmName]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self startInsertionSort];
        });
    } else if ([_algorithmName isEqualToString:ORShellSortAlgorithmName]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self startShellSort];
        });
    } else if ([_algorithmName isEqualToString:ORMergeSortAlgorithmName]) {
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            [self startMergeSort];
        });
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
    
    didSwap = YES;
    
    while (didSwap) {
        didSwap = NO;
        for (NSInteger i = 0; i < self.barsArray.count - 1; i++) {
            currentBarView = [self.barsArray objectAtIndex:i];
            nextBarView = [self.barsArray objectAtIndex:i + 1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate algorithm:self didSelectBar:currentBarView];
            });
            sleep(1);
            if (currentBarView.barHeight > nextBarView.barHeight) {
                didSwap = YES;
                [self.barsArray exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                currentBarView.currentPosition = i+1;
                nextBarView.currentPosition = i;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate algorithm:self swappedBar:currentBarView withBar:nextBarView];
                });
                sleep(1);
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopSorting];
    });
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
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate algorithm:self didSelectBar:shortestBarView];
        });
        sleep(1);
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate algorithm:self swappedBar:shortestBarView withBar:originalShortestBarView];
            });
            sleep(1);
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopSorting];
    });
}

- (void)startInsertionSort
{
    ORBarView *currentBarView;
    ORBarView *comparingBarView;
    NSInteger currentBarViewIndex;
    NSInteger comparingBarViewIndex;
    
    for (int i = 1; i < self.barsArray.count; i++) {
        currentBarView = [self.barsArray objectAtIndex:i];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate algorithm:self didSelectBar:currentBarView];
        });
        sleep(1);
        
        for (int j = i; j > 0; j--) {
            comparingBarView = [self.barsArray objectAtIndex:j - 1];
            if (comparingBarView.barHeight > currentBarView.barHeight) {
                currentBarViewIndex = [self.barsArray indexOfObject:currentBarView];
                comparingBarViewIndex = [self.barsArray indexOfObject:comparingBarView];
                [self.barsArray exchangeObjectAtIndex:currentBarViewIndex withObjectAtIndex:comparingBarViewIndex];
                currentBarView.currentPosition = comparingBarViewIndex;
                comparingBarView.currentPosition = currentBarViewIndex;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate algorithm:self swappedBar:currentBarView withBar:comparingBarView];
                });
                sleep(1);
            }
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopSorting];
    });
}

- (void)startShellSort
{
    NSInteger gap;
    NSInteger j;
    ORBarView *currentBarView;
    ORBarView *jBarView;
    ORBarView *jGapBarView;
    
    gap = self.barsArray.count / 2;
    
    while (gap > 0) {
        for (NSInteger i = gap; i < self.barsArray.count; i++) {
            currentBarView = [self.barsArray objectAtIndex:i];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate algorithm:self didSelectBar:currentBarView];
            });
            sleep(1);
            
            for (j = i - gap; j >= 0; j -= gap) {
                jBarView = [self.barsArray objectAtIndex:j];
                if (jBarView.barHeight <= currentBarView.barHeight) {
                    break;
                }
                
                jGapBarView = [self.barsArray objectAtIndex:j+gap];
                [self.barsArray exchangeObjectAtIndex:j+gap withObjectAtIndex:j];
                jBarView.currentPosition = j + gap;
                jGapBarView.currentPosition = j;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate algorithm:self swappedBar:jBarView withBar:jGapBarView];
                });
                sleep(1);
            }
        }
        gap = gap / 2;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopSorting];
    });
}

- (void)startMergeSort
{
    NSInteger width;
    NSInteger i;
    
    for (width = 1; width < self.barsArray.count; width = 2 * width) {
        for (i = 0; i < self.barsArray.count; i = i + 2 * width) {
            [self mergeArrayWithLeftIndex:i rightIndex:MIN(i + width, self.barsArray.count) endIndex:MIN(i + 2 * width, self.barsArray.count)];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopSorting];
    });
}

- (void)mergeArrayWithLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex endIndex:(NSInteger)endIndex
{
    NSInteger left;
    NSInteger right;
    ORBarView *leftBarView;
    ORBarView *rightBarView;
    NSMutableArray *newArray;
    ORBarView *newBar;
    ORBarView *oldBar;
    NSInteger newIndex;
    NSInteger oldIndex;
    
    left = leftIndex;
    right = rightIndex;
    newArray = [NSMutableArray array];
    for (NSInteger j = leftIndex; j < endIndex; j++) {
        if (right >= self.barsArray.count) {
            continue;
        }
        
        leftBarView = [self.barsArray objectAtIndex:left];
        rightBarView = [self.barsArray objectAtIndex:right];
        
        if (left < rightIndex && (right >= endIndex || leftBarView.barHeight <= rightBarView.barHeight)) {
            [newArray addObject:leftBarView];
            left = left + 1;
        } else {
            [newArray addObject:rightBarView];
            right = right + 1;
        }
    }
    
    oldIndex = leftIndex;
    for (NSInteger i = 0; i < newArray.count; i++) {
        newBar = [newArray objectAtIndex:i];
        oldBar = [self.barsArray objectAtIndex:oldIndex];
        newIndex = [self.barsArray indexOfObject:newBar];
        
        if (newBar == oldBar) {
            oldIndex++;
            continue;
        }
        
        [self.barsArray exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
        
        newBar.currentPosition = oldIndex;
        oldBar.currentPosition = newIndex;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate algorithm:self didSelectBar:newBar];
            [self.delegate algorithm:self swappedBar:newBar withBar:oldBar];
        });
        sleep(1);
        oldIndex++;
    }
}

@end
