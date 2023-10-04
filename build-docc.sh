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

