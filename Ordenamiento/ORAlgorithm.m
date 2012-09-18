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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate algorithm:self didSelectBar:currentBarView andDidDeselectBar:previousBarView];
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
            previousBarView = currentBarView;
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
            [self.delegate algorithm:self didSelectBar:shortestBarView andDidDeselectBar:originalShortestBarView];
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
   /* NSInteger emptySpace;
    ORBarView *currentBarView;
    ORBarView *previousBarView;
    ORBarView *nextPreviousBarView;
    NSInteger firstPosition;
    NSInteger secondPosition;
    
    for (NSInteger i = 1; i < self.barsArray.count - 1; i++) {
        currentBarView = [self.barsArray objectAtIndex:i];
        emptySpace = i;
        nextPreviousBarView = [self.barsArray objectAtIndex:emptySpace-1];
        previousBarView = [self.barsArray objectAtIndex:emptySpace];
        
        while (nextPreviousBarView.barHeight > currentBarView.barHeight) {
            previousBarView = [self.barsArray objectAtIndex:emptySpace-1];
            emptySpace = emptySpace - 1;
            if (emptySpace < 1) {
                break;
            }
            nextPreviousBarView = [self.barsArray objectAtIndex:emptySpace -1];
        }
        
        firstPosition = [self.barsArray indexOfObject:previousBarView];
        secondPosition = [self.barsArray indexOfObject:currentBarView];
        
        [self.barsArray exchangeObjectAtIndex:firstPosition withObjectAtIndex:secondPosition];
        currentBarView.currentPosition = firstPosition;
        previousBarView.currentPosition = secondPosition;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate algorithm:self swappedBar:currentBarView withBar:previousBarView];
        });
        sleep(1);

        
    }
    */
    ORBarView *currentBarView;
    ORBarView *previousBarView;
    NSInteger i;
    NSInteger j;
    NSInteger currentIndex;
    
    for (i = 1; i < self.barsArray.count; i++) {
        currentBarView = [self.barsArray objectAtIndex:i];
        
        for (j = i; j > 0 && ((ORBarView *)[self.barsArray objectAtIndex:0]).barHeight > currentBarView.barHeight ; j--) {
            [self.barsArray exchangeObjectAtIndex:j withObjectAtIndex:j-1];
            currentBarView.currentPosition = j-1;
            previousBarView.currentPosition = j;
            [self.delegate algorithm:self swappedBar:currentBarView withBar:previousBarView];
            }
        
        currentIndex = [self.barsArray indexOfObject:currentBarView];
        previousBarView = [self.barsArray objectAtIndex:j];
        [self.barsArray exchangeObjectAtIndex:j withObjectAtIndex:currentIndex];
        currentBarView.currentPosition = currentIndex;
        previousBarView.currentPosition = j;
        [self.delegate algorithm:self swappedBar:currentBarView withBar:previousBarView];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopSorting];
    });
}

- (void)startShellSort
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopSorting];
    });
}

@end
