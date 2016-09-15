# [TextMiner](https://lzys90.shinyapps.io/TextMiner/)

[![Build Status](https://travis-ci.org/lyzs90/TextMiner.svg)](https://travis-ci.org/lyzs90/TextMiner) [![Coverage Status](https://coveralls.io/repos/github/lyzs90/TextMiner/badge.svg?branch=master)](https://coveralls.io/github/lyzs90/TextMiner?branch=master)


Text Miner makes basic text mining painless.

## Dependencies

- shiny
- tm
- SnowballC
- worldcloud
- ggplot2
- ggdendro

## How to Use

Upload a single column text file containing the text to be analyzed. TextMiner will treat each row in the file as a separate document.

## Local Deployment

Clone a copy of this repo, install the dependencies, then run the following code:
  
```R
shiny::runApp()
```

For showcase mode:

```R
shiny::runApp(display.mode="showcase")
```

## License

Code released under [the MIT license](https://github.com/lyzs90/TextMiner/blob/master/LICENSE.txt).