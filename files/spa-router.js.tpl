// Viewer-request: SPA routing for path_prefix. Matches RxCatalog frontend: Vite base (e.g. /rxcatalog/),
// React Router basename, and all app routes (e.g. /rxcatalog/login, /rxcatalog/dashboard, /rxcatalog/equipment/approval/:id).
// path_prefix is injected by Terraform (e.g. /rxcatalog); no trailing slash.
function handler(event) {
    var request = event.request;
    var uri = request.uri;
    var pathPrefix = "${path_prefix}";
    if (pathPrefix.length > 1 && pathPrefix.charAt(pathPrefix.length - 1) === "/") {
        pathPrefix = pathPrefix.slice(0, -1);
    }
    var pathPrefixSlash = pathPrefix + "/";

    // 1. Redirect base path without trailing slash to with slash (matches Vite base; fixes asset MIME).
    if (uri === pathPrefix) {
        var qs = event.request.querystring;
        var qsStr = "";
        if (qs && Object.keys(qs).length > 0) {
            qsStr = "?" + Object.keys(qs).map(function(k) { return k + "=" + encodeURIComponent(qs[k].value); }).join("&");
        }
        return {
            statusCode: 301,
            statusDescription: "Moved Permanently",
            headers: { "location": { value: pathPrefixSlash + qsStr } }
        };
    }

    // 2. Root under prefix: serve index.html (Vite/React entry).
    if (uri === pathPrefixSlash) {
        request.uri = pathPrefixSlash + "index.html";
        return request;
    }

    // 3. SPA routes: any path under prefix with no file extension -> index.html (React Router handles /login, /dashboard, etc.).
    if (uri.lastIndexOf(pathPrefixSlash, 0) === 0 && uri.indexOf(".") === -1) {
        request.uri = pathPrefixSlash + "index.html";
    }

    return request;
}
