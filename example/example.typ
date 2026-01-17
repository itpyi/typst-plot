#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "../plot-export.typ": *
#set text(font: "New Computer Modern")
#show math.equation: set text(font: "New Computer Modern Math")
#let colors = (maroon, olive, eastern)

// #let output = 1
// #let debug = true

#show: plot-export.with(
  debug: true, // select a figure to output by caption or number, then set debug to false
  output: "qrm-sc",
  // output-num: 3
)

// ========================= flow chart ================================

#fig("flow chart")[
#diagram(
	edge-stroke: 1pt,
	node-corner-radius: 5pt,
	edge-corner-radius: 8pt,
	mark-scale: 80%,
 node-stroke: black,

	node((0,0), [surface code cycles ($d=3$)]),
	node((0,1), [QRM code cycles ($d=3$)]),
	node((2,0), [lattice surgery]),
	node((3,0), [surface code cycles ($d=3$)]),
	node((4,0), [surface code cycles ($d=7$)], stroke: (dash: "dashed")),

	edge((0,0), "r,r", "-}>"),
	edge((0,1), "r,u,r", "-}>"),
	edge((2,0), "r", "-}>"),
	edge((3,0), "r", "-}>"),
)
]


// ========================= Quantum circuit ================================

#fig("circuit")[
#import "@preview/quill:0.7.2" as quill: tequila as tq
#import "@preview/quill:0.7.2": *
#import "@preview/physica:0.9.7": ket

#set text(9pt)

#stack(
dir: ltr,
quantum-circuit(
..tq.build(
  tq.cx(0, 4),
  tq.cx(1, 4),
  tq.gate(4, text(red)[$Z$], stroke: red, radius: 10pt),
  tq.cx(2, 4),
  tq.gate(2, text(red)[$Z$], stroke: white),
  tq.cx(3, 4),
  tq.gate(3, text(red)[$Z$], stroke: white),
  tq.gate(4, text(red)[$Z$], stroke: white),
),
lstick([data\ qubits], n: 4), [\ ], [\ ], [\ ], [\ ],
lstick($ket(0)$), 8, gate($M_Z$)
),
h(2em),
quantum-circuit(
..tq.build(
  tq.cx(5, 4),
  tq.cx(0, 4),
  tq.cx(1, 4),
  tq.gate(4, text(red)[$Z$], stroke: red, radius: 10pt),
  tq.cx(2, 4),
  tq.gate(2, text(red)[$Z$], stroke: white),
  tq.cx(3, 4),
  tq.gate(3, text(red)[$Z$], stroke: white),
  tq.cx(5, 4),
),
lstick([data\ qubits], n: 4), [\ ], [\ ], [\ ], [\ ],
lstick($ket(0)$), 7, gate(text(red)[$Z$], stroke: white), gate($M_Z$), [\ ],
setwire(1, stroke: blue), lstick($ket(+)$), 7, gate(text(red)[$Z$], stroke: white), gate($M_X$)
)
)
]


// ========================= Grow surface code ================================

#fig("grow")[
  #import "@preview/qec-thrust:0.1.1": *

#canvas({
  import draw: *
  let arrow-style = (
    stroke: rgb("#888") + 5pt,
    mark: (end: "stealth", size: 15pt),
  )
  let square(color, type, pos, r:0.08, l:1) = {
    circle(pos, radius: r, stroke: none, fill: black)
    circle((pos.at(0) - l, pos.at(1) - 0), radius: r, stroke: none, fill: black)
    circle((pos.at(0) - 0, pos.at(1) - l), radius: r, stroke: none, fill: black)
    circle((pos.at(0) - l, pos.at(1) - l), radius: r, stroke: none, fill: black)
    rect(pos, (pos.at(0) - l, pos.at(1) - l), fill:color)
    content(pos, type, anchor: "south-west", padding: 2pt)
    content((pos.at(0) - l, pos.at(1) - 0), type, anchor: "south-east", padding: 2pt)
    content((pos.at(0) - 0, pos.at(1) - l), type, anchor: "north-west", padding: 2pt)
    content((pos.at(0) - l, pos.at(1) - l), type, anchor: "north-east", padding: 2pt)
  }

  square(red, $X$, (-2, -1))
  square(aqua, $Z$, (-2, -3))
  let n = 3
  surface-code((0, -n), n, n, size:1, color1:red, color2:aqua, type-tag:false)
  let m = 7
  for i in range(m) {
    for j in range(m) {
      let color = red
      let bit-stroke = black
      let r = 0.1
      if (i < n) {
        color = aqua
        bit-stroke = black
        if (j < n) {
          color = black
          bit-stroke = none
          r = 0.08
        }
      }
      circle((i, -1 - j), radius:r, fill: color, stroke: bit-stroke)
    }
  } 
  line(
    (m, -(m+1)/2),
    (m + 2, -(m+1)/2),
    ..arrow-style,
  )
  // content((m+1, -(m+1)/2),[One round of\ syndrome measurement])
  surface-code((m+3, -m), m, m, size:1, color1:red, color2:aqua, type-tag:false)
  // surface-code((4, 0), 15, 7,color1:red,color2:green,size:0.5,type-tag: false)
})
]

// ========================= illustration ================================

#let to_2d_coord(coord) = {
  let a = -0.3
  let b = -0.5
  let c = 1
  let d = 0
  let x = coord.at(0)
  let y = coord.at(1)
  let z = coord.at(2)
  return (a*x + c*y, b*x + d*y + z)
}

#let get_bit(n, index) = {
  let mask = calc.pow(2, index)
  let bit_value = calc.rem-euclid(calc.quo(n, mask),2)
  return bit_value
}

#let qrm_coords(l) = {
  let coords = ((0, 0),)
  let x_list = (0, l, l/2, l/2)
  let y_list = (0, 0, -l/2*calc.sqrt(3), -l/(2*calc.sqrt(3)))
  let z_list = (0, 0, 0, l*calc.sqrt(2)/calc.sqrt(3))
  for i in range(1,16){
    let x = 0
    let y = 0
    let z = 0
    let n = 0
    for j in range(4){
      x += x_list.at(j) * get_bit(i,j)
      y += y_list.at(j) * get_bit(i,j)
      z += z_list.at(j) * get_bit(i,j)
      n += get_bit(i,j)
    }
    coords.push((x/n, y/n, z/n))
  }
  return coords
}

#let matrix_to_angles(mat) = {
  
}

#fig("qrm-sc")[
  #import "@preview/cetz:0.4.2": canvas, draw, matrix, vector, decorations

  #let transp = 70%

#let cr = rgb(100%, 0, 0, transp)
#let cg = rgb(0, 100%, 0, transp)
#let cb = rgb(49.8%, 85.9%, 100%, transp)
#let cy = rgb(100%, 100%, 0, transp)

#let r = 0.07
#let a = 2
#let l = 2*a
#let coords = qrm_coords(l)

