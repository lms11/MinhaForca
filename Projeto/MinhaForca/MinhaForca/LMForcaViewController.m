//
//  LMForcaViewController.m
//  MinhaForca
//
//  Created by Lucas Moreira on 05/11/11.
//  Copyright (c) 2011 Lucas Moreira. All rights reserved.
//

#import "LMForcaViewController.h"

@implementation NSString (StringForca)

- (NSArray *)getIndexesOf:(NSString *)string {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    NSData *data = [[self lowercaseString] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *newString = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
    
    for (int z = 0; z < [newString length]; z++) {
        NSRange range = NSMakeRange(z, [string length]);
        
        if ([[newString substringWithRange:range] isEqualToString:[string lowercaseString]]) {
            [result addObject:[NSString stringWithFormat:@"%d", z]];
        }
    }
    
    return [result autorelease];
}

// Gambiarra pra checar se é somente números
- (BOOL)onlyNumber {
    for (int z = 0; z < [self length]; z++) {
        NSString *letra = [NSString stringWithFormat:@"%C", [self characterAtIndex:z]];
        
        if (![letra isEqualToString:@"0"] && ![letra isEqualToString:@"1"] && ![letra isEqualToString:@"2"] && ![letra isEqualToString:@"3"] &&
            ![letra isEqualToString:@"4"] && ![letra isEqualToString:@"5"] && ![letra isEqualToString:@"6"] && ![letra isEqualToString:@"7"] &&
            ![letra isEqualToString:@"8"] && ![letra isEqualToString:@"9"]) {
            return NO;
        }
    }
    
    return YES;
}

@end

@implementation LMForcaViewController
@synthesize categoriaID, palavra, letrasTentadas, gcManager;

- (IBAction)tecladoTocado:(id)sender {    
    [(UIButton *)sender setEnabled:NO];
    
    [self checarForca:[(UIButton *)sender currentTitle]];
}

- (IBAction)sairDoJogo:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepararJogo {
    NSString *caminhoProArquivo = [[NSBundle mainBundle] pathForResource:@"Palavras" ofType:@"plist"];
    NSDictionary *dictionary = [[[NSDictionary alloc] initWithContentsOfFile:caminhoProArquivo] autorelease];
    NSArray *categorias = [[[NSArray alloc] initWithArray:[dictionary objectForKey:@"categorias"]] autorelease];
    NSDictionary *categoria = [[[NSDictionary alloc] initWithDictionary:[categorias objectAtIndex:categoriaID]] autorelease];
    
    int random = arc4random() % [[categoria objectForKey:@"palavras"] count];
    
    NSLog(@"Random: %d", random);
    
    palavra = [[[categoria objectForKey:@"palavras"] objectAtIndex:random] retain];
    nLetras = [palavra length];
    
    NSLog(@"palavra: %@", palavra);
    
    for (int z = 0; z < [palavra length]; z++) {
        NSString *letra = [NSString stringWithFormat:@"%C", [palavra characterAtIndex:z]];
        
        if ([letra isEqualToString:@" "]) {
            
            nLetras--;
            [label appendString:@"  "];         // Dois espaços para diferenciar o espaço comum dentro de uma palavra
        } else if ([letra onlyNumber]) {
            nLetras--;
            [label appendFormat:@"%@ ", letra];
            
        } else [label appendString:@"_ "];      // _ = LETRA a ser inserida. O espaço é para melhoria visual, apenas.
    }
    
    labelPalavra.text = label;
}

- (void)checarForca:(NSString *)novaLetra {
    [letrasTentadas addObject:novaLetra];
    
    NSLog(@"GameCenterManager: %@", gcManager.description);
    
    NSArray *indexes = [palavra getIndexesOf:novaLetra];
    
    NSLog(@"indexes: %@", indexes);
    
    if ([indexes count] > 0) {
        for (int z = 0; z < [indexes count]; z++) {
            int x = [[indexes objectAtIndex:z] intValue] * 2;
            
            [label deleteCharactersInRange:NSMakeRange(x, 1)];
            [label insertString:[palavra substringWithRange:NSMakeRange(x/2, 1)] atIndex:x];
            
            nLetras--;
        }
        
        labelPalavra.text = label;
        
        if (nLetras == 0) {
            
            NSLog(@"Erros: %d", nErros);
            
            double complete = 100;
            [self.gcManager submitAchievement:kAchievementWin percentComplete:complete];
            
            if (nErros == 0) [self.gcManager submitAchievement:kAchievementWinDirect percentComplete:complete];
            
            [self dismissViewControllerAnimated:YES completion:^{
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Fim de Jogo!"
                                                                 message:@"Parabéns, você ganhou!"
                                                                delegate:nil
                                                       cancelButtonTitle:@"Cancelar"
                                                       otherButtonTitles:nil];
                [alerta show];
                [alerta release];
            }];
            
        } else NSLog(@"nLetras: %d", nLetras);
    } else {
        nErros++;
        
        if (nErros == 5) {
            
            double complete = 100;
            [self.gcManager submitAchievement:kAchievementLose percentComplete:complete];
            
            [self dismissViewControllerAnimated:YES completion:^{
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Fim de Jogo!"
                                                                 message:@"Você perdeu.\nTente novamente."
                                                                delegate:nil
                                                       cancelButtonTitle:@"Cancelar"
                                                       otherButtonTitles:nil];
                [alerta show];
                [alerta release];
            }];
            
            
        } else imageForca.image = [UIImage imageNamed:[NSString stringWithFormat:@"Chance%d.png", nErros]];
    }
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
    
    letrasTentadas = [[NSMutableArray alloc] init];
    palavra = [[NSString alloc] init];
    label = [[NSMutableString alloc] init];

    if ([GameCenterManager isGameCenterAvailable]) {
        
        self.gcManager = [[GameCenterManager alloc] init];
        [self.gcManager setDelegate:self];
        
    } else {
        // Não está disponivel
        
        NSLog(@"Não está disponivel.");
    }
    
    [self prepararJogo];
    
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

#pragma mark - GameCenterManager Delegate

- (void) achievementSubmitted: (GKAchievement *) ach error:(NSError*) error {
    if (error == NULL) {
        // Não teve erro!
        NSLog(@"Conquista enviada com sucesso.");
        NSLog(@"A conquista ganha: %@", ach.identifier);
        
    } else {
        // Teve erro!
        NSLog(@"Houve um erro no envio de conquista: %@", [error localizedDescription]);
    }
}

@end
