#import "GADRemoteModel.h"

@interface GADPublication : GADRemoteModel

@property (nonatomic, strong) NSString *publicationId;
@property (nonatomic, strong) NSString *name;

+ (void) fetchAllWithNextPageToken:(NSString * _Nullable)nextPageToken
                        Completion:(void(^_Nonnull)(NSArray<GADPublication *> *_Nullable publications, NSString *_Nullable token, NSError *_Nullable error))completion;

- (NSURL *) urlForArticles;

@end
