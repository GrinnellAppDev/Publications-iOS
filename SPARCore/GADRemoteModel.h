//
//  GADRemoteModel.h
//  Publications
//
//  Created by Addison Gould on 3/5/17.
//  Copyright © 2017 comp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GADRemoteModel : NSObject

+ (void) fetchArticlesFromPublication: (NSString *)publicationId completionHandler:(void(^_Nonnull)(NSData*))completion;

@end
