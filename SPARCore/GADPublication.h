#import "GADRemoteModel.h"

@interface GADPublication : GADRemoteModel

@property (nonatomic, strong) NSString *publicationId;
@property (nonatomic, strong) NSString *name;

+ (void) fetchPublicationsWithCompletionHandler:(void(^_Nonnull)(NSArray<GADPublication *> *_Nullable publications, NSError *_Nullable error))completion;

@end
