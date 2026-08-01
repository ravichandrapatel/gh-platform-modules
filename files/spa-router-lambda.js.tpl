// Lambda@Edge viewer-request: SPA routing for path_prefix. path_prefix is injected by Terraform.
exports.handler = function handler(event, context, callback) {
    var request = event.Records[0].cf.request;
    var uri = request.uri;
    var pathPrefix = "${path_prefix}";

    // 1. Redirect base path to trailing slash so the browser treats it as a folder (fixes asset MIME issues).
    if (uri === pathPrefix) {
        var qs = request.querystring || {};
        var qsParts = [];
        for (var k in qs) {
            if (qs[k].length > 0) qsParts.push(k + "=" + encodeURIComponent(qs[k][0].value));
        }
        var qsStr = qsParts.length > 0 ? "?" + qsParts.join("&") : "";
        return callback(null, {
            status: "301",
            statusDescription: "Moved Permanently",
            headers: { "location": [{ "key": "Location", "value": pathPrefix + "/" + qsStr }] }
        });
    }

    // 2. Internal rewrite: root of path prefix
    if (uri === pathPrefix + "/") {
        request.uri = pathPrefix + "/index.html";
        return callback(null, request);
    }

    // 3. SPA routing: path under prefix with no extension -> index.html
    if (uri.indexOf(pathPrefix + "/") === 0 && uri.indexOf(".") === -1) {
        request.uri = pathPrefix + "/index.html";
    }

    return callback(null, request);
};
