//
//  AutocompleteCell.m
//  VirgoWeather
//
//  Created by Sáfián Szabolcs on 21/06/15.
//  Copyright (c) 2015 Safian. All rights reserved.
//

#import "AutocompleteCell.h"

@interface AutocompleteCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *txtLabel;

@end

@implementation AutocompleteCell

-(NSString *)reuseIdentifier { return @"AutocompleteCell"; }

#pragma mark - Init

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
        self.contentView.layer.cornerRadius = 15;
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.8].CGColor;
        self.contentView.layer.masksToBounds = false;
        self.contentView.clipsToBounds = true;
    }
    return self;
}

#pragma mark - Setters

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {  [self setSelected:false animated:true]; } //Animated deselect
}

-(void)setCity:(City *)city
{
    _city = city;
    self.textLabel.text = _city.name;
    self.imageView.image = [UIImage imageNamed:_city.countryCode];
}

#pragma mark - SubViews Lazy Loads

-(UILabel *)textLabel
{
    if (!_txtLabel) {
        CGRect frame = self.contentView.bounds;
        frame.origin.x = self.imageView.frame.origin.x + self.imageView.frame.size.width;
        frame.size.width -= frame.origin.x;
        _txtLabel = [[UILabel alloc] initWithFrame:frame];
        _txtLabel.textAlignment = NSTextAlignmentLeft;
        _txtLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_txtLabel];
    }
    return _txtLabel;
}

-(UIImageView *)imageView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]initWithFrame:(CGRect){10,2,26,26}];
        _imgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _imgView.layer.shadowOffset = (CGSize){-3,4};
        _imgView.layer.masksToBounds = false;
        _imgView.layer.shadowOpacity = 0.99;
        _imgView.layer.shadowRadius = 2;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.layer.cornerRadius = _imgView.frame.size.height / 2;
        _imgView.layer.borderWidth = 1.4;
        _imgView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.6].CGColor;
        _imgView.clipsToBounds = true;
        [self.contentView addSubview:_imgView];
        
    }
    return _imgView;
}

@end
