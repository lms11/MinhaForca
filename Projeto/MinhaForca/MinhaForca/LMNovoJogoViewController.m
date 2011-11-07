//
//  LMNovoJogoViewController.m
//  MinhaForca
//
//  Created by Lucas Moreira on 05/11/11.
//  Copyright (c) 2011 Lucas Moreira. All rights reserved.
//

#import "LMNovoJogoViewController.h"

@implementation LMNovoJogoViewController

- (IBAction)comecarJogo:(id)sender {
    LMForcaViewController *forcaVC = [[LMForcaViewController alloc] init];
    forcaVC.categoriaID = [pickerViewCategorias selectedRowInComponent:0];
    [self presentModalViewController:forcaVC animated:YES];
    [forcaVC release];
}

- (IBAction)voltar:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *caminhoProArquivo = [[NSBundle mainBundle] pathForResource:@"Palavras" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:caminhoProArquivo];
    categorias = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"categorias"]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIPickerView

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [categorias count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[categorias objectAtIndex:row] objectForKey:@"nome"];
}

@end