#canvas({
  import draw: *

  set-transform((
    (-0.3, 1,  0, 0),  // x 轴：向左 (-0.7), 向下 (-0.5)
    ( 0.5,  0,  -1, 0),  // y 轴：向右 (1.0), 垂直不动 (0)
    ( 0,  0,  0, 0),  // z 轴：水平不动 (0), 向上 (1.0)
    ( 0.0, 0, 0, 0)   // 齐次坐标平移项
  ))


  // lines
  line(coords.at(0b1111), coords.at(0b0111))
  line(coords.at(0b1111), coords.at(0b1011))
  line(coords.at(0b1111), coords.at(0b1101))
  line(coords.at(0b1111), coords.at(0b1110))

  // scale(y: 90%)
  // QRM code
  // back surfaces
  line(coords.at(0b0001), coords.at(0b0011), coords.at(0b0111), coords.at(0b0101), coords.at(0b0001), fill: cy)
  line(coords.at(0b0001), coords.at(0b0101), coords.at(0b1101), coords.at(0b1001), coords.at(0b0001), fill: cy)
  line(coords.at(0b1000), coords.at(0b1001), coords.at(0b1101), coords.at(0b1100), coords.at(0b1000), fill: cr)
  line(coords.at(0b0100), coords.at(0b0101), coords.at(0b1101), coords.at(0b1100), coords.at(0b0100), fill: cb)
  line(coords.at(0b0100), coords.at(0b0101), coords.at(0b0111), coords.at(0b0110), coords.at(0b0100), fill: cb)
  line(coords.at(0b0010), coords.at(0b0011), coords.at(0b0111), coords.at(0b0110), coords.at(0b0010), fill: cg)
  line(coords.at(0b0001), coords.at(0b0011), coords.at(0b1011), coords.at(0b1001), coords.at(0b0001), fill: cy)
  line(coords.at(0b1000), coords.at(0b1010), coords.at(0b1110), coords.at(0b1100), coords.at(0b1000), fill: cr)
  line(coords.at(0b1000), coords.at(0b1010), coords.at(0b1011), coords.at(0b1001), coords.at(0b1000), fill: cr)
  line(coords.at(0b0100), coords.at(0b0110), coords.at(0b1110), coords.at(0b1100), coords.at(0b0100), fill: cb)
  line(coords.at(0b0010), coords.at(0b1010), coords.at(0b1110), coords.at(0b0110), coords.at(0b0010), fill: cg)
  line(coords.at(0b0010), coords.at(0b1010), coords.at(0b1011), coords.at(0b0011), coords.at(0b0010), fill: cg)

  // vertices
  for i in range(1, 16){
    circle(coords.at(i), radius: r, fill: black)
  }


  // Surface code
  
  // checks
  let theta = 30deg
  let ar = a / (2 * calc.cos(theta))
  for i in range(2){
    line(((i * a, (i + 1) * a, 0)), ((i * a, (i + 2) * a, 0)), (((i + 1) * a, (i + 2) * a, 0)), (((i + 1) * a, (i + 1) * a, 0)), ((i * a, (i + 1) * a, 0)), fill: aqua)
    line(((i * a, (-i + 2) * a, 0)), ((i * a, (-i + 3) * a, 0)), (((i + 1) * a, (-i + 3) * a, 0)), (((i + 1) * a, (-i + 2) * a, 0)), ((i * a, (-i + 2) * a, 0)), fill: red)
    arc(((2*i) * a, (2*i + 1) * a, 0), radius: ar, start: theta - (i - 1) * 180deg, delta: 180deg-2 * theta, mode: "CLOSE", fill: red)
    arc(((2*i) * a, (-2*i + 3) * a, 0), radius: ar, start: 90deg + theta - i * 180deg, delta: 180deg-2 * theta, mode: "CLOSE", fill: aqua)
  }

  // qubits
  for i in range(3){
    for j in range(3){
      circle(((i * a, (1 + j) * a, 0)), radius: r, fill: black)
    }
  }
  
  line((0,0), (2*a, 0), stroke: 2.5pt)
  line((0,a), (2*a, a), stroke: 2.5pt)
  // }
  // )
})

#let hatched(clr, clr2: white) = {
  return tiling(size: (.1cm, .1cm))[
    #place(rect(width: 100%, height: 100%, fill: clr2, stroke: none))
    #place(line(start: (0%, 100%), end: (100%, 0%), stroke: (paint: clr, thickness: 0.7pt)))
  ]
}



