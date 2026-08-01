// Viewer-request: API-only hostname should not use default (SPA S3) behavior for GET /.
// Redirects exact path "/" to a path the private ALB already serves (e.g. service health).
function handler(event) {
    var request = event.request;
    var hostHdr = request.headers.host;
    var host = hostHdr ? hostHdr.value : "";
    var want = "${api_host}".toLowerCase();
    if (host.toLowerCase() === want && request.uri === "/") {
        return {
            statusCode: 302,
            statusDescription: "Found",
            headers: {
                "location": { value: "https://" + want + "${redirect_path}" }
            }
        };
    }
    return request;
}
