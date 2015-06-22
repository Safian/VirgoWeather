//
//  MainHeaderView.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 19/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "MainHeaderView.h"
#import "LocationManager.h"
#import "OpenWeatherManager.h"
#import "UIView+Alert.h"
#import "AutocompleteCell.h"

#define searchField_padding 20
#define button_padding      60

#define Autocompplete_Max_Hint_Count 6

@interface MainHeaderView() <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,LocationManagerDelegate>
//Autocomplete source array
@property (strong, nonatomic) NSArray *cities;
//Search textfield
@property (strong, nonatomic) UITextField *textField;
//Autocomplete tableview show hits
@property (strong, nonatomic) UITableView *autocompleteTableView;
//Done action button
@property (strong, nonatomic) UIButton *doneButton;
//Local weather views
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *temperatureLabel;

@end

@implementation MainHeaderView

#pragma mark - View Init Methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        LocationManager.sharedInstance.delegate = self;
        [LocationManager.sharedInstance updateLocation];
        //When will be hide keyboard on the autocomplete tableView closes too
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *note)
        {
            _autocompleteTableView.hidden = true;
        }];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Subview Lazy Loads

-(UITextField *)textField
{
    if(!_textField) {
        _textField = [[UITextField alloc]initWithFrame:(CGRect){searchField_padding,80,self.bounds.size.width-2*searchField_padding,40}];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        _textField.delegate = self;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.placeholder = NSLocalizedString(@"search_city_placeholder", nil);
        _textField.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.7] CGColor];
        _textField.layer.borderWidth = 2.0;
        _textField.layer.cornerRadius = 10;
        _textField.leftView = [[UIView alloc]initWithFrame:(CGRect){0,0,20,0}];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self addSubview:_textField];
    }
    return _textField;
}

-(UITableView *)autocompleteTableView
{
    if(!_autocompleteTableView) {
        CGRect frame = self.textField.frame;
        frame.origin.y += frame.size.height;
        frame.size.height = 90;
        _autocompleteTableView = [[UITableView alloc]initWithFrame:frame];
        _autocompleteTableView.rowHeight = 30;
        _autocompleteTableView.backgroundColor = [UIColor clearColor];
        _autocompleteTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        _autocompleteTableView.delegate = self;
        _autocompleteTableView.dataSource = self;
        _autocompleteTableView.backgroundColor = [UIColor clearColor];
        _autocompleteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_autocompleteTableView];
    }
    return _autocompleteTableView;
}

-(UIButton *)doneButton
{
    if (!_doneButton) {
        float y = self.textField.frame.origin.y + self.textField.frame.size.height+25;
        float width = self.bounds.size.width-2*button_padding;
        _doneButton = [[UIButton alloc]initWithFrame:(CGRect){button_padding,y,width,40}];
        _doneButton.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        _doneButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _doneButton.layer.borderWidth = 2.0;
        _doneButton.layer.cornerRadius = 10;
        [_doneButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal ];
        [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted ];
        [_doneButton addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [_doneButton setTitle:NSLocalizedString(@"search_city_done_button_title", nil) forState:UIControlStateNormal];
        [self addSubview:_doneButton];
    }
    return _doneButton;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        CGRect frame = (CGRect){self.center.x-100,self.doneButton.frame.origin.y+self.doneButton.frame.size.height,200,80};
        _imageView = [[UIImageView alloc]initWithFrame:frame];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleHeight;
        _imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _imageView.layer.shadowOffset = (CGSize){-3,4};
        _imageView.layer.masksToBounds = false;
        _imageView.layer.shadowOpacity = 0.99;
        _imageView.layer.shadowRadius = 2;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self insertSubview:_imageView atIndex:0];
    }
    return _imageView;
}

-(UILabel *)temperatureLabel
{
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc]initWithFrame:self.imageView.bounds];
        _temperatureLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        _temperatureLabel.text = @"--°C";
        _temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:38];
        _temperatureLabel.textAlignment = NSTextAlignmentRight;
        _temperatureLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _temperatureLabel.layer.shadowOffset = (CGSize){3,4};
        _temperatureLabel.layer.masksToBounds = false;
        _temperatureLabel.layer.shadowOpacity = 0.99;
        _temperatureLabel.layer.shadowRadius = 2;
        [self.imageView addSubview:_temperatureLabel];
    }
    return _temperatureLabel;
}


#pragma mark - Done Button action

-(void)doneAction
{
    if (self.cities.count)
    {
        if ([self.delegate respondsToSelector:@selector(addNewCity:)])
        {
            [self.delegate addNewCity:self.cities.firstObject];
            self.textField.text = nil;
            self.cities = nil;
            [self.autocompleteTableView reloadData];
        }
    }
    else if (!self.textField.text.length)
    {
        [self showAlertWithTitle:nil Message:NSLocalizedString(@"search_text_not_found", nil)];
    }
    else
    {
        [self showAlertWithTitle:NSLocalizedString(@"search_city_not_found_title", nil)
                         Message:NSLocalizedString(@"search_city_not_found_message", nil)];
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length)
    {
        [self doneAction];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.cities = nil;
    [self.autocompleteTableView reloadData];
    NSString * searchStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"%@",searchStr);
    
    if (searchStr.length > 2)
    {
        [OpenWeatherManager.sharedInstance searchCityWithSubString:searchStr
                                         completion:^(NSDictionary *cities,NSError *error)
        {
            if ([cities[@"list"] count])
            {
                NSMutableArray *mutableArray = NSMutableArray.new;
                for (NSDictionary *cityDict in cities[@"list"])
                {
                    [mutableArray addObject:[[City alloc] initWithOpenWeatherDictionary:cityDict]];
                }
                self.cities = mutableArray.copy;
                self.autocompleteTableView.hidden = false;
                [self.autocompleteTableView reloadData];
            }
            else if (error.localizedDescription)
            {
                NSLog(@"ERROR getWeatherWithCitySubString : %@",error.localizedDescription);
            }
        }];
    }
    return true;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentLeft;
    textField.placeholder = nil;
    return true;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentCenter;
    self.autocompleteTableView.hidden = true;
}

#pragma mark - LocationManagerDelegate

-(void)didUpdateLocationLat:(float)latitude Lng:(float)longitude
{
    [OpenWeatherManager.sharedInstance getWeatherWithLatitude:latitude
                                                    Longitude:longitude
                                                   completion:^(NSDictionary *weatherData,NSError *error)
    {
        City *city = [[City alloc] initWithOpenWeatherDictionary:weatherData];
        self.temperatureLabel.text = city.weather.temperature.stringValueWithCelsius;
        [city imageWithAsyncBlock:^(UIImage *image) {
            if (image) {
                self.imageView.image = image;
                [self setNeedsLayout];
            }
            if (error.localizedDescription) {
                [self showAlertWithTitle:@":Download icon image error" Message:error.localizedDescription];
            }
        }];
    }];
}

-(void)locationDisabled
{
    
}

#pragma mark - TableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = MIN(Autocompplete_Max_Hint_Count,self.cities.count);
    CGRect frame = tableView.frame;
    frame.size.height = count * 30;
    tableView.frame = frame;
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"AutocomleteCell";
    AutocompleteCell *cell = [self.autocompleteTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell) cell = [[AutocompleteCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:cellIdentifier];
    cell.city = self.cities[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.cities = [NSArray arrayWithObject:self.cities[indexPath.row]];
    self.textField.text = ((City*)self.cities.firstObject).name;
    self.autocompleteTableView.hidden = true;
}


@end
