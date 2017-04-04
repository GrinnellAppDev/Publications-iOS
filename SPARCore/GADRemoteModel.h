#import <Foundation/Foundation.h>

@interface GADRemoteModel : NSObject

+ (void) fetchModelsWithParams: (NSDictionary * _Nonnull)queryParams
            modelTransformer:(NSArray<GADRemoteModel *>*_Nonnull(^_Nonnull)
                              (NSData* _Nonnull jsonData))modeltransformer
           completionHandler:(void(^_Nonnull)(NSArray<GADRemoteModel *> *_Nullable models,
                                              NSError *_Nullable error))completion;

@end
