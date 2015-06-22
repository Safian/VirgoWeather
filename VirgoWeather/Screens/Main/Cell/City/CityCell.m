//
//  CityCell.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 19/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "CityCell.h"
#import "NSDate+Timeformater.h"

@interface CityCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *tempLabel;
@property (nonatomic, strong) UILabel *lastUpdateLabel;

@end

@implementation CityCell

-(NSString *)reuseIdentifier { return @"CityCell"; }

#pragma mark - Init

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    }
    return self;
}

#pragma mark - Setters

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) [self setSelected:false animated:true]; //Deselect animation
}


-(void)setCity:(City *)city
{
    BOOL needImageUpdate = ![_city.weatherIconImageName isEqualToString:city.weatherIconImageName];
    
    _city = city;
    
    // Get image with async block
    if (needImageUpdate) {
        [_city imageWithAsyncBlock:^(UIImage *image) {
            self.imageView.image = image;
            [self setNeedsLayout];
        }];
    }
    // Fill outlets with data
    self.textLabel.text = _city.name;
    self.tempLabel.text = _city.weather.temperature.stringValueWithCelsius;
    self.lastUpdateLabel.text = _city.stringLastUpdateTime;
    [_city updateIfNeed];
}

#pragma mark - SubViews Lazy Loads

-(UILabel *)tempLabel
{
    if (!_tempLabel) {
        _tempLabel = [[UILabel alloc] initWithFrame:(CGRect){self.contentView.bounds.size.width-130,0,100,self.contentView.bounds.size.height}];
        _tempLabel.textAlignment = NSTextAlignmentRight;
        _tempLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_tempLabel];
    }
    return _tempLabel;
}

-(UILabel *)lastUpdateLabel
{
    if (!_lastUpdateLabel) {
        CGRect frame = self.contentView.bounds;
        frame.origin.y = frame.size.height -20;
        frame.size.height = 20;
        frame.origin.x = 100;
        frame.size.width = self.contentView.bounds.size.width - 130;
        _lastUpdateLabel = [[UILabel alloc] initWithFrame:frame];
        _lastUpdateLabel.textAlignment = NSTextAlignmentRight;
        _lastUpdateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
        _lastUpdateLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_lastUpdateLabel];
    }
    return _lastUpdateLabel;
}

-(UIImageView *)imageView
{
    if (!_imgView) {
        _imgView = super.imageView;
        _imgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _imgView.layer.shadowOffset = (CGSize){-3,4};
        _imgView.layer.masksToBounds = false;
        _imgView.layer.shadowOpacity = 0.99;
        _imgView.layer.shadowRadius = 2;
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

@end
