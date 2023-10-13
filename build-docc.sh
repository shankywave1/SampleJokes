##!/bin/sh

xcrun xcodebuild docbuild \
    -scheme SampleJokes \
    -destination 'generic/platform=iOS Simulator' \
    -derivedDataPath "$PWD/.derivedData"

xcrun docc process-archive transform-for-static-hosting \
    "$PWD/.derivedData/Build/Products/Debug-iphonesimulator/SampleJokes.doccarchive" \
    --output-path ".docs" \
    --hosting-base-path "SampleJokes" # add your repo name later

echo '<script>window.location.href += "/documentation/samplejokes"</script>' > .docs/index.html

#openssl base64 -in AppleDevelopmentKauai.p12 -A | tr -d '\n' > AppleDevelopmentKauai_base64.txt
#openssl base64 -in Universal_development.mobileprovision -A | tr -d '\n' > Universal_development_base64.txt
