#!/bin/sh

#  BuildFramework.sh
#  FrameworkTest
#
#  Created by Ben Gottlieb on 3/17/17.
#  Copyright (c) 2015 Stand Alone, Inc. All rights reserved.

BASE_BUILD_DIR="${BUILD_DIR}/Products"
FRAMEWORK_NAME="SwiftVG"
IOS_SUFFIX=""
MAC_SUFFIX=""
CONFIG=$CONFIGURATION
UNIVERSAL_OUTPUTFOLDER="Build/${CONFIG}-universal"
PROJECT_NAME="SwiftVG"
IOS_FRAMEWORKS=/Users/ben/Documents/ManagedProjects/Frameworks/iOS_Builds
MAC_FRAMEWORKS=/Users/ben/Documents/ManagedProjects/Frameworks/Mac_Builds

GIT_BRANCH=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1/"`
GIT_REV=`git rev-parse --short HEAD`

BUILD_DATE=`date "+%c%m%d%H%M%S"`
BRANCH=`git rev-parse --abbrev-ref HEAD`
BUILD_NUMBER=`echo $(expr $(git rev-list $BRANCH --count) - $(git rev-list HEAD..$BRANCH --count))`

IOS_PLIST_PATH="${PROJECT_DIR}/SwiftVG/iOS/info.plist"
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Add :branch string ${GIT_BRANCH}"
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Add :rev string ${GIT_REV}"
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Add :built string ${BUILD_DATE}"
/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Add :git_number string ${BUILD_NUMBER}"

MAC_PLIST_PATH="${PROJECT_DIR}/SwiftVG/Mac/info.plist"
/usr/libexec/PlistBuddy "${MAC_PLIST_PATH}" -c "Add :branch string ${GIT_BRANCH}"
/usr/libexec/PlistBuddy "${MAC_PLIST_PATH}" -c "Add :rev string ${GIT_REV}"
/usr/libexec/PlistBuddy "${MAC_PLIST_PATH}" -c "Add :built string ${BUILD_DATE}"
/usr/libexec/PlistBuddy "${MAC_PLIST_PATH}" -c "Add :git_number string ${BUILD_NUMBER}"

echo "plists updated"
# make sure the output directory exists
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"

# Step 1. Build Device and Simulator versions
xcodebuild -target "${PROJECT_NAME}_iOS" -configuration ${CONFIG} -sdk "iphoneos" ONLY_ACTIVE_ARCH=NO  BUILD_DIR="${BASE_BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" OTHER_CFLAGS="-fembed-bitcode" clean build
echo "Device Build complete"
xcodebuild -target "${PROJECT_NAME}_iOS" -configuration ${CONFIG} -sdk "iphonesimulator" ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BASE_BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
echo "Simulator Build Complete"

xcodebuild -target "${PROJECT_NAME}_Mac" -configuration ${CONFIG} ONLY_ACTIVE_ARCH=NO BUILD_DIR="${BASE_BUILD_DIR}" BUILD_ROOT="${BUILD_ROOT}" clean build
echo "Mac Build Complete"

sleep 1s

# Step 2. Copy the framework structure (from iphoneos build) to the universal folder
echo "copying device framework"
cp -R "${BASE_BUILD_DIR}/${CONFIG}-iphoneos/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework" "${UNIVERSAL_OUTPUTFOLDER}/"

# Step 3. Copy Swift modules (from iphonesimulator build) to the copied framework directory
echo "integrating sim framework"
cp -R "${BASE_BUILD_DIR}/${CONFIG}-iphonesimulator/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/Modules/${FRAMEWORK_NAME}${IOS_SUFFIX}.swiftmodule/" "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/Modules/${FRAMEWORK_NAME}${IOS_SUFFIX}.swiftmodule/"
#remove unneded Code Signature artifacts
rm -f "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/_CodeSignature/CodeDirectory"
rm -f "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/_CodeSignature/CodeRequirements"
rm -f "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/_CodeSignature/CodeSignature"


# Step 4. Create universal binary file using lipo and place the combined executable in the copied framework directory
echo "lipo'ing files"
lipo -create -output "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/${FRAMEWORK_NAME}${IOS_SUFFIX}" "${BASE_BUILD_DIR}/${CONFIG}-iphonesimulator/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/${FRAMEWORK_NAME}${IOS_SUFFIX}" "${BASE_BUILD_DIR}/${CONFIG}-iphoneos/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework/${FRAMEWORK_NAME}${IOS_SUFFIX}"

echo "copying to iOS Framework folder"
# Step 5. Convenience step to copy the framework to the project's directory
mkdir -p "${PROJECT_DIR}/iOS Framework/"
rm -rf "${PROJECT_DIR}/iOS Framework/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework"
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}${IOS_SUFFIX}.framework" "${PROJECT_DIR}/iOS Framework"

# Step 6. Copy the Mac framework
echo "copying to Mac OS Framework folder"
mkdir -p "${PROJECT_DIR}/Mac Framework/"
	rm -rf "${PROJECT_DIR}/Mac Framework/${FRAMEWORK_NAME}.framework"
cp -R "${BASE_BUILD_DIR}/${CONFIG}/${FRAMEWORK_NAME}.framework" "${PROJECT_DIR}/Mac Framework"

# Step 7. Copy the iOS framework to the /iOS_Builds folder
if [ ! -d "${IOS_FRAMEWORKS}" ]; then
	mkdir "${IOS_FRAMEWORKS}"
fi

if [ -d "${IOS_FRAMEWORKS}/${FRAMEWORK_NAME}.framework" ]; then
	rm -rf "${IOS_FRAMEWORKS}/${FRAMEWORK_NAME}.framework"
fi

echo 'Copying: ${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework  ${IOS_FRAMEWORKS}/${FRAMEWORK_NAME}.framework'
cp -R "${UNIVERSAL_OUTPUTFOLDER}/${FRAMEWORK_NAME}.framework" "${IOS_FRAMEWORKS}/${FRAMEWORK_NAME}.framework"


# Step 8. Copy the Mac framework to the /Mac_Builds folder
if [ ! -d "${MAC_FRAMEWORKS}" ]; then
	mkdir "${MAC_FRAMEWORKS}"
fi

if [ -d "${MAC_FRAMEWORKS}/${FRAMEWORK_NAME}.framework" ]; then
	rm -rf "${MAC_FRAMEWORKS}/${FRAMEWORK_NAME}.framework"
fi

cp -R "${BASE_BUILD_DIR}/${CONFIG}/${FRAMEWORK_NAME}.framework" "${MAC_FRAMEWORKS}/${FRAMEWORK_NAME}.framework"


$(/usr/libexec/PlistBuddy "${MAC_PLIST_PATH}" -c "Delete :branch" 2> /dev/null)
$(/usr/libexec/PlistBuddy "${MAC_PLIST_PATH}" -c "Delete :rev" 2> /dev/null)
$(/usr/libexec/PlistBuddy "${MAC_PLIST_PATH}" -c "Delete :built" 2> /dev/null)
$(/usr/libexec/PlistBuddy "${MAC_PLIST_PATH}" -c "Delete :git_number" 2> /dev/null)

$(/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Delete :branch" 2> /dev/null)
$(/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Delete :rev" 2> /dev/null)
$(/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Delete :built" 2> /dev/null)
$(/usr/libexec/PlistBuddy "${IOS_PLIST_PATH}" -c "Delete :git_number" 2> /dev/null)

# Step 7. Convenience step to open the project's directory in Finder
#open "${PROJECT_DIR}"
