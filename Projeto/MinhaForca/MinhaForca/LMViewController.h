//
//  LMViewController.h
//  MinhaForca
//
//  Created by Lucas Moreira on 05/11/11.
//  Copyright (c) 2011 Lucas Moreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMNovoJogoViewController.h"
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import <GameKit/GameKit.h>

@interface LMViewController : UIViewController <GameCenterManagerDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate> {
    IBOutlet UIButton *buttonNovoJogo;
    IBOutlet UIButton *buttonConquistas;
    IBOutlet UIButton *buttonRanking;
    
    GameCenterManager *gcManager;
}

@property (nonatomic, retain) GameCenterManager *gcManager;

- (IBAction)novoJogo:(id)sender;
- (IBAction)conquistas:(id)sender;
- (IBAction)ranking:(id)sender;

@end
