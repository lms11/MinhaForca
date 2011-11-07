//
//  LMForcaViewController.h
//  MinhaForca
//
//  Created by Lucas Moreira on 05/11/11.
//  Copyright (c) 2011 Lucas Moreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "AppSpecificValues.h"

@interface LMForcaViewController : UIViewController <GameCenterManagerDelegate> {
    IBOutlet UIImageView *imageForca;
    IBOutlet UILabel *labelPalavra;
    
    NSMutableArray *letrasTentadas; // As LETRAS que o usuário já tocou no teclado
    NSString *palavra;              // Nossa PALAVRA sorteada que o usuário deverá descobrir
    NSMutableString *label;         // A string atual de como se encontra a label do usuário (PALAVRA que tem que descobrir)
    
    int categoriaID;    // Nossa categoria, usamos somente 1 vez: para sortear a palavra que o usuário deverá adivinhar
    int nErros;         // Número de erros
    int nLetras;        // Número de letras escondidas
    
    GameCenterManager *gcManager;
}

@property (nonatomic, retain) GameCenterManager *gcManager;
@property (nonatomic, assign) int categoriaID;
@property (nonatomic, retain) NSMutableArray *letrasTentadas;
@property (nonatomic, retain) NSString *palavra;

- (IBAction)tecladoTocado:(id)sender;
- (IBAction)sairDoJogo:(id)sender;
- (void)prepararJogo;
- (void)checarForca:(NSString *)novaLetra;

@end

@interface NSString (StringForca)
- (NSArray *)getIndexesOf:(NSString *)string;
@end