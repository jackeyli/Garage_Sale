/**
 * Copyright 2016 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for t`he specific language governing permissions and
 * limitations under the License.
 */
'use strict';

const functions = require('firebase-functions');
const mkdirp = require('mkdirp-promise');
const admin = require('firebase-admin');
admin.initializeApp();
const spawn = require('child-process-promise').spawn;
const path = require('path');
const os = require('os');
const fs = require('fs');
const IMG_PATH = 'Images';

// Max height and width of the thumbnail in pixels.
const THUMB_MAX_HEIGHT = 300;
const THUMB_MAX_WIDTH = 300;
// Thumbnail prefix added to file names.
const THUMB_PREFIX = 'thumbnails';
const THUMB_PREFIX_FILENAME = 'Thumb_';

/**
 * When an image is uploaded in the Storage bucket We generate a thumbnail automatically using
 * ImageMagick.
 * After the thumbnail has been generated and uploaded to Cloud Storage,
 * we write the public URL to the Firebase Realtime Database.
 */
exports.generateThumbnail = functions.storage.object().onFinalize(async (object) => {
  // File and directory paths.
  const filePath = object.name;

  // Exit if this is triggered on a file that is not an image.
  // Exit if the image is already a thumbnail.
  if(!filePath.startsWith(IMG_PATH)) {
    return console.log('Not a image');
  }
  if(filePath.startsWith(path.join(IMG_PATH,THUMB_PREFIX).toString())) {
    return console.log('Already is thumbnail');
  }
    const contentType = object.contentType; // This is the image MIME type
    const fileDir = path.dirname(filePath);
    const innerPath = fileDir.substr(7,fileDir.length - 7);
    const fileName = path.basename(filePath);
    const thumbFilePath = path.normalize(path.join(path.join(IMG_PATH,path.join(THUMB_PREFIX,innerPath)), `${fileName}`));
    const tempLocalFile = path.join(os.tmpdir(), filePath);
    const tempLocalDir = path.dirname(tempLocalFile);
    const tempLocalThumbFile = path.normalize(path.join(path.join(os.tmpdir(),fileDir),`${THUMB_PREFIX_FILENAME}${fileName}`));
  // Cloud Storage files.
  const bucket = admin.storage().bucket(object.bucket);
  const file = bucket.file(filePath);
  const thumbFile = bucket.file(thumbFilePath);
  const metadata = {
    contentType: contentType,
    // To enable Client-side caching you can set the Cache-Control headers here. Uncomment below.
    // 'Cache-Control': 'public,max-age=3600',
  };

  // Create the temp directory where the storage file will be downloaded.
  await mkdirp(tempLocalDir)
  // Download file from bucket.
  await file.download({destination: tempLocalFile});
  console.log('The file has been downloaded to', tempLocalFile);
  // Generate a thumbnail using ImageMagick.
  await spawn('convert', [tempLocalFile, '-thumbnail', `${THUMB_MAX_WIDTH}x${THUMB_MAX_HEIGHT}>`, tempLocalThumbFile], {capture: ['stdout', 'stderr']});
  console.log('Thumbnail created at', tempLocalThumbFile);
  // Uploading the Thumbnail.
  await bucket.upload(tempLocalThumbFile, {destination: thumbFilePath, metadata: metadata});
  console.log('Thumbnail uploaded to Storage at', thumbFilePath);
  // Once the image has been uploaded delete the local files to free up disk space.
  fs.unlinkSync(tempLocalFile);
  fs.unlinkSync(tempLocalThumbFile);
});
