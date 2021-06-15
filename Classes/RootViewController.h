//
//  RootViewController.h
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/19/11.
//  Copyright Mobile Bros 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

//#import "GADBannerView.h"

//GADBannerView *bannerView_;

//DEBUG: Ad GADBannerViewDelegate to the following in order to allow AdMob to work
@interface RootViewController : UIViewController<UIGestureRecognizerDelegate> {

}

//@property(nonatomic, retain) GADBannerView *bannerView_;


//-(void) gestures;
-(void) initGADBanner;

@end
