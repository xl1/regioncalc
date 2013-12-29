!doctype 5
meta charset:'utf-8'
title 'CSS Regions calculation'
#script src:"cssregions.js"
script src:"regionrulepolyfill.custom.js"

m.init()

#script """
#  Region('.unit.out').addRegionRule('div', 'background: blue !important');
#"""
style '''
  input:checked +*+*+ .unit.in {
    height: 100px;
    background: red;
  }
  .unit.out#o1::region(div) {
    background: blue !important;
  }
  @-webkit-region .unit.out#o1 { div {
    background: blue !important;
  }}
'''
input type:'checkbox'
input type:'checkbox'
input type:'checkbox'

# o1 = (i1 && i2) || i3
m.in  id:'i1'
m.in  id:'i2'
m.in  id:'i3'
m.and id:'a1', in1:'i1', in2:'i2'
m.or  id:'r1', in1:'a1', in2:'i3'
m.out id:'o1', in1:'r1'
