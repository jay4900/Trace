//
//  ChinaMapShift.h
//  TestXml
//
//  Created by wuffy on 15-5-9.
//  Copyright (c) 2015年 wuffy. All rights reserved.
//

#ifndef __TestXml__ChinaMapShift__
#define __TestXml__ChinaMapShift__

#include <stdio.h>

typedef struct {
    double lng;
    double lat;
} Location;
Location LocationMake(double lat, double lng);

//世界坐标转火星坐标
Location transformFromWGSToGCJ(Location wgLoc);
//火星坐标转世界坐标
Location transformFromGCJToWGS(Location gcLoc);

//火星坐标转百度坐标
Location transformFromGCJToBD(Location gcLoc);
//百度坐标转火星坐标
Location transformFromBDToGCJ(Location bdLoc);
    
//百度坐标转世界坐标
Location transformFromBDToWGS(Location bdLoc);
//世界坐标转百度坐标
Location transformFromWGSToBD(Location wgLoc);


#endif /* defined(__TestXml__ChinaMapShift__) */
