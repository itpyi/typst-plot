#import "../fig-plucker.typ": fig-plucker, fig
#import "@preview/cetz:0.4.2": canvas, draw

#show: fig-plucker.with(
	debug: false,
	output-label: "square",
	// output-num: 1,
)

#fig("circle")[
  #canvas({
		import draw: *
    circle((0, 0), radius: 0.8)
	})
]

#fig("square")[
  #canvas({
    import draw: *
    rect((-0.8, 0.8), (0.8, -0.8))
  })
]

#fig("triangle")[
	#canvas({
    import draw: *
    line((0, 0.9), (-0.8, -0.7), (0.8, -0.7), (0,0.9))
  })
]
