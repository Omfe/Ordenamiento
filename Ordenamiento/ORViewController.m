//
//  ORViewController.m
//  Ordenamiento
//
//  Created by Omar Gudino on 8/29/12.
//  Copyright (c) 2012 Omar Gudino. All rights reserved.
//

#import "ORViewController.h"
#import "ORAlgorithmManager.h"
#import "ORAlgorithm.h"
#import "ORBarView.h"
#import <QuartzCore/QuartzCore.h>

#define BAR_WIDTH 15

@interface ORViewController () <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ORAlgorithmDelegate>

@property (weak, nonatomic) IBOutlet UITextField *numberOfBarsTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;
@property (weak, nonatomic) IBOutlet UIButton *eraseButton;
@property (weak, nonatomic) IBOutlet UIPickerView *algorithmPickerView;
@property (weak, nonatomic) IBOutlet UITableView *informationTableView;
@property (weak, nonatomic) IBOutlet UIView *barsView;

@property (strong, nonatomic) ORAlgorithmManager *algorithmManager;
@property (strong, nonatomic) NSMutableArray *currentBarsArray;
@property (strong, nonatomic) NSMutableArray *barsArray;

@end

@implementation ORViewController


#pragma mark - View Lifecycle Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.algorithmManager = [[ORAlgorithmManager alloc] init];
    
    for (ORAlgorithm *algorithm in self.algorithmManager.algorithmsArray) {
        algorithm.delegate = self;
    }
    
    self.startButton.hidden = YES;
    self.stopButton.hidden = YES;
    self.eraseButton.hidden = YES;
    self.stopButton.enabled = NO;
}

- (void)viewDidUnload
{
    [self setNumberOfBarsTextField:nil];
    [self setStartButton:nil];
    [self setStopButton:nil];
    [self setGenerateButton:nil];
    [self setAlgorithmPickerView:nil];
    [self setInformationTableView:nil];
    [self setBarsView:nil];
    [self setEraseButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark - UITableViewDataSource/Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.algorithmManager.algorithmsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    ORAlgorithm *algorithm;
    static NSString *identifier = @"InformationTableViewCellIdentifier";
    
    cell = [self.informationTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    algorithm = [self.algorithmManager.algorithmsArray objectAtIndex:indexPath.section];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = algorithm.algorithmName;
            cell.detailTextLabel.text = @"Algorithm Name";
           break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"%i", algorithm.sortingTime];
            cell.detailTextLabel.text = @"Sorting Time";
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"%i", algorithm.lastSortNumberOfBars];
            cell.detailTextLabel.text = @"Number Of Bars";
        default:
            break;
    } 
    
        
    
    return cell;
}


#pragma mark - UIPickerViewDataSource/Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.algorithmManager.algorithmsArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.algorithmManager.currentAlgorithm = [self.algorithmManager.algorithmsArray objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    ORAlgorithm *algorithm;
    
    algorithm = [self.algorithmManager.algorithmsArray objectAtIndex:row];
    return algorithm.algorithmName;
}


#pragma mark - ORAlgorithmDelegate Methods
- (void)algorithmHasStoppedSorting:(ORAlgorithm *)algorithm
{
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
    self.eraseButton.hidden = NO;
    self.generateButton.hidden = NO;
    [self.informationTableView reloadData];
}

- (void)algorithm:(ORAlgorithm *)algorithm didSelectBar:(ORBarView *)bar
{
    for (ORBarView *bar in self.barsArray) {
        bar.layer.borderWidth = 0;
    }
    bar.layer.borderWidth = 4;
    //if (oldBar) {
        //oldBar.layer.borderWidth = 0;
    //}
}

- (void)algorithm:(ORAlgorithm *)algorithm swappedBar:(ORBarView *)bar withBar:(ORBarView *)oldBar
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame;
        
        frame = bar.frame;
        frame.origin.x = [self xOriginForPosition:bar.currentPosition];
        bar.frame = frame;
        
        frame = oldBar.frame;
        frame.origin.x = [self xOriginForPosition:oldBar.currentPosition];
        oldBar.frame = frame;
    }];
}


#pragma mark - IBAction Methods
- (IBAction)startWasPressed:(id)sender
{
    self.startButton.hidden = YES;
    self.stopButton.hidden = NO;
    self.generateButton.hidden = YES;
    self.eraseButton.hidden = YES;
    self.barsArray = [self.currentBarsArray mutableCopy];
    [self clearBarsView];
    [self populateBarsViewWithBarsArray:self.barsArray];
    [self.algorithmManager.currentAlgorithm starSortingBarsArray:self.barsArray];
}

- (IBAction)stopWasPressed:(id)sender
{
    self.generateButton.hidden = NO;
    self.startButton.hidden = NO;
    self.stopButton.hidden = YES;
    self.eraseButton.hidden = NO;
    [self.algorithmManager.currentAlgorithm stopSorting];
}

- (IBAction)generateWasPressed:(id)sender
{
    NSInteger numberOfBars;
    
    self.startButton.hidden = NO;
    self.generateButton.hidden = NO;
    self.eraseButton.hidden = NO;
    
    if (self.numberOfBarsTextField.text.length > 0) {
        numberOfBars = [self.numberOfBarsTextField.text integerValue];
    } else {
        numberOfBars = 10;
        self.numberOfBarsTextField.text = @"10";
    }
    
    [self clearBarsView];
    [self generateNumberOfBars:numberOfBars];
}

- (IBAction)eraseBarsWasPressed:(id)sender
{
    self.eraseButton.hidden = YES;
    self.generateButton.hidden = NO;
    self.startButton.hidden = YES;
    self.stopButton.hidden = YES;
    [self clearBarsView];
    self.currentBarsArray = nil;
}


#pragma mark - Private Methods
- (void)clearBarsView
{
    for (ORBarView *bar in self.currentBarsArray) {
        [bar removeFromSuperview];
    }
    
    for (ORBarView *bar in self.barsArray) {
        [bar removeFromSuperview];
    }
}

- (void)populateBarsViewWithBarsArray:(NSMutableArray *)barsArray
{
    for (ORBarView *bar in barsArray) {
        [self.barsView addSubview:bar];
    }
}

- (void)generateNumberOfBars:(NSInteger)numberOfBars
{
    ORBarView *bar;
    NSInteger barHeight;
    CGRect frame;
   
    barHeight = 50;
    
    self.currentBarsArray = [NSMutableArray array]; //inicializar
    for (int i = 0; i < numberOfBars; i++) {
        barHeight = arc4random() % 250;
        frame = CGRectMake([self xOriginForPosition:i], 1, BAR_WIDTH, barHeight + 20);
        bar = [[ORBarView alloc] initWithFrame:frame];
        bar.backgroundColor = [self randomColor];
        bar.layer.borderColor = [UIColor blackColor].CGColor;
        bar.currentPosition = i;
        [self.currentBarsArray addObject:bar];
        [self.barsView addSubview:bar];
    }
    
    
}

- (CGFloat)xOriginForPosition:(NSInteger)position
{
    CGFloat xOrigin;
    
    xOrigin = 0;
    for (int i = 0; i < position; i++) {
        xOrigin = xOrigin + BAR_WIDTH + 8;
    }
    return xOrigin;
}

- (UIColor *)randomColor
{
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    red = (CGFloat)(arc4random() % 100) / 100;
    green = (CGFloat)(arc4random() % 100) / 100;
    blue = (CGFloat)(arc4random() % 100) / 100;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

@end
