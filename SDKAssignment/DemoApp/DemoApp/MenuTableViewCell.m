//
//  MenuTableViewCell.m
//  Pedometer
//
//  Created by Ravikiran Gajula on 16/02/2020.
//  Copyright © 2020 Ravikiran Gajula. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.iconImage.sizeToFit;

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
