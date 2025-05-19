-- #popclip
-- name: website
-- identifier: logan.website
-- description: 搜索引擎
-- icon: square filled scale=92 symbol:globe
-- requirements: ["text"]
-- language: applescript

tell application id "com.runningwithcrayons.Alfred" to run trigger "website_for_popclip" in workflow "com.logan.url" with argument "{popclip text}" & "::logan##split::" & "{popclip bundle identifier}"
