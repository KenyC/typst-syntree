#let default_child_spacing = 1em
#let _debug_typst_syntree = false
#let _debug_box(x, color : black) = if _debug_typst_syntree {
    box(x, stroke: color)
  } else {
    x
  }

// Subtrees are stored as arrays in Polish reverse notation
// This facilitates depth traversal later on
#let subtree(tag: none, .. children, child_spacing : default_child_spacing) = {
  let to_return = children.pos().map(c => if type(c) == content { (c,) } else { c }).join();
  to_return.push((
    tag: tag,
    n_children : children.pos().len(),
    child_spacing : child_spacing
  ))
  to_return
}

#let tree(tag: none, .. children, child_spacing : default_child_spacing) = context {
  let full_tree = subtree(tag: tag, ..children)
  let contents         = ()
  // Contains positions of root wrt left edge of subtree
  let root_positions   = ()

  for node in full_tree {
    if type(node) == content {
      // If we have a leaf, we just place its root at mid content
      contents.push(node)
      let width = measure(node).width
      root_positions.push(width / 2)
    }
    else if type(node) == dictionary {
      let n_children = node.at("n_children")
      let child_spacing = node.at("child_spacing").to-absolute()
      let tag = node.at("tag")

      let child_nodes = contents.slice(- n_children)
      for i in array.range(n_children) {
        let _ = contents.pop()
      }
      let child_root_positions = root_positions.slice(- n_children)
      for i in array.range(n_children) {
        let _ = root_positions.pop()
      }

      // Our goal is to align the middle of "tag" node with the middle of the root of the first child and the root of the last child (in case of binary tree, this guarantees symmetry)
      // NB: This is not the same as center alignment: if last child is heavily right branching, its root will to the left compared to its center.
      // 
      //
      // Schematically:
      //
      //         [-----+-----]                  <- parent tag
      //               ∧
      //               |
      //   rootchild1  v    rootlastchild
      //      +--------+-------+
      //      |                |
      //      v                v
      //   [-----]..[----]..[---------------]     <- children nodes
      //    
      //   |----------->  (children_left_edge_to_mid)   
      //   |---->         (tag_shift)
      // First we compute the position of the the mid point of first and last root wrt to left edge of children
      let children_width      = child_nodes.map(c => measure(c).width).sum() + (n_children - 1) * child_spacing
      let last_child_width    = measure(child_nodes.last()).width
      let first_root_position = child_root_positions.first()
      let last_root_position  = child_root_positions.last()

      let children_left_edge_to_mid = (children_width - last_child_width + last_root_position + first_root_position) / 2

      // Next, we compute tag_shift, i.e. how much space (in signed units) there is between the left edge of the children and the left edge of the parent tag
      // We can determine this from our alignment constraint.
      // If positive, it means parent_tag's left edge is to the right of the children's left edge.
      // If negative, it means parent_tag's left edge is to the left of the children's left edge.
      let tag_width = measure(tag).width
      let tag_shift = children_left_edge_to_mid - tag_width / 2

      // We now create the left-to-right child stack adding the edges to the root node
      let child_stack = stack(
        dir: ltr, 
        spacing: child_spacing, 
        ..child_nodes.map(c => _debug_box(c))
      )

      // TODO: these should be arguments
      let layer_spacing = 3em
      let hi = -layer_spacing + 0.3em
      let lo = -0.3em
      let stroke = 0.75pt

      // Trace edges
      let acc = 0em
      let edges = for i in array.range(n_children) {
        let width = measure(child_nodes.at(i)).width
        place(line(
          stroke: stroke, 
          start:  (acc + child_root_positions.at(i), lo), 
          end:    (tag_width / 2 + tag_shift, hi)
        ))
        acc += width + child_spacing
      }
      let child_stack = edges + child_stack

      // Depending on which of the parent tag and the children nodes extends more to the left,
      // we pad either one or the other on the left to create alignment
      // We also compute root position for later computation
      let tag = _debug_box(tag)
      let root_position = none
      if tag_shift > 0em {
        tag = _debug_box(pad(left: tag_shift, tag), color: blue)
        root_position = children_left_edge_to_mid
      }
      else {
        child_stack = _debug_box(pad(left: -tag_shift, child_stack), color: blue)
        root_position = tag_width / 2 
      }
      root_positions.push(root_position)

      let layer_stack = stack(dir: ttb, spacing: layer_spacing, align(left, tag), align(left, child_stack))
      contents.push(layer_stack)
    }
    else {
      panic("Wrong argument type!")
    }
  }


  let to_return = _debug_box(contents.last())
  to_return
}



  






// #let syntree(code, terminal: (:), nonterminal: (:), child-spacing: 1em, layer-spacing: 2.3em) = {
//   let stack = ((),)
//   let roof_stack = (false,)
//   for token in code.matches(regex(`(\\\[|\\\]|[^\[\]\s])+|\[|\]`.text)) {
//     if token.text == "[" {
//       stack.push(())
//       roof_stack.push(false)
//     } else if token.text == "]" {
//       let (tag, ..children) = stack.pop()
//       let roof = roof_stack.pop()
//       if roof {
//         children = (text(..terminal, children.map(c => c.at("content")).join([ ])),)
//       }
//       stack.last().push(subtree(tag, ..children, child-spacing: child-spacing, layer-spacing: layer-spacing, roof: roof))
//     } else {
//       let sty = if stack.last().len() == 0 { nonterminal } else { terminal }
//       let t = token.text
//       if t.starts-with("^") {
//         t = t.slice(1)
//         roof_stack.last() = true
//       }
//       stack.last().push((
//         content: text(..sty, eval("[" + t + "]"))
//       ))
//     }
//   }
//   stack.last().last()
// }
