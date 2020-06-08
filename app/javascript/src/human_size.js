export default function(bytes) {
  const exp = (Math.log(bytes) / Math.log(1024)) | 0
  let result = (bytes / Math.pow(1024, exp))
  const precision = result < 0 ? 2 : 1
  result = result.toFixed(precision)
  const addition = exp === 0 ? "bytes" : "KMGTPEZY"[exp - 1] + "B"
  return `${result} ${addition}`
}
