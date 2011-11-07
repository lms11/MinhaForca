//
//  LMViewController.m
//  MinhaForca
//
//  Created by Lucas Moreira on 05/11/11.
//  Copyright (c) 2011 Lucas Moreira. All rights reserved.
//

#import "LMViewController.h"

@implementation LMViewController
@synthesize gcManager;

- (IBAction)novoJogo:(id)sender {
    LMNovoJogoViewController *novoJogo = [[LMNovoJogoViewController alloc] init];
    [self presentModalViewController:novoJogo animated:YES];
    [novoJogo release];
}

- (IBAction)conquistas:(id)sender {
    GKAchievementViewController *viewController = [[GKAchievementViewController alloc] init];
    [viewController setAchievementDelegate:self];
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}

- (IBAction)ranking:(id)sender {
    GKLeaderboardViewController *viewController = [[GKLeaderboardViewController alloc] init];
    [viewController setLeaderboardDelegate:self];
    [self presentModalViewController:viewController animated:YES];
    [viewController release];
}

#pragma Mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([GameCenterManager isGameCenterAvailable]) {
        
        self.gcManager = [[GameCenterManager alloc] init];
        [self.gcManager setDelegate:self];
        [self.gcManager authenticateLocalUser];
        
    } else {
        // Não está disponivel
        
        NSLog(@"Não está disponivel.");
    }
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - GameCenterManager Delegate

- (void) processGameCenterAuth: (NSError*) error {
    if (error == NULL) {
        // Não teve erro!
        NSLog(@"Autenticação completa com sucesso.");
        
        double complete = 100;
        [self.gcManager submitAchievement:kAchievementWelcome percentComplete:complete];
        
    } else {
        // Teve erro!
        NSLog(@"Houve um erro na autenticação: %@", [error localizedDescription]);
    }
}

- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error {
    if (error == NULL) {
        // Não teve erro!
        NSLog(@"Conquista enviada com sucesso.");
        NSLog(@"A conquista ganha: %@", ach.identifier);
        
    } else {
        // Teve erro!
        NSLog(@"Houve um erro no envio de conquista: %@", [error localizedDescription]);
    }
}

#pragma mark GameKitDelegate

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
    [viewController dismissModalViewControllerAnimated:YES];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [viewController dismissModalViewControllerAnimated:YES];
}

@end
