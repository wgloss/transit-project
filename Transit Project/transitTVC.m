//
//  transitTVC.m
//  Transit Project
//
//  Created by William Gloss on 3/12/14.
//  Copyright (c) 2014 Primal Coding. All rights reserved.
//

#import "transitTVC.h"

@interface transitTVC ()
@property (strong, nonatomic) NSMutableArray *stops;
@end

@implementation transitTVC


-(void)setStops:(NSMutableArray *)stops
{
    _stops = stops;
    [self.tableView reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self fetchData];
}


- (void)fetchData{
    NSURL *tempurl = [NSURL URLWithString:@"http://proximobus.appspot.com/agencies.json"];
    NSData *tempdata = [NSData dataWithContentsOfURL:tempurl];
    NSDictionary *quickproplist = [NSJSONSerialization JSONObjectWithData:tempdata options:0 error:NULL];
    NSLog(@"muni = %@",quickproplist);
    
    NSURL *url = [NSURL URLWithString:@"http://proximobus.appspot.com/agencies/sf-muni/routes/N/stops.json"];
    NSData *jsonResutls = [NSData dataWithContentsOfURL:url];
    NSMutableDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResutls
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:NULL];
//    NSLog(@"propertylist = %@",propertyListResults);
    self.stops = [propertyListResults valueForKeyPath:@"items"];
//    NSLog(@"results= %@",self.stops);
    
    for (NSMutableDictionary *tempDictionary in self.stops) {
        NSURL *urldetail = [NSURL URLWithString:[NSString stringWithFormat:@"http://proximobus.appspot.com/agencies/sf-muni/stops/%@/predictions/by-route/N.json",[tempDictionary valueForKeyPath:@"id"]]];
        NSData *jsonDetailResults = [NSData dataWithContentsOfURL:urldetail];
        NSMutableDictionary *detailPLResults = [NSJSONSerialization JSONObjectWithData:jsonDetailResults
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:NULL];
//        NSLog(@"detailResults = %@",detailPLResults);
//    NSMutableDictionary *tempDict = self.stops[0];
        [tempDictionary setObject:detailPLResults forKey:@"predictions"];
        NSLog(@"Stop[1] stuff %@",tempDictionary);
    }
    NSString *detailtest = [[[self.stops[0] valueForKeyPath:@"predictions.items.minutes"] componentsJoinedByString:@" min ,"] stringByAppendingString:@" min"];
    NSLog(@"detail attempt %@",detailtest);
//    NSLog(@"results= %@",self.stops);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.stops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Stop Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *stop = self.stops[indexPath.row];
    cell.textLabel.text = [stop valueForKeyPath:@"display_name"];
    cell.detailTextLabel.text = [[[stop valueForKeyPath:@"predictions.items.minutes"] componentsJoinedByString:@" min, "] stringByAppendingString:@" min"];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
