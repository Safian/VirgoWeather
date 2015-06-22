//
//  MainTableViewController.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 19/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainHeaderView.h"
#import "CityCell.h"
#import "UserDefaultsManager.h"

@interface MainTableViewController () <MainHeaderViewDelegate,CityDelegate>

@property (strong, nonatomic) MainHeaderView *headerView;
@property (strong, nonatomic) NSMutableArray* data;

@end

@implementation MainTableViewController
{
    CGRect headerFrame;
}

#pragma mark - Override Screen title string

- (NSString *)title {return NSLocalizedString(@"main_title", nil);}

#pragma mark - ViewController Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.title;
    [self tableViewCustomize];
    //When the program became active to reload the table
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView
                                             selector:@selector(reloadData)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source

-(NSMutableArray *)data
{
    if(!_data)
    {
        NSArray *savedData = [UserDefaultsManager cities];
        _data = savedData.count > 0 ? savedData.mutableCopy :  NSMutableArray.new;
    }
    return _data;
}

-(void)saveData
{
    [UserDefaultsManager saveCities:self.data];
}

#pragma mark - Header View Lazy Load

-(MainHeaderView *)headerView
{
    if (!_headerView)
    {
        _headerView = [[MainHeaderView alloc] initWithFrame:(CGRect){0,0,self.tableView.bounds.size.width,210}];
        _headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - TableView -

- (void)tableViewCustomize
{
    headerFrame = self.headerView.frame;
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:headerFrame];
    [self.tableView.tableHeaderView addSubview:self.headerView];
    self.tableView.tableHeaderView.clipsToBounds = false;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.rowHeight = 60;
    [self.tableView registerClass:CityCell.class forCellReuseIdentifier:@"CityCell"];
}

#pragma mark - UITableView Controller Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CityCell";
    CityCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:cellIdentifier];
    cell.city = self.data[indexPath.row];
    cell.city.delegate = self;
    return cell;
}

//Swipe Cell delete enable
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//Swipe delete cell commot delete action
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.data removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveData];
    }
}

#pragma mark - Scroll Delegates

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.tableView.tableHeaderView && scrollView.contentOffset.y < 0)
    {
        //Elastic header trick with content offset and autoresize...
        CGRect frame = headerFrame;
        frame.size.width = self.tableView.bounds.size.width;
        frame.size.height = headerFrame.size.height - scrollView.contentOffset.y;
        frame.origin.y = MIN(0, scrollView.contentOffset.y);
        self.headerView.frame = frame;
    }
}

#pragma mark - HederView Delegte

-(void)addNewCity:(City*)city
{
    if (city)
    {
        for (City *cityDic in self.data)
        {
            if ([cityDic.cityID integerValue] == [city.cityID integerValue])
            {
                NSUInteger index = [self.data indexOfObject:cityDic];
                [self.data removeObjectAtIndex:index];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
        [self.data insertObject:city atIndex:0];
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        [self saveData];
    }
}

#pragma mark - City Cell Delegate

-(void)didUpdateCity:(City *)updatedCity
{
    if (updatedCity)
    {
        for (City *cityItem in self.data)
        {
            if (cityItem.cityID.integerValue == updatedCity.cityID.integerValue)
            {
                NSLog(@"Updated city : %@",cityItem);
                NSUInteger index = [self.data indexOfObject:cityItem];
                [self.data removeObject:cityItem];
                [self.data insertObject:updatedCity atIndex:index];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationFade];
                break;
            }
        }
        [self saveData];
    }
}

@end
