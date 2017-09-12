//
//  InterstitialAdViewController.m
//  MyRecordProj
//
//  Created by  qin on 2017/9/12.
//  Copyright © 2017年  qin. All rights reserved.
//

#import "InterstitialAdViewController.h"
#import <InMobiSDK/InMobiSDK.h>

@interface InterstitialAdViewController () <IMInterstitialDelegate>
@property (nonatomic, strong) IMInterstitial *interstitial;
@end

@implementation InterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self. interstitial = [[IMInterstitial alloc] initWithPlacementId:1506068661088];
    self. interstitial.delegate = self;
    [self.interstitial load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showAdIfLoaded
{
    if (self.interstitial.isReady) {
        [self.interstitial showFromViewController:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/**
 * Notifies the delegate that the ad server has returned an ad. Assets are not yet available.
 * Please use interstitialDidFinishLoading: to receive a callback when assets are also available.
 */
-(void)interstitialDidReceiveAd:(IMInterstitial *)interstitial
{
    NSLog(@"interstitialDidReceiveAd");
}
/**
 * Notifies the delegate that the interstitial has finished loading and can be shown instantly.
 */
-(void)interstitialDidFinishLoading:(IMInterstitial*)interstitial
{
    NSLog(@"interstitialDidFinishLoading");
}
/**
 * Notifies the delegate that the interstitial has failed to load with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToLoadWithError:(IMRequestStatus*)error
{
    NSLog(@"Interstitial failed to load ad");
    NSLog(@"Error : %@",error.description);
}
/**
 * Notifies the delegate that the interstitial would be presented.
 */
-(void)interstitialWillPresent:(IMInterstitial*)interstitial
{
    NSLog(@"interstitialWillPresent");
}
/**
 * Notifies the delegate that the interstitial has been presented.
 */
-(void)interstitialDidPresent:(IMInterstitial *)interstitial
{
    NSLog(@"interstitialDidPresent");
}
/**
 * Notifies the delegate that the interstitial has failed to present with some error.
 */
-(void)interstitial:(IMInterstitial*)interstitial didFailToPresentWithError:(IMRequestStatus*)error
{
    NSLog(@"Interstitial didFailToPresentWithError");
    NSLog(@"Error : %@",error.description);
}
/**
 * Notifies the delegate that the interstitial will be dismissed.
 */
-(void)interstitialWillDismiss:(IMInterstitial*)interstitial
{
    NSLog(@"interstitialWillDismiss");
}
/**
 * Notifies the delegate that the interstitial has been dismissed.
 */
-(void)interstitialDidDismiss:(IMInterstitial*)interstitial
{
    NSLog(@"interstitialDidDismiss");
    
    [self.interstitial load];
}
/**
 * Notifies the delegate that the interstitial has been interacted with.
 */
-(void)interstitial:(IMInterstitial*)interstitial didInteractWithParams:(NSDictionary*)params
{
    NSLog(@"InterstitialDidInteractWithParams");
}
/**
 * Notifies the delegate that the user has performed the action to be incentivised with.
 */
-(void)interstitial:(IMInterstitial*)interstitial rewardActionCompletedWithRewards:(NSDictionary*)rewards
{
    
}
/**
 * Notifies the delegate that the user will leave application context.
 */
-(void)userWillLeaveApplicationFromInterstitial:(IMInterstitial*)interstitial
{
    NSLog(@"userWillLeaveApplicationFromInterstitial");
}

@end
