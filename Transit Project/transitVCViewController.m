//
//  transitVCViewController.m
//  Transit Project
//
//  Created by William Gloss on 3/11/14.
//  Copyright (c) 2014 Primal Coding. All rights reserved.
//

#import "transitVCViewController.h"

@interface transitVCViewController ()

@end

@implementation transitVCViewController





- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchData];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)fetchData{
    NSURL *url = [NSURL URLWithString:@"http://proximobus.appspot.com/agencies/sf-muni/routes/N/stops.json"];
    NSData *jsonResutls = [NSData dataWithContentsOfURL:url];
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResutls
                                                                        options:0
                                                                          error:NULL];
    NSLog(@"propertylist = %@",propertyListResults);
    NSArray *stops = [propertyListResults valueForKeyPath:@"items.id"];
    NSLog(@"results= %@",stops);
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
