
#define CSSingletonM \
static id _instance;\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    \
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [super allocWithZone:zone];\
    });\
    \
    return _instance;\
    \
}\
\
+ (instancetype) shareInstance {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc] init];\
    });\
    \
    return _instance;\
}\
\
- (id)copyWithZone:(NSZone *)zone{\
    return _instance;\
}

#define CSSingletonH + (instancetype) shareInstance;