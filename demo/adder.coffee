m.halfadder = ({ id, in1, in2 }) ->
  m.orand id:"#{id}_oa", in1:in1, in2:in2
  m.unit id:"#{id}_r1", class:'connector', from:"#{id}_oa", into:"#{id}_r1"
  m.dup id:"#{id}_carry", in1:"#{id}_oa"
  m.not id:"#{id}_n1", in1:"#{id}_carry"
  m.and id:id, in1:"#{id}_r1", in2:"#{id}_n1"

m.adder = ({ id, in1, in2, in3 }) ->
  m.halfadder id:"#{id}_h1", in1:in1, in2:in2
  m.halfadder id:"#{id}_h2", in1:"#{id}_h1", in2:in3
  m.or id:"#{id}_carry", in1:"#{id}_h1_carry", in2:"#{id}_h2_carry"
  m.id id:id, in1:"#{id}_h2"

doctype 5
meta charset:'utf-8'
title 'adder'
script src:'../regionrulepolyfill/regionrulepolyfill.js'

m.init 16

style """
input { display: block; }
div { outline: silver 1px solid; }
.container { float: left; }
input:checked + .unit.in { height: #{m.size}px; }
.unit.in[id^=i] { background: red; }
.unit.in[id^=j] { background: lime; }
@-webkit-region .unit.out {
  div { background: blue; }
}
"""

for i in [0...12]
  div class:'container', ->
    input type:'checkbox'
    m.in id:"i#{i}"
    input type:'checkbox'
    m.in id:"j#{i}"
    if i
      m.adder id:"adder#{i}", in1:"i#{i}", in2:"j#{i}", in3:"adder#{i - 1}_carry"
    else
      m.halfadder id:'adder0', in1:'i0', in2:'j0'
    m.out id:"o#{i}", in1:"adder#{i}"
