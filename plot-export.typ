#let output = state("output", none)
#let output-num = state("output-num", 0)
#let debug = state("debug", true)
#let count = counter("output")

#let fig(caption, body) = {
  context{
  let num = count.get().at(0)
  if (debug.get() and not num == 0){
    pagebreak()
  }
  if debug.get() {
    [Debug mode. Switch to the output mode in the show rules. \
    Figure No.~#num with caption: #caption]
  }
  if (debug.get() or caption == output.get() or num == output-num.get()){
    body
  }
  }
  count.step()
}

#let set-output(caption) = {
  output.update(caption)
}

#let set-debug(d) = {
  debug.update(d)
}

#let set-output-num(num) = {
  output-num.update(num)
}

#let plot-export(
  debug: false,
  output: none,
  output-num: -1,
  margin: 2pt,
  body
) = {
  set-debug(debug)
  set-output(output)
  set-output-num(output-num)

  
  set page(width: auto, height: auto, margin: margin)
  
  if output-num >= 0 and not (output == none) {
    [Please specify the rendered figure by caption #emph[or] number, but not by both!]
  } else {
    body
  }

  context{
    if not debug and output-num >= count.get().at(0) [Error: output-num larger than total figure number!]
  }
}
