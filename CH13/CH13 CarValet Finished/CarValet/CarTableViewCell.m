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
    self.makeModelLabel.text = [NSString stringWithFormat:@"%@ %@ %@",
                           self.myCar.year, self.myCar.make, self.myCar.model];
    
    NSString *dateStr = [NSDateFormatter
                         localizedStringFromDate:self.myCar.dateCreated
                         dateStyle:NSDateFormatterShortStyle
                         timeStyle:NSDateFormatterShortStyle];
    
    self.dateCreatedLabel.text = dateStr;
}

@end
