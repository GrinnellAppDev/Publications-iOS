#import <Foundation/Foundation.h>

@interface GADRemoteModel : NSObject

typedef NSString* GADNextPageToken;
typedef NSArray<GADRemoteModel*>*_Nonnull(^GADModelTransformer)
                                          (NSArray<NSDictionary *>* _Nonnull objects);

typedef void (^GADRemoteCompletionHandler)(NSArray<GADRemoteModel *> *_Nullable models,
                                           GADNextPageToken _Nullable token,
                                           NSError *_Nullable error);

+ (void) fetchModelsWithURL:(NSURL * _Nonnull)url
            queryParameters:(NSDictionary * _Nullable)queryParams
               nextPageToken:(GADNextPageToken _Nullable)nextPageToken
           modelTransformer:(GADModelTransformer _Nonnull )modelTransformer
          completionHandler:(GADRemoteCompletionHandler _Nonnull )completion;

+ (NSURL *_Nonnull) baseURL;

@end
