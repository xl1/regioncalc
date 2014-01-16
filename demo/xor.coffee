m.xor = ({ id, in1, in2 }) ->
  m.dup id:"#{id}_d1", in1:in1
  m.dup id:"#{id}_d2", in1:in2
  m.or  id:"#{id}_r1", in1:"#{id}_d1", in2:"#{id}_d2"
  m.and id:"#{id}_a1", in1:"#{id}_d1", in2:"#{id}_d2"
  m.not id:"#{id}_n1", in1:"#{id}_a1"
  m.and id:id,         in1:"#{id}_r1", in2:"#{id}_n1"

m.halfadder = ({ id, in1, in2 }) ->
  m.dup id:"#{id}_d1", in1:in1
  m.dup id:"#{id}_d2", in1:in2
  m.or  id:"#{id}_r1", in1:"#{id}_d1", in2:"#{id}_d2"
  m.and id:"#{id}_a1", in1:"#{id}_d1", in2:"#{id}_d2"
  m.dup id:"#{id}_carry", in1:"#{id}_a1"
  m.not id:"#{id}_n1", in1:"#{id}_carry"
  m.and id:id, in1:"#{id}_r1", in2:"#{id}_n1"

doctype 5
script src:'../regionrulepolyfill/regionrulepolyfill.js'

m.init 20

style """
div { outline: 1px solid silver; }
:checked + .in { height: #{m.size}px; }
@-webkit-region .out { div { background: blue !important; }}
"""

input type:'checkbox'
m.in id:'i1'

input type:'checkbox'
m.in id:'i2'

m.xor id:'x1', in1:'i1', in2:'i2'
m.out id:'o1', in1:'x1'
#m.out id:'o2', in1:'x1_carry'
