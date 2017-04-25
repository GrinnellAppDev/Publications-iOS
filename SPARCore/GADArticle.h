#import "GADRemoteModel.h"
#import "GADPublication.h"

@interface GADArticle : GADRemoteModel

@property (nonatomic, strong) NSString * _Nonnull articleId;
@property (nonatomic, strong) NSArray * _Nullable authors;
@property (nonatomic, strong) NSString * _Nullable brief;
@property (nonatomic, strong) NSString * _Nullable content;
@property (nonatomic, strong) NSDate * _Nullable dateEdited;
@property (nonatomic, strong) NSDate * _Nullable datePublished;
@property (nonatomic, strong) NSURL * _Nullable headerImage;
@property (nonatomic, strong) NSString * _Nullable issue;
@property (nonatomic, strong) GADPublication * _Nullable publication;
@property (nonatomic, strong) NSString * _Nullable series;
@property (nonatomic, strong) NSArray * _Nullable tags;
@property (nonatomic, strong) NSString * _Nullable title;
@property (nonatomic, strong) NSURL * _Nullable url;

- (void) fetchFullTextWithCompletion: (void(^_Nonnull)(GADArticle *_Nullable article,
                                                       NSError *_Nullable error))completion;

+ (NSArray <GADArticle *> *_Nullable) articlesFromArray: (NSArray *_Nonnull)jsonArray;

+ (NSArray <GADArticle *> *_Nonnull) loadDummyArticles;

@end

