//
//  GADRemoteModel.h
//  Publications
//
//  Created by Addison Gould on 3/5/17.
//  Copyright © 2017 comp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GADRemoteModel : NSObject

+ (void) fetchModelsWithParams: (NSDictionary * _Nonnull)queryParams
            modelTransformer:(NSArray<GADRemoteModel *>*_Nonnull(^_Nonnull)
                              (NSData* _Nonnull jsonData))modeltransformer
           completionHandler:(void(^_Nonnull)(NSArray<GADRemoteModel *> *_Nullable models,
                                              NSError *_Nullable error))completion;

@end
