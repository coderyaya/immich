-- NOTE: This file is auto generated by ./sql-generator

-- SmartInfoRepository.searchCLIP
START TRANSACTION
SET
  LOCAL vectors.k = '100'
SELECT
  "a"."id" AS "a_id",
  "a"."deviceAssetId" AS "a_deviceAssetId",
  "a"."ownerId" AS "a_ownerId",
  "a"."libraryId" AS "a_libraryId",
  "a"."deviceId" AS "a_deviceId",
  "a"."type" AS "a_type",
  "a"."originalPath" AS "a_originalPath",
  "a"."resizePath" AS "a_resizePath",
  "a"."webpPath" AS "a_webpPath",
  "a"."thumbhash" AS "a_thumbhash",
  "a"."encodedVideoPath" AS "a_encodedVideoPath",
  "a"."createdAt" AS "a_createdAt",
  "a"."updatedAt" AS "a_updatedAt",
  "a"."deletedAt" AS "a_deletedAt",
  "a"."fileCreatedAt" AS "a_fileCreatedAt",
  "a"."localDateTime" AS "a_localDateTime",
  "a"."fileModifiedAt" AS "a_fileModifiedAt",
  "a"."isFavorite" AS "a_isFavorite",
  "a"."isArchived" AS "a_isArchived",
  "a"."isExternal" AS "a_isExternal",
  "a"."isReadOnly" AS "a_isReadOnly",
  "a"."isOffline" AS "a_isOffline",
  "a"."checksum" AS "a_checksum",
  "a"."duration" AS "a_duration",
  "a"."isVisible" AS "a_isVisible",
  "a"."livePhotoVideoId" AS "a_livePhotoVideoId",
  "a"."originalFileName" AS "a_originalFileName",
  "a"."sidecarPath" AS "a_sidecarPath",
  "a"."stackParentId" AS "a_stackParentId",
  "e"."assetId" AS "e_assetId",
  "e"."description" AS "e_description",
  "e"."exifImageWidth" AS "e_exifImageWidth",
  "e"."exifImageHeight" AS "e_exifImageHeight",
  "e"."fileSizeInByte" AS "e_fileSizeInByte",
  "e"."orientation" AS "e_orientation",
  "e"."dateTimeOriginal" AS "e_dateTimeOriginal",
  "e"."modifyDate" AS "e_modifyDate",
  "e"."timeZone" AS "e_timeZone",
  "e"."latitude" AS "e_latitude",
  "e"."longitude" AS "e_longitude",
  "e"."projectionType" AS "e_projectionType",
  "e"."city" AS "e_city",
  "e"."livePhotoCID" AS "e_livePhotoCID",
  "e"."state" AS "e_state",
  "e"."country" AS "e_country",
  "e"."make" AS "e_make",
  "e"."model" AS "e_model",
  "e"."lensModel" AS "e_lensModel",
  "e"."fNumber" AS "e_fNumber",
  "e"."focalLength" AS "e_focalLength",
  "e"."iso" AS "e_iso",
  "e"."exposureTime" AS "e_exposureTime",
  "e"."profileDescription" AS "e_profileDescription",
  "e"."colorspace" AS "e_colorspace",
  "e"."bitsPerSample" AS "e_bitsPerSample",
  "e"."fps" AS "e_fps"
FROM
  "assets" "a"
  INNER JOIN "smart_search" "s" ON "s"."assetId" = "a"."id"
  LEFT JOIN "exif" "e" ON "e"."assetId" = "a"."id"
WHERE
  ("a"."ownerId" = $1)
  AND ("a"."deletedAt" IS NULL)
ORDER BY
  "s"."embedding" <= > $2 ASC
LIMIT
  100
COMMIT

-- SmartInfoRepository.searchFaces
START TRANSACTION
SET
  LOCAL vectors.k = '100'
WITH
  "cte" AS (
    SELECT
      "faces"."id" AS "id",
      "faces"."assetId" AS "assetId",
      "faces"."personId" AS "personId",
      "faces"."imageWidth" AS "imageWidth",
      "faces"."imageHeight" AS "imageHeight",
      "faces"."boundingBoxX1" AS "boundingBoxX1",
      "faces"."boundingBoxY1" AS "boundingBoxY1",
      "faces"."boundingBoxX2" AS "boundingBoxX2",
      "faces"."boundingBoxY2" AS "boundingBoxY2",
      1 + ("faces"."embedding" <= > $1) AS "distance"
    FROM
      "asset_faces" "faces"
      INNER JOIN "assets" "asset" ON "asset"."id" = "faces"."assetId"
      AND ("asset"."deletedAt" IS NULL)
    WHERE
      "asset"."ownerId" = $2
    ORDER BY
      1 + ("faces"."embedding" <= > $3) ASC
    LIMIT
      100
  )
SELECT
  res.*
FROM
  "cte" "res"
WHERE
  res.distance <= $4
COMMIT