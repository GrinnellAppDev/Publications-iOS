#import <Foundation/Foundation.h>

@interface GADRemoteModel : NSObject

+ (void) fetchModelsWithParams:(NSURL * _Nonnull)baseURL
               queryParameters:(NSDictionary * _Nullable)queryParams
              modelTransformer:(NSArray<GADRemoteModel *>*_Nonnull(^_Nonnull)
                                (NSArray<NSDictionary *>* _Nonnull objects))modelTransformer
             completionHandler:(void(^_Nonnull)(NSArray<GADRemoteModel *> *_Nullable models, NSString *_Nullable token, NSError *_Nullable error))completion;

+ (NSURL *_Nonnull) baseURL;

@end
