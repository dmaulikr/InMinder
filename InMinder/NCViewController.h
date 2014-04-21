//
//  NCViewController.h
//  InMinder
//
//  Created by nevercry on 1/12/14.
//  Copyright (c) 2014 nevercry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


enum  NCBaseTVCListType
{
    NCInDoList,
    NCOutDoList
};
typedef NSUInteger NCListType;

@interface NCViewController : UIViewController<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (nonatomic,strong) NSMutableArray *inDoList;
@property (nonatomic,strong) NSMutableArray *outDoList;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *titleSegmentedControl;


- (void)addStuff:(NSString *)stuff toList:(NCListType)type;



@end
