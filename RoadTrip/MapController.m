//
//  MapController.m
//  RoadTrip
//
//  Created by Vince Mansel on 12/6/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import "MapController.h"
#import "RoadTripAppDelegate.h"
#import "Trip.h"

@interface MapController () {
    
    UIBarButtonItem *locateButton;
}
@end

@implementation MapController
@synthesize mapView;

#pragma mark - Custom Methods

- (void)setInitialRegion
{
    RoadTripAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    MKCoordinateRegion region;
    CLLocationCoordinate2D initialCoordinate = [appDelegate.trip destinationCoordinate];
    region.center.latitude = initialCoordinate.latitude;
    region.center.longitude = initialCoordinate.longitude;
    region.span.latitudeDelta = .03;
    region.span.longitudeDelta = .03;
    [mapView setRegion:region animated:NO];
}

- (IBAction)mapType:(id)sender
{
    mapView.mapType = ((UISegmentedControl *) sender).selectedSegmentIndex;
}

- (void)addAnnotations
{
    RoadTripAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    [mapView addAnnotations:[appDelegate.trip createAnnotations]];
}

- (void)goToDestination:(id)sender
{
    [self setInitialRegion];
    self.navigationItem.rightBarButtonItem.title = @"Locate";
    self.navigationItem.rightBarButtonItem.action = @selector(goToLocation:);
}

- (void)goToLocation:(id)sender
{
    MKUserLocation *annotation = mapView.userLocation;
    CLLocation *location = annotation.location;
    if (nil == location) {
        return;
    }
    CLLocationDistance distance = MAX(4*location.horizontalAccuracy, 500);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance);
    [mapView setRegion:region animated:NO];
    self.navigationItem.rightBarButtonItem.action = @selector(goToDestination:);
    self.navigationItem.rightBarButtonItem.title = @"Destination";
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error
{
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to load the map"
                                                    message:@"Check to see if you have internet access"
                                                   delegate:self
                                          cancelButtonTitle:@"Thanks"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Supplied Stubs

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.delegate = self;
    mapView.showsUserLocation = YES;
    [self setInitialRegion];
    RoadTripAppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.title = [appDelegate.trip mapTitle];
    [self addAnnotations];
    locateButton = [[UIBarButtonItem alloc] initWithTitle:@"Locate"
                                                    style:UIBarButtonItemStylePlain
                                                   target:self action:@selector(goToLocation:)];
    self.navigationItem.rightBarButtonItem = locateButton;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