#canvas({
  import draw: *

  set-transform((
    (-0.3, 1,  0, 0),  // x 轴：向左 (-0.7), 向下 (-0.5)
    ( 0.5,  0,  -1, 0),  // y 轴：向右 (1.0), 垂直不动 (0)
    ( 0,  0,  0, 0),  // z 轴：水平不动 (0), 向上 (1.0)
    ( 0.0, 0, 0, 0)   // 齐次坐标平移项
  ))


  // lines
  line(coords.at(0b1111), coords.at(0b0111))
  line(coords.at(0b1111), coords.at(0b1011))
  line(coords.at(0b1111), coords.at(0b1101))
  line(coords.at(0b1111), coords.at(0b1110))

  // scale(y: 90%)
  // QRM code
  // back surfaces
  line(coords.at(0b0001), coords.at(0b0011), coords.at(0b0111), coords.at(0b0101), coords.at(0b0001), fill: cy)
  line(coords.at(0b0001), coords.at(0b0101), coords.at(0b1101), coords.at(0b1001), coords.at(0b0001), fill: cy)
  line(coords.at(0b1000), coords.at(0b1001), coords.at(0b1101), coords.at(0b1100), coords.at(0b1000), fill: cr)
  line(coords.at(0b0100), coords.at(0b0101), coords.at(0b1101), coords.at(0b1100), coords.at(0b0100), fill: cb)
  line(coords.at(0b0100), coords.at(0b0101), coords.at(0b0111), coords.at(0b0110), coords.at(0b0100), fill: cb)
  line(coords.at(0b0010), coords.at(0b0011), coords.at(0b0111), coords.at(0b0110), coords.at(0b0010), fill: cg)
  line(coords.at(0b0001), coords.at(0b0011), coords.at(0b1011), coords.at(0b1001), coords.at(0b0001), fill: cy)
  line(coords.at(0b1000), coords.at(0b1010), coords.at(0b1110), coords.at(0b1100), coords.at(0b1000), fill: cr)
  line(coords.at(0b1000), coords.at(0b1010), coords.at(0b1011), coords.at(0b1001), coords.at(0b1000), fill: cr)
  line(coords.at(0b0100), coords.at(0b0110), coords.at(0b1110), coords.at(0b1100), coords.at(0b0100), fill: cb)
  line(coords.at(0b0010), coords.at(0b1010), coords.at(0b1110), coords.at(0b0110), coords.at(0b0010), fill: cg)
  line(coords.at(0b0010), coords.at(0b1010), coords.at(0b1011), coords.at(0b0011), coords.at(0b0010), fill: cg)

  // vertices
  for i in range(1, 16){
    circle(coords.at(i), radius: r, fill: black)
  }

  // Surface code

  // checks
  let theta = 30deg
  let ar = a / (2 * calc.cos(theta))
  for i in range(2){
    line(((i * a, (i + 1) * a, 0)), ((i * a, (i + 2) * a, 0)), (((i + 1) * a, (i + 2) * a, 0)), (((i + 1) * a, (i + 1) * a, 0)), ((i * a, (i + 1) * a, 0)), fill: aqua)
    line(((i * a, (-i + 2) * a, 0)), ((i * a, (-i + 3) * a, 0)), (((i + 1) * a, (-i + 3) * a, 0)), (((i + 1) * a, (-i + 2) * a, 0)), ((i * a, (-i + 2) * a, 0)), fill: red)
    
    arc(((2*i) * a, (-2*i + 3) * a, 0), radius: ar, start: 90deg + theta - i * 180deg, delta: 180deg-2 * theta, mode: "CLOSE", fill: aqua)
  }
  arc(((2*1) * a, (2*1 + 1) * a, 0), radius: ar, start: theta - (1 - 1) * 180deg, delta: 180deg-2 * theta, mode: "CLOSE", fill: red)
  line(((1 * a, 1 * a, 0)), ((2 * a, 1 * a, 0)), ((2 * a, 0 * a, 0)), ((1 * a, 0 * a, 0)), ((1 * a, 1 * a, 0)), fill: hatched(aqua))

  arc((0 * a, 1 * a, 0), radius: ar, start: 90deg + theta , delta: 180deg-2 * theta, mode: "CLOSE", fill: hatched(aqua))

  // merging region
  line((0.5 * a, 0.5 * a, 0), (0 * a, 0 * a, 0), (1 * a, 0 * a, 0), fill: hatched(cr, clr2: cy), stroke: none)
  line((0.5 * a, 0.5 * a, 0), (0 * a, 1 * a, 0), (1 * a, 1 * a, 0), fill: hatched(cy, clr2: cr), stroke:none)
  // circle((0.5 * a, 0.5 * a, 0), radius: r, fill: red, stroke: red)


  // qubits
  for i in range(3){
    for j in range(3){
      circle(((i * a, (1 + j) * a, 0)), radius: r, fill: black)
    }
  }
  
  line((0,0), (2*a, 0), stroke: 2.5pt)
  line((0,a), (2*a, a), stroke: 2.5pt)
  
  content((0.5*a, 0.5*a, 0), [Merged $X$ checks], anchor: "south-west", padding: 2pt)

  // marks
  set-transform((
    (1, 0,  0, 0),  // x 轴：向左 (-0.7), 向下 (-0.5)
    ( 0,  1,  0, 0),  // y 轴：向右 (1.0), 垂直不动 (0)
    ( 0,  0,  1, 0),  // z 轴：水平不动 (0), 向上 (1.0)
    ( 0.0, 0, 0, 0)   // 齐次坐标平移项
  ))
  // decorations.flat-brace((4*a, -4*a), (4*a, -4*a))
  // content()
})
#canvas({
  import draw: *
  decorations.flat-brace((1.47*a,0), (0,0))
  content((1.47*a/2, 0), align(center)[color code\ (magic)], anchor: "north", padding: (top: 13pt))
  decorations.flat-brace((2.47*a, 0),(1.47*a,0))
  content((a/2 + 1.47*a, 0), align(center)[measurement\ patch], anchor: "north", padding: (top: 13pt))
  decorations.flat-brace((4.47*a, 0),(2.47*a,0))
  content((a + 2.47*a, 0), align(center)[surface code \ (base)], anchor: "north", padding: (top: 13pt))
})
]

// ========================== Surgery =================================

#import "@preview/cetz:0.4.2": canvas, draw

#fig("surgery")[
  #let n = 7
  #let l = 1
  #let h-sep = 1
  #let h = 2.3
  #let v-sep = 0.5
  #let r = 0.1
  #let arrow-style = (
    stroke: rgb("#888") + 5pt,
    mark: (end: "stealth", size: 15pt),
  )
  #let L = (n - 1)*l + 2 * h-sep
  #canvas({
    import draw: *
    rect((0,0), (L, h), fill: luma(90%))
    content((0, h), [3D color code M], anchor: "north-west", padding: 5pt)
    rect((0,- v-sep), (L, - v-sep - h), fill: luma(90%))
    content((0, - v-sep - h), [2D surface code B], anchor: "south-west", padding: 5pt)
    for i in range(n){
      circle((i*l + h-sep, v-sep / 2), radius: r, fill: black)
      circle((i*l + h-sep, - 3*v-sep / 2), radius: r, fill: black)
      if i < (n - 1){
        line((i*l + 3*h-sep/2, - 3*v-sep / 2 - v-sep), (i*l + h-sep, - 3*v-sep / 2) )
        line((i*l + 3*h-sep/2, - 3*v-sep / 2 - v-sep), ((i+1)*l + h-sep, - 3*v-sep / 2) )
        line((i*l + 3*h-sep/2, v-sep / 2 + v-sep), (i*l + h-sep, v-sep / 2) )
        line((i*l + 3*h-sep/2, v-sep / 2 + v-sep), ((i+1)*l + h-sep, v-sep / 2) )
        line((i*l + 3*h-sep/2, v-sep / 2 + v-sep), (i*l + 3*h-sep/2, v-sep / 2 + 2* v-sep), stroke: (dash: "dashed"))
        line((i*l + 3*h-sep/2, -3*v-sep / 2 - v-sep), (i*l + 3*h-sep/2, -3*v-sep / 2 - 2* v-sep), stroke: (dash: "dashed"))
        rect((i*l + 3*h-sep/2 - r, - 3*v-sep / 2 - v-sep - r), (i*l + 3*h-sep/2 + r, - 3*v-sep / 2 - v-sep + r), fill: red, stroke: none)
        rect((i*l + 3*h-sep/2 - r, v-sep / 2 + v-sep - r), (i*l + 3*h-sep/2 + r, v-sep / 2 + v-sep + r), fill: red, stroke: none)
      }
    }
    line((L + l, -v-sep/2), (L + 3 * l, -v-sep/2), ..arrow-style)

    translate(x: L + 4*l, y: 0)
    rect((0,0), (L, h), fill: luma(90%))
    content((0, h), [3D color code M], anchor: "north-west", padding: 5pt)
    rect((0,- v-sep), (L, - v-sep - h), fill: luma(90%))
    content((0, - v-sep - h), [2D surface code B], anchor: "south-west", padding: 5pt)
    for i in range(n){
      circle((i*l + h-sep, v-sep / 2), radius: r, fill: black)
      circle((i*l + h-sep, - 3*v-sep / 2), radius: r, fill: black)
      if i < (n - 1){
        let color = red
        if (calc.rem(i,2) == 0){
          line((i*l + 3*h-sep/2, - 3*v-sep / 2 - v-sep), (i*l + h-sep, - 3*v-sep / 2) )
          line((i*l + 3*h-sep/2, - 3*v-sep / 2 - v-sep), ((i+1)*l + h-sep, - 3*v-sep / 2) )
          line((i*l + 3*h-sep/2, v-sep / 2 + v-sep), (i*l + h-sep, v-sep / 2) )
          line((i*l + 3*h-sep/2, v-sep / 2 + v-sep), ((i+1)*l + h-sep, v-sep / 2) )
          line((i*l + 3*h-sep/2, v-sep / 2 + v-sep), (i*l + 3*h-sep/2, v-sep / 2 + 2* v-sep), stroke: (dash: "dashed"))
          line((i*l + 3*h-sep/2, -3*v-sep / 2 - v-sep), (i*l + 3*h-sep/2, -3*v-sep / 2 - 2* v-sep), stroke: (dash: "dashed"))
          line(((i+1)*l + 3*h-sep/2, -3*v-sep / 2 - 2*v-sep), ((i+1)*l + 3*h-sep/2, v-sep / 2 + 2* v-sep), stroke: (dash: "dashed"))
          rect((i*l + 3*h-sep/2 - r, - 3*v-sep / 2 - v-sep - r), (i*l + 3*h-sep/2 + r, - 3*v-sep / 2 - v-sep + r), fill: red, stroke: none)
          rect((i*l + 3*h-sep/2 - r, v-sep / 2 + v-sep - r), (i*l + 3*h-sep/2 + r, v-sep / 2 + v-sep + r), fill: red, stroke: none)
          color = aqua
        } 
        line((i*l + 3*h-sep/2, - v-sep / 2), (i*l + h-sep, v-sep / 2) )
        line((i*l + 3*h-sep/2, - v-sep / 2), ((i+1)*l + h-sep, v-sep / 2) )
        line((i*l + 3*h-sep/2, - v-sep / 2), (i*l + h-sep, - 3* v-sep / 2) )
        line((i*l + 3*h-sep/2, - v-sep / 2), ((i+1)*l + h-sep, - 3*v-sep / 2) )
        rect((i*l + 3*h-sep/2 - r, - v-sep / 2 - r), (i*l + 3*h-sep/2 + r, - v-sep / 2 + r), fill: color, stroke: none)
      }
    }
    line(((n - 1)*l + 3*h-sep/2, - v-sep / 2), ((n - 1)*l + h-sep, v-sep / 2) )
    line(((n - 1)*l + 3*h-sep/2, - v-sep / 2), ((n - 1)*l + h-sep, - 3* v-sep / 2) )
    rect(((n - 1)*l + 3*h-sep/2 - r, - v-sep / 2 - r), ((n - 1)*l + 3*h-sep/2 + r, - v-sep / 2 + r), fill: aqua, stroke: none)
  })
]

