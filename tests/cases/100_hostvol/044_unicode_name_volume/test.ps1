# SUMMARY: Create a file with unicode characters in the name on a volume mount and check on the host
# LABELS:
# REPEAT:
# ISSUE: https://github.com/docker/for-win/issues/986

$libBase = Join-Path -Path $env:RT_PROJECT_ROOT -ChildPath _lib
$lib = Join-Path -Path $libBase -ChildPath lib.ps1
. $lib

$ret = 0

# based on: http://www.columbia.edu/~fdc/utf8/
$fileName = "test-我能吞下.txt"
$testPath = Join-Path -Path $env:TEST_TMP -ChildPath $fileName

Remove-Item -Force -Recurse -ErrorAction Ignore -Path $env:TEST_TMP
New-Item -ItemType Directory -Force -Path $env:TEST_TMP

docker container run --platform linux --rm -v  $env:TEST_TMP`:/test alpine:3.7 sh -c "touch /test/$fileName"
if ($lastexitcode -ne 0) { 
    exit 1
}

if (!(Test-Path $testPath -PathType leaf)) {
    $ret = 1
}

Remove-Item -Force -Recurse -ErrorAction Ignore -Path $env:TEST_TMP
exit $ret
