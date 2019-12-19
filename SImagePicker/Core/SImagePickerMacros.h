//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerMacros.h
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/6/20: Created by Cyrex on 2019/6/20
//

#ifndef SImagePickerMacros__H_
#define SImagePickerMacros__H_

// MARK: -
// MARK: - Color
#ifndef SColorFromHexWithAlpha
    #define SColorFromHexWithAlpha(hexValue,a)                                          \
                [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0    \
                                green:((float)((hexValue & 0xFF00) >> 8)) / 255.0       \
                                 blue:((float)(hexValue & 0xFF)) / 255.0                \
                                alpha:a]
#endif

#ifndef SColorFromHex
    #define SColorFromHex(hexValue) SColorFromHexWithAlpha(hexValue, 1.0)
#endif

#ifndef SColorFromRGBA
    #define SColorFromRGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue: b / 255.0 alpha:a]
#endif

#ifndef SColorFromRGB
    #define SColorFromRGB(r, g, b) SColorFromRGBA(r, g, b, 1.0)
#endif

#ifndef SColorFronHSB
    #define SColorFronHSB(h, s, b) [UIColor colorWithHue:h saturation:s brightness:b alpha:1.0f]
#endif

#endif /* SImagePickerMacros__H_ */
