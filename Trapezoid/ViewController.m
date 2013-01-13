//
//  ViewController.m
//  Trapezoid
//
//  Created by Ivan Sapozhnik on 1/12/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

static const float animationSpeed = 0.2;

@interface ViewController () {
    BOOL isOnBack;
}

typedef void(^Completion)(BOOL finished);
@property (nonatomic, strong) UIView *flipView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.flipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 280)];
    self.flipView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.flipView];
    
    [self.view sendSubviewToBack:self.flipView];
    
    self.flipView.layer.shadowOpacity = 0.01;
    
    isOnBack = NO;
}

- (IBAction)playAnimation:(id)sender
{
    [self goBack:self.flipView completion:^(BOOL finished) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"View moved to back" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (IBAction)backAnimation:(id)sender
{
    [self goFront:self.flipView completion:^(BOOL finished) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"View moved to front" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

- (void)goBack:(UIView *)view completion:(Completion)handler
{
    if (isOnBack == NO) {
        [UIView animateWithDuration:animationSpeed delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CALayer *layer = view.layer;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / -300;
            layer.transform = CATransform3DRotate(transform, 10.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationSpeed animations:^{
                view.transform = CGAffineTransformMakeScale(0.85, 0.85);
            } completion:^(BOOL finished) {
                isOnBack = YES;
                handler(YES);
            }];
        }];
    } else {
        return;
    }
}

- (void)goFront:(UIView *)view completion:(Completion)handler
{
    if (isOnBack == YES) {
        [UIView animateWithDuration:animationSpeed delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CALayer *layer = view.layer;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / 300;
            layer.transform = CATransform3DRotate(transform, -10.0f * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationSpeed animations:^{
                view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                isOnBack = NO;
                handler(YES);
            }];
        }];
    } else {
        return;
    }
}

@end
