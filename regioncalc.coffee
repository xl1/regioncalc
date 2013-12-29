padding = encodeURI 'data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"></svg>'

unit = (name, { arity, plus, minus, coefs }) ->
  plus or= 0
  minus or= 0
  (arg) ->
    id = arg.id
    div class:name, id:id, =>
      for i in [1..arity] by 1
        @connector id:"#{id}_connector#{i}", in1:arg["in#{i}"], flow:id
      for i in [1..arity] by 1
        @connector_inout id:"#{id}_inout#{i}", flow:id
      for i in [1..plus] by 1
        @plus id:"#{id}_plus#{i}", flow:id
      @minus id:"#{id}_minus", length:minus, flow:id, coefs:coefs

m =
  size: 100
  unit: unit
  connector: ({ id, in1, flow }) ->
    div
      id:id, class:'unit connector',
      style:"-webkit-flow-from: #{in1}; -webkit-flow-into: #{flow};"

  connector_inout: ({ id, flow }) ->
    div id:id, ->
      div
        id:"#{id}_connector_in", class:'unit connector_in'
        style:"-webkit-flow-into: #{flow};"
      div
        id:"#{id}_connector_out", class:'unit connector_out'
        style:"-webkit-flow-from: #{flow};"

  plus: ({ id, flow }) ->
    div id:id, class:'unit plus', style:"-webkit-flow-into: #{flow};", ->
      img src:padding

  minus: ({ id, length, flow, coefs }) ->
    length or= 1
    coefs or= []
    div id:id, class:'unit minus'
    style """
      ##{id} {
        -webkit-flow-from: #{flow};
        height: #{length * @size}px;
      }
    """ + (
      for coef in coefs
        """
          ##{id}::region(.connector_in) {
            margin-top: #{@size * (-1 + coef)}px;
          }
        """
    ).join('\n')
    script (
      for coef in coefs
        """
          Region('##{id}').addRegionRule('.connector_in', {
            marginTop: '#{@size * (-1 + coef)}px'
          });
        """
    ).join('\n')

  and: unit('and', arity:2, minus:1)
  or:  unit('or',  arity:2, plus:1, minus:1, coefs:[0.5, 0.5])
  not: unit('not', arity:1, plus:1, coefs:[-1])
  nor: unit('nor', arity:2, plus:1, coefs:[-1, -1])
  dup: unit('dup', arity:1, plus:2, minus:2, coefs:[2])

  in: ({ id }) ->
    div id:id, class:'unit in', style:"-webkit-flow-into: #{id};"
  out: ({ id, in1 }) ->
    div id:id, class:'unit out', style:"-webkit-flow-from: #{in1};"

  init: ->
    style """
      .unit {
        width: #{@size}px;
        height: #{@size}px;
      }
      .unit.in {
        height: 0;
      }
      .unit.connector {
        height: auto;
        max-height: #{@size}px;
      }
      .unit.plus {
        height: auto;
      }
      .unit.plus img {
        vertical-align: text-bottom;
      }
    """
