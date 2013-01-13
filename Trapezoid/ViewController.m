//
//  ViewController.m
//  Trapezoid
//
//  Created by Ivan Sapozhnik on 1/12/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

static const float animationSpeed = 0.3f;
static const float angle = 15.0f;

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
    
    self.flipView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 280, 280)];
    self.flipView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.flipView];
    
    [self.view sendSubviewToBack:self.flipView];
    
    self.flipView.layer.shadowOpacity = 0.01;
    
    isOnBack = NO;
}

- (IBAction)playAnimation:(id)sender
{
//    [self goBack:self.flipView completion:^(BOOL finished) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"View moved to back" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
    [self.flipView.layer addAnimation:[self animationGroupForward:YES view:self.flipView] forKey:@""];
}

- (IBAction)backAnimation:(id)sender
{
//    [self goFront:self.flipView completion:^(BOOL finished) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"View moved to front" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
    [self.flipView.layer addAnimation:[self animationGroupForward:NO view:self.flipView] forKey:@""];
}

- (void)goBack:(UIView *)view completion:(Completion)handler
{
    if (isOnBack == NO) {
        [UIView animateWithDuration:animationSpeed delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CALayer *layer = view.layer;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / -300;
            layer.transform = CATransform3DRotate(transform, angle * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationSpeed animations:^{
                view.transform = CGAffineTransformMakeScale(0.85, 0.85);
            } completion:^(BOOL finished) {
                isOnBack = YES;
                handler(YES);
            }];
        }];
    }
}

- (void)goFront:(UIView *)view completion:(Completion)handler
{
    if (isOnBack == YES) {
        [UIView animateWithDuration:animationSpeed delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CALayer *layer = view.layer;
            CATransform3D transform = CATransform3DIdentity;
            transform.m34 = 1.0 / 300;
            layer.transform = CATransform3DRotate(transform, -angle * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationSpeed animations:^{
                view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            } completion:^(BOOL finished) {
                isOnBack = NO;
                handler(YES);
            }];
        }];
    }
}

-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward view:(UIView *)view {
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-500;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    t1 = CATransform3DRotate(t1, angle*M_PI/180.0f, 1, 0, 0);
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    t2 = CATransform3DTranslate(t2, 0, view.frame.size.height*-0.08, 0);
    t2 = CATransform3DScale(t2, 0.8, 0.8, 1);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
	CFTimeInterval duration = animationSpeed;
    animation.duration = duration/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}


@end
