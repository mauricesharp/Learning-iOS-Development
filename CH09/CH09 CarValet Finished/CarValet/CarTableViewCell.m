//  CarTableViewCell.m
//  CarValet

#import "CarTableViewCell.h"

#import "CDCar.h"

@implementation CarTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Public Methods

- (void)configureCell {
    NSString *make = (self.myCar.make == nil) ?
                            @"Unknown" : self.myCar.make;
    NSString *model = (self.myCar.model == nil) ?
                            @"Unknown" : self.myCar.model;
    
    self.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                           self.myCar.year, make, model];
    
    NSString *dateStr = [NSDateFormatter
                         localizedStringFromDate:self.myCar.dateCreated
                         dateStyle:NSDateFormatterShortStyle
                         timeStyle:NSDateFormatterShortStyle];
    
    self.detailTextLabel.text = dateStr;
}

@end
