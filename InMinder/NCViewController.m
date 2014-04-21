//
//  NCViewController.m
//  InMinder
//
//  Created by nevercry on 1/12/14.
//  Copyright (c) 2014 nevercry. All rights reserved.
//

#import "NCViewController.h"
#import "NCAddingStuffViewController.h"
#import "NCPlaceBeacon.h"


static  NSString *const InMinderUUIDString = @"8AFEF8C9-F93B-49CF-9087-2BEF4B500C63";

@interface NCViewController ()

@property (nonatomic,strong) UIBarButtonItem *editBarButton;
@property (nonatomic,strong) UIBarButtonItem *editingBarButton;
@property (nonatomic,strong) NCPlaceBeacon *placeBeacon;
@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic) BOOL notifyOnExit;
@property (nonatomic) BOOL notifyOnEntry;
@property (nonatomic) BOOL notifyOnDisplay;

@end

@implementation NCViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 配置Beacon
    
    
    if (!self.placeBeacon) {
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:InMinderUUIDString];
        
        self.placeBeacon = [[NCPlaceBeacon alloc] initWithUUID:uuid  major:0 minor:0];
    }
    
    CLBeaconRegion *region = [_locationManager.monitoredRegions member:self.placeBeacon.region];
    
    if (region)
    {
        // has region
    }
    else
    {
        self.placeBeacon.region.notifyOnExit = _notifyOnExit;
        self.placeBeacon.region.notifyOnEntry = _notifyOnEntry;
        self.placeBeacon.region.notifyEntryStateOnDisplay = _notifyOnDisplay;
        
        [_locationManager startMonitoringForRegion:self.placeBeacon.region];
    }
    
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    [self checkingDataAndSetting];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)checkingDataAndSetting
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *inDoList = [userDefaults objectForKey:@"NC_IN_DO_LIST"];
    NSArray *outDoList = [userDefaults objectForKey:kInMinderOutToDoList];
    NSString *lastTitle = [userDefaults objectForKey:@"NC_LAST_TITLE"];
    
    if (inDoList)
    {
        [self.inDoList addObjectsFromArray:inDoList];
    }
    
    if (outDoList)
    {
        [self.outDoList addObjectsFromArray:outDoList];
    }
    
    if (lastTitle)
    {
        self.title = lastTitle;
    }
    else
    {
        self.title = NSLocalizedString(@"Go Out", nil);
        
        NSLog(@"title is %@",self.title);
        
        
        self.notifyOnExit =  YES;
        self.notifyOnEntry = NO;
        self.notifyOnDisplay = YES;
    }
    
    
    
}

- (NSMutableArray *)currentTableViewData
{
    if ([self.title isEqualToString:NSLocalizedString(@"Go Out", nil)])
    {
        return self.outDoList;
    }
    else if ([self.title isEqualToString:NSLocalizedString(@"Get In", nil)])
    {
        return self.inDoList;
    }
    
    return nil;
}

- (void)saveDataToUserDefault
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:self.inDoList forKey:kInMinderInToDoLinst];
    [userDefault setObject:self.outDoList forKey:kInMinderOutToDoList];
    [userDefault synchronize];
}


#pragma mark - Lazy Initalization

- (NSMutableArray *)inDoList
{
    if (!_inDoList)
    {
        _inDoList = [NSMutableArray array];
    }
    
    return _inDoList;
}

- (NSMutableArray *)outDoList
{
    if (!_outDoList)
    {
        _outDoList = [NSMutableArray array];
    }
    
    return _outDoList;
}


#pragma mark - Public API

- (void)addStuff:(NSString *)stuff toList:(NCListType)type
{
    switch (type) {
        case NCInDoList:
            [self.inDoList addObject:stuff];
            break;
        case NCOutDoList:
            [self.outDoList addObject:stuff];
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.title isEqualToString:NSLocalizedString(@"Go Out", nil)])
    {
        return [self.outDoList count];
    }
    else if ([self.title isEqualToString:NSLocalizedString(@"Get In", nil)])
    {
        return [self.inDoList count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *cellText = [[self currentTableViewData] objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = cellText;
    
    
    return cell;
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete)
     {
         // Delete the row from the data source
         if ([self.title isEqualToString:NSLocalizedString(@"Go Out", nil)]) {
             [self.outDoList removeObjectAtIndex:indexPath.row];
         }
         else if ([self.title isEqualToString:NSLocalizedString(@"Get In", nil)])
         {
             [self.inDoList removeObjectAtIndex:indexPath.row];
         }
         [self saveDataToUserDefault];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }
     else if (editingStyle == UITableViewCellEditingStyleInsert)
     {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }

- (IBAction)cancel:(UIStoryboardSegue *)sender
{
    
}

- (IBAction)save:(UIStoryboardSegue *)sender
{
    if ([sender.sourceViewController isKindOfClass:[NCAddingStuffViewController class]])
    {
        NCAddingStuffViewController *sc = sender.sourceViewController;
        NSString *stuff = sc.textView.text;
        
       
        
        if ([self.title isEqualToString:NSLocalizedString(@"Go Out", nil)]) {
            [self addStuff:stuff toList:NCOutDoList];
        } else {
            [self addStuff:stuff toList:NCInDoList];
        }
        
        [self saveDataToUserDefault];
        
        [self.tableView reloadData];
        
    }
}

- (IBAction)settingDone:(UIStoryboardSegue *)sender
{
    
}


- (IBAction)tableViewEdit:(UIBarButtonItem *)sender {
    
    self.tableView.editing = !self.tableView.isEditing;
    
    self.tableView.isEditing ? (sender.title = NSLocalizedString(@"Done", nil)):(sender.title = NSLocalizedString(@"Edit", nil));
    
    
}

- (IBAction)infoBTNPressed:(UIButton *)sender {
    
    NSLog(@"Hello !!!!");

    
    //[self performSegueWithIdentifier:@"Setting" sender:sender];
    
}






@end
