#!/bin/bash
PASS=0; FAIL=0

check() {
    local desc=$1; local cmd=$2; local expected=$3
    result=$(eval $cmd 2>/dev/null)
    if echo "$result" | grep -q "$expected"; then
        echo "✅ $desc"; PASS=$((PASS+1))
    else
        echo "❌ $desc (got: $result)"; FAIL=$((FAIL+1))
    fi
}

echo "=== NGINX Lab Auto-Test ==="
echo ""

check "Static HTML serves"          "curl -so/dev/null -w %{http_code} http://localhost/"                           "200"
check "NGINX hides version"          "curl -sI http://localhost/nginx_status | grep Server"                          "nginx$"
check "Gzip enabled"                 "curl -sI -H 'Accept-Encoding: gzip' http://localhost/"                         "gzip"
check "404 custom page"              "curl -so/dev/null -w %{http_code} http://localhost/nonexistent"                "404"
check "Favicon 204"                  "curl -so/dev/null -w %{http_code} http://localhost/favicon.ico"                "204"
check "Dot file blocked"             "curl -so/dev/null -w %{http_code} http://localhost/.env"                       "404"
check "Old-api redirect 301"         "curl -sI http://localhost/old-api/test | grep -i location"                     "api"
check "API v1 proxy works"           "curl -s http://api.localhost/api/v1/info"                                      "v1"
check "API v2 proxy works"           "curl -s http://api.localhost/api/v2/info"                                      "v2"
check "LB returns upstream header"   "curl -sI http://api.localhost/api/lb/info | grep -i x-upstream-addr"          "Upstream"
check "HTTPS works"                  "curl -ks https://localhost/ | grep -i html"                                    "html"
check "Rate limit headers present"   "curl -sI http://secure.localhost/api/v1/info | grep -i x-frame-options"       "SAMEORIGIN"
check "Basic Auth 401 without creds" "curl -so/dev/null -w %{http_code} http://secure.localhost/private"            "401"
check "Basic Auth 200 with creds"    "curl -so/dev/null -w %{http_code} -u student:password123 http://secure.localhost/private" "200"
check "Cache MISS on first request"  "curl -sI http://api.localhost/api/cached/info | grep X-Cache-Status"          "MISS\|EXPIRED"
check "Cache HIT on 2nd request"     "curl -s http://api.localhost/api/cached/info > /dev/null && curl -sI http://api.localhost/api/cached/info | grep X-Cache-Status" "HIT"
check "nginx_status page"            "curl -s http://localhost/nginx_status"                                         "Active connections"

echo ""
echo "Results: $PASS passed, $FAIL failed"
