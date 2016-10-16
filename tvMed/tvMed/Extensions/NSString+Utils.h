//
//  NSString+Utils.h
//  ishop
//
//  Created by Thiago Lioy on 2/22/15.
//  Copyright (c) 2015 Concrete Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Utils)

-(NSString *)asEscapedURL;
-(NSString *)asCurrency;
-(NSString *)removeSpecialChars;
-(NSString *)encodeURL;
-(NSString *)formatData;
-(BOOL)hasOnlyCharactersInSet:(NSCharacterSet *)set;
-(BOOL)hasOnlyCharacters:(NSString *)stringOfCharacters;
-(NSMutableAttributedString *)cellInformationParagraphAttributedString;
-(NSNumber *)convertStringToNumber:(NSString *)value;
+ (BOOL) isEmpty:(NSString *) strTemp;

@end
