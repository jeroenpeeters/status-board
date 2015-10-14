@sunbBurstComp = (nodes) ->
  # Main function to draw and set up the visualization, once we have the data.

  createVisualization = (json) ->
    # Basic setup of page elements.
    #d3.select('#togglelegend').on 'click', toggleLegend
    # Bounding circle underneath the sunburst, to make it easier to detect
    # when the mouse leaves the parent g.
    vis.append('svg:circle').attr('r', radius).style 'opacity', 0
    # For efficiency, filter nodes to keep only those large enough to see.
    nodes = partition.nodes(json).filter((d) ->
      d.dx > 0.005
      # 0.005 radians = 0.29 degrees
    )
    path = vis.data([ json ])
    .selectAll('path')
    .data(nodes).enter()
    .append('svg:path')
    .attr('display', (d) -> if d.depth then null else 'none')
    .attr('d', arc)
    .attr('fill-rule', 'evenodd')
    .style('fill', (d) -> if d.isUp or d.isUp == undefined then '#5cb85c' else 'red')
    .style('opacity', 1)
    .on('mouseover', mouseover)
    # Add the mouseleave handler to the bounding circle.
    d3.select('#container').on 'mouseleave', mouseleave
    # Get total size of the tree = value of root node from partition.
    totalSize = path.node().__data__.value
    return

  # Fade all but the current sequence, and show it in the breadcrumb trail.

  mouseover = (d) ->
    d3.select('#groupName').text d.group
    d3.select('#serviceName').text d.name
    d3.select('#explanation').style 'visibility', ''
    sequenceArray = getAncestors(d)
    # Fade all the segments.
    d3.selectAll('path').style 'opacity', 0.3
    # Then highlight only those that are an ancestor of the current segment.
    vis.selectAll('path').filter((node) ->
      sequenceArray.indexOf(node) >= 0
    ).style 'opacity', 1
    return

  # Restore everything to full opacity when moving off the visualization.

  mouseleave = (d) ->
    # Hide the breadcrumb trail
    d3.select('#trail').style 'visibility', 'hidden'
    # Deactivate all segments during transition.
    d3.selectAll('path').on 'mouseover', null
    # Transition each segment to full opacity and then reactivate it.
    d3.selectAll('path').transition().duration(1000).style('opacity', 1).each 'end', ->
      d3.select(this).on 'mouseover', mouseover
      return
    d3.select('#explanation').style 'visibility', 'hidden'
    return

  # Given a node in a partition layout, return an array of all of its ancestor
  # nodes, highest first, but excluding the root.

  getAncestors = (node) ->
    path = []
    current = node
    while current.parent
      path.unshift current
      current = current.parent
    path

  width = 750
  height = 600
  radius = Math.min(width, height) / 2
  # Breadcrumb dimensions: width, height, spacing, width of tip/tail.
  b =
    w: 75
    h: 30
    s: 3
    t: 10
  # Total size of all segments; we set this later, after loading the data.
  totalSize = 0
  vis = d3.select('#chart')
  .append('svg:svg')
  .attr('width', width)
  .attr('height', height)
  .append('svg:g')
  .attr('id', 'container')
  .attr('transform', 'translate(' + width / 2 + ',' + height / 2 + ')')

  partition = d3.layout.partition().size([
    2 * Math.PI
    radius * radius
  ]).value((d) ->
    d.size
  )
  arc = d3.svg.arc().startAngle((d) ->
    d.x
  ).endAngle((d) ->
    d.x + d.dx
  ).innerRadius((d) ->
    Math.sqrt d.y
  ).outerRadius((d) ->
    Math.sqrt d.y + d.dy
  )
  createVisualization nodes
  d3.select(self.frameElement).style 'height', '700px'
  return
