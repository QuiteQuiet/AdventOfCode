This is just mine but still.

If you come here looking for the script that downloads the input data from https://adventofcode.com/,
look in lib/aoc_help.

`fromSite()` fetches the data and stores locally in `input.txt`.
`fetch()` will first try to read a local file by name of `input.txt`. Only if that fails will it use `fromSite()` to get the input data.