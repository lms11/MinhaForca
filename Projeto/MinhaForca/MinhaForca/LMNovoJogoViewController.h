//
//  LMNovoJogoViewController.h
//  MinhaForca
//
//  Created by Lucas Moreira on 05/11/11.
//  Copyright (c) 2011 Lucas Moreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMForcaViewController.h"

@interface LMNovoJogoViewController : UIViewController {
    IBOutlet UIPickerView *pickerViewCategorias;
    IBOutlet UIButton *buttonComecarJogo;
    IBOutlet UIButton *buttonVoltar;
    
    NSArray *categorias;
}

- (IBAction)comecarJogo:(id)sender;
- (IBAction)voltar:(id)sender;

@end
