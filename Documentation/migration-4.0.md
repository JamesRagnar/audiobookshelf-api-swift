# AudiobookshelfAPI 4.0 migration

The combined v2.36.1 contract update targets package release **4.0.0**. The package continues to
support Audiobookshelf servers from **2.26.0 through 2.36.x**.

## Source-breaking changes

`GetAuthSettings.Response.authOpenIDTokenSigningAlgorithm` and
`GetAuthSettings.Response.authOpenIDButtonText` are now `String?`. Callers must handle a server-returned
null rather than relying on the former constructor-default assumptions.

`GetAuthSettings.Response` now exposes the complete admin response, including nullable client ID, client
secret, redirect URIs, group claims, advanced permissions claims, and the required JSON-encoded sample
permissions string. The admin-only fields are not part of `ServerSettings` browser output.

`Series` now exposes the optional `seriesSequenceList` string used by filtered subseries responses.

## Deprecated compatibility surface

The seven legacy `UpdateServerSettings` properties and initializer arguments remain available with their
existing types and encoding. They are deprecated because Audiobookshelf v2.36.1 and later ignore them;
they are still useful for older supported servers and are not automatically omitted.

`UploadFile.Request(fileData:contentType:libraryId:folderId:)` remains available as a deprecated raw-body
escape hatch. New callers should use the throwing structured multipart initializer.
