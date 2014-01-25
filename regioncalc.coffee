unit = ({ id, class:cls, from, into }, child) ->
  param = { class:'unit', style:'' }
  if id then param.id = id
  if cls then param.class += ' ' + cls
  if from
    param.style += "-webkit-flow-from:#{from}; flow-from:#{from}; "
  if into
    param.style += "-webkit-flow-into:#{into}; flow-into:#{into}; "
  div param, child

m =
  unit: unit

  id: ({ id, in1 }) ->
    div class:'id', =>
      unit class:'connector', from:in1, into:id
  orand: ({ id, in1, in2 }) ->
    div class:'orand', =>
      unit class:'connector', from:in1, into:id
      unit class:'connector', from:in2, into:id
  or: ({ id, in1, in2 }) ->
    div class:'or', =>
      @orand id:"#{id}_orand", in1:in1, in2:in2
      unit class:'connector', from:"#{id}_orand", into:id
      unit into:id
      unit from:id
  and: ({ id, in1, in2 }) ->
    div class:'and', =>
      @orand id:id, in1:in1, in2:in2
      unit from:id

  not: ({ id, in1 }) ->
    div class:'not', =>
      unit class:'connector', from:in1, into:id
      unit class:'plus', id:"#{id}_plus", into:id
      unit into:id
      unit into:id
      unit from:id
      unit class:'minus', id:"#{id}_minus", from:id
      style """
        ##{id}_minus::region(##{id}_plus) {
          margin-top: #{-3 * @size}px;
        }
      """
      script """
        Region('##{id}_minus').addRegionRule('##{id}_plus', {
          marginTop: '#{-3 * @size}px'
        });
      """

  dup: ({ id, in1 }) ->
    div class:'dup', =>
      unit class:'connector', from:in1, into:"#{id}_x2"
      unit class:'unit2', into:"#{id}_x2"
      unit class:'unit2', from:"#{id}_x2"
      unit class:'connector2', from:"#{id}_x2", into:id
      unit into:id
      unit into:id
      unit class:'unit2', from:id

  in: ({ id }) ->
    unit id:id, class:'in', into:id
  out: ({ id, in1 }) ->
    unit id:id, class:'out', from:in1

  init: (@size=100) ->
    style """
      .unit {
        width: #{@size}px;
        height: #{@size}px;
        -webkit-region-break-inside: avoid;
        break-inside: avoid;
      }
      .unit.in {
        height: 0;
      }
      .unit.connector {
        height: auto;
        max-height: #{@size}px;
      }
      .unit.connector2 {
        height: auto;
        max-height: #{2 * @size}px;
      }
      .unit.unit2 {
        height: #{2 * @size}px;
      }
    """
