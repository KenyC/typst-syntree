#import "@local/syntree:0.2.0": subtree, tree

#figure(
  caption: "Example of a syntax tree.",
  gap: 2em,
  tree(
    tag: [oooooooooiooooooooo],
    [aaaaaaaa],
    [b]
  ),    
  
)

#figure(
  caption: "Example of a syntax tree.",
  gap: 2em,
  tree(tag: none, 
    subtree(tag: [$(e t)t$], 
      [every],
      [student],
    ),
    subtree(tag: [VP], 
      [came],
      subtree(tag: none, child_spacing: 5em,
        [to],
        subtree(tag: none, layer_spacing: 8em,
          [my],
          [class],
        ),
      ),
    ),
  ),    
  
)

  // syntree(
  //   nonterminal: (fill: blue),
  //   terminal: (style: "italic"),
  //   "[S [NP [Det the] [Nom [Adj little] [N bear]]] [VP [VP [V saw] [NP [Det the] [Nom [Adj fine] [Adj fat] [N trout]]]] [PP [P in] [^NP the brook]]]]"
  // )



#figure(
  caption: "Example of a syntax tree.",
  gap: 2em,
  tree(
    tag: [something],
    subtree(
      tag: [something else],
      [a],
      [b]
    ),    
    [c]
  )
  // syntree(
  //   nonterminal: (fill: blue),
  //   terminal: (style: "italic"),
  //   "[S [NP [Det the] [Nom [Adj little] [N bear]]] [VP [VP [V saw] [NP [Det the] [Nom [Adj fine] [Adj fat] [N trout]]]] [PP [P in] [^NP the brook]]]]"
  // )
)

#figure(
  caption: "Example of a syntax tree.",
  gap: 2em,
  tree(
    tag: [something],
    subtree(
      tag: [something else],
      [a],
      [b]
    ),    
    subtree(
      tag: [something else],
      [c],
      [ddd]
    ),    
  )
  // syntree(
  //   nonterminal: (fill: blue),
  //   terminal: (style: "italic"),
  //   "[S [NP [Det the] [Nom [Adj little] [N bear]]] [VP [VP [V saw] [NP [Det the] [Nom [Adj fine] [Adj fat] [N trout]]]] [PP [P in] [^NP the brook]]]]"
  // )
)

#figure(
  caption: "Example of a syntax tree.",
  gap: 2em,
  tree(
    tag: [something],
    subtree(
      tag: [something else],
      [aaaaaaaaaaaaa],
      [bbbbbbbbbbbbb]
    ),
    [a]
  )
  // syntree(
  //   nonterminal: (fill: blue),
  //   terminal: (style: "italic"),
  //   "[S [NP [Det the] [Nom [Adj little] [N bear]]] [VP [VP [V saw] [NP [Det the] [Nom [Adj fine] [Adj fat] [N trout]]]] [PP [P in] [^NP the brook]]]]"
  // )
)
