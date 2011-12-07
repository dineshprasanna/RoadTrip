//
//  EventPageController.h
//  RoadTrip
//
//  Created by Vince Mansel on 12/4/11.
//  Copyright (c) 2011 waveOcean Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventPageController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *eventDataView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (readwrite, nonatomic) int page;

@end
