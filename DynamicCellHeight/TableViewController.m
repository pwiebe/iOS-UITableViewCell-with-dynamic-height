//
//  ViewController.m
//  DynamicCellHeight
//
//  Created by Timo Josten on 08/07/15.
//  Copyright (c) 2015 mkswap.net. All rights reserved.
//

#import "TableViewController.h"
#import "DynamicTableViewCell.h"

@interface TableViewController ()

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic) NSMutableArray *isVisible;
@end

static NSString* const CellIdentifier = @"DynamicTableViewCell";

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = @[@"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum    has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                        @"Lorem Ipsum is simply dummy text",
                        @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                        @"Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old.",
                        @"There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
                        ];
    self.isVisible = [@[@YES, @YES, @YES, @YES, @YES] mutableCopy];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

# pragma mark - Cell Setup

- (void)setUpCell:(DynamicTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.label.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.secondLabel.text = [self.dataSource objectAtIndex:self.dataSource.count - indexPath.row - 1];
    if ([self.isVisible[indexPath.row] isEqual:@NO]) {
        cell.secondLabel.hidden = YES;
    } else {
        cell.secondLabel.hidden = NO;
    }
}

# pragma mark - UITableViewControllerDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [self setUpCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DynamicTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.isVisible[indexPath.row] isEqual: @YES]) {
        self.isVisible[indexPath.row] = @NO;
        cell.secondLabel.hidden = YES;
    } else {
        self.isVisible[indexPath.row] = @YES;
        cell.secondLabel.hidden = NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static DynamicTableViewCell *cell = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    });
    
    [self setUpCell:cell atIndexPath:indexPath];
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(DynamicTableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

@end
