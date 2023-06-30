//
//  Hello.h
//  SignatureTest
//
//  Created by Sboat Chen on 2023/3/17.
//

#ifndef Hello_h
#define Hello_h

typedef struct {
    unsigned long length;
    unsigned char* content;
} ByteArrayData;

// https://github.com/suzp1984/jbig-android
// https://www.cl.cam.ac.uk/~mgk25/jbigkit/
ByteArrayData encodeToJbig(int width, int height, unsigned char* image);

#endif /* Hello_h */
