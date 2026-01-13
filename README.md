# Typst Plot Export Utility

This snippet provides a streamlined workflow for academic researchers who use [Typst](https://typst.app/) and [CeTZ](https://cetz-package.github.io/) to create illustrations for documents written in LaTeX or PowerPoint.

## The Problem

When writing a paper, you often need multiple vector graphics (PDF/SVG). Managing a separate `.typ` file for every single figure is disorganized. However, keeping them in one file makes it difficult to export just "Figure 5" with a perfectly cropped bounding box.

## The Solution

This utility allows you to maintain a **single figure library**.

* **Debug Mode:** Browse all figures with their index numbers and captions on auto-cropped pages.
* **Output Mode:** Isolate a single figure by its name or index for final export.

## Quick Start

1. Copy `plot-export.typ` into your project.
2. Structure your main file as follows:

```typst
#import "plot-export.typ": *

#show: plot-export.with(
  debug: true,       // Toggle to false when ready to export
  output: "my-plot"  // Specify target by caption (or use output-num: 0)
)

#fig("my-plot")[
  // Your CeTZ or Typst drawing code
]

#fig("another-plot")[
  // Another figure
]

```

## Features

* **WYSIWYG Debugging:** Even in debug mode, the canvas is auto-cropped to the figure size, so you see exactly what the export will look like.
* **"Identify & Isolate" Workflow:** Keep `debug: true` to find the index or caption you need, then switch to `false` to generate the clean file.
* **Visual Error Reporting:** Errors (like calling a non-existent index) are rendered directly in the output file. This ensures that if a batch export script fails, you see the reason immediately on the "canvas."

## More Information

For a detailed breakdown of the logic and usage tips, check out the full [blog post](https://itpyi.github.io/blog/posts/typst-plot-snippet/)
