//
//  CDCar.h
//  CarValet
//
//  Created by Maurice Sharp on 9/27/13.
//  Copyright (c) 2013 Learning iOS Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDCar : NSManagedObject

@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSString * make;
@property (nonatomic, retain) NSString * model;
@property (nonatomic, retain) NSNumber * fuelAmount;
@property (nonatomic, retain) NSDate * dateCreated;

@end
