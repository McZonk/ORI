#import "ImageScrollView.h"


@interface ImageScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) UIImageView* imageView;

@property (nonatomic, assign) CGSize previousBoundsSize;

- (void)updateScrollView;

@end


@implementation ImageScrollView

- (void)setupImageScrollView {
	self.showsVerticalScrollIndicator = YES;
	self.showsHorizontalScrollIndicator = YES;
	self.bouncesZoom = YES;
	self.decelerationRate = UIScrollViewDecelerationRateFast;
	self.delegate = self;
	
	self.imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
	
	[self addSubview:self.imageView];
}

- (id)init {
	return [super initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if(self != nil) {
		[self setupImageScrollView];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder {
	self = [super initWithCoder:coder];
	if(self != nil) {
		[self setupImageScrollView];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
}

- (void)layoutSubviews  {
    [super layoutSubviews];
	
	if(!CGSizeEqualToSize(self.bounds.size, self.previousBoundsSize)) {
		self.previousBoundsSize = self.bounds.size;
		
		[self updateScrollView];
	}
	
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    if(frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
	} else {
        frameToCenter.origin.x = 0;
	}
    
	if(frameToCenter.size.height < boundsSize.height) {
		frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
	} else {
		frameToCenter.origin.y = 0;
	}

	self.imageView.frame = frameToCenter;
}

- (void)updateScrollView {
	self.zoomScale = 1.0f;
	
	CGSize boundsSize = self.bounds.size;
	if(boundsSize.width == 0.0f || boundsSize.height == 0.0f) {
		return;
	}
	
	CGSize imageSize = self.imageView.image.size;
	imageSize.width *= self.imageView.image.scale;
	imageSize.height *= self.imageView.image.scale;
	
	CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
	
	CGFloat maxScale = 1.0f;
	if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		maxScale = 1.0 / [[UIScreen mainScreen] scale];
	}
	
	maxScale *= 2.0f;

    if(minScale > maxScale) {
        minScale = maxScale;
    }
	
	self.imageView.bounds = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
	
    self.contentSize = imageSize;
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    self.zoomScale = minScale;
	
	[self setNeedsLayout];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
    return self.imageView;
}


- (UIImage*)image {
	return self.imageView.image;
}

- (void)setImage:(UIImage*)image {
	self.imageView.image = image;
	
	[self updateScrollView];
}

@synthesize imageView;

@synthesize previousBoundsSize;

@end
