#import <UIKit/UIKit.h>

#import "GADRemoteModel.h"

@class SPARCPublication;

@interface SPARCArticle : GADRemoteModel

@property (nonatomic, strong) NSString * _Nonnull articleId;
@property (nonatomic, strong) NSArray * _Nullable authors;
@property (nonatomic, strong) NSString * _Nullable brief;
@property (nonatomic, strong) NSString * _Nullable content;
@property (nonatomic, strong) NSDate * _Nullable dateEdited;
@property (nonatomic, strong) NSDate * _Nullable datePublished;
@property (nonatomic, strong) UIImage * _Nullable headerImage;
@property (nonatomic, strong) NSURL * _Nullable headerImageURL;
@property (nonatomic, strong) NSString * _Nullable issue;
@property (nonatomic, strong) SPARCPublication * _Nullable publication;
@property (nonatomic, strong) NSString * _Nullable series;
@property (nonatomic, strong) NSArray * _Nullable tags;
@property (nonatomic, strong) NSString * _Nullable title;
@property (nonatomic, strong) NSURL * _Nullable url;

- (void) fetchFullTextWithCompletion:(void(^_Nonnull)(SPARCArticle *_Nullable article,
                                                      NSError *_Nullable error))completion;

+ (instancetype _Nonnull)articleFromDictionary:(NSDictionary *_Nonnull)dict;
+ (NSArray <SPARCArticle *> *_Nonnull)articlesFromArray:(NSArray<NSDictionary *> *_Nonnull)array;

@end

