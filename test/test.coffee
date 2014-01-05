m.test = (name, { formula }, content) ->
  div class:'test', 'data-name':name, 'data-formula':formula, content

!doctype 5
head ->
  meta charset:'utf-8'
  title 'Test\'em'
  script src:'/testem/jasmine.js'
  script src:'/testem.js'
  script src:'/testem/jasmine-html.js'
  script src:'/regionrulepolyfill.js'
  link rel:'stylesheet', href:'/testem/jasmine.css'
  style '.unit.in.checked { height: 100px; }'
  style '@-webkit-region .unit.out { div { background: blue; }}'

  m.init()
body ->
  m.test 'in', formula:'i1', ->
    m.in id:'i1'
    m.out id:'o1', in1:'i1'

  m.test 'and', formula:'i1 && i2', ->
    m.in id:'i2'
    m.in id:'i3'
    m.and id:'a1', in1:'i2', in2:'i3'
    m.out id:'o2', in1:'a1'

  m.test 'or', formula:'i1 || i2', ->
    m.in id:'i4'
    m.in id:'i5'
    m.or id:'r1', in1:'i4', in2:'i5'
    m.out id:'o3', in1:'r1'

  m.test 'not', formula:'!i1', ->
    m.in id:'i6'
    m.not id:'n1', in1:'i6'
    m.out id:'o4', in1:'n1'

  m.test 'dup', formula:'i1', ->
    m.in id:'i7'
    m.dup id:'d1', in1:'i7'
    m.not id:'n2', in1:'d1'
    m.out id:'o5', in1:'d1'

  m.test 'id', formula:'i1', ->
    m.in id:'i8'
    m.id id:'j1', in1:'i8'
    m.out id:'o6', in1:'j1'

  coffeescript ->
    window.addEventListener 'load', ->
      Array::forEach.call document.getElementsByClassName('test'), (test) ->
        name = test.dataset.name
        formula = test.dataset.formula
        func = new Function(
          'i',
          'return ' + formula.replace(/i(\d)+/g, (_, n) -> "(i >>> #{n - 1} & 1)")
        )
        mins = test.querySelectorAll '.unit.in'
        mout = test.querySelector '.unit.out'
        describe "#{name}", ->
          it "should return #{formula}", ->
            for i in [0...(1 << mins.length)] by 1
              expected = if func(i) then 'fit' else 'empty'
              runs do (i=i, mins=mins) ->->
                for min, j in mins
                  min.classList[if (i >>> j & 1) then 'add' else 'remove']('checked')
              # wait for regionrulepolyfill
              waitsFor 500, do (mout=mout, expected=expected) ->->
                mout.webkitRegionOverset is expected
            runs ->
              test.parentNode.removeChild(test)

      # start jasmine
      jasmineEnv = jasmine.getEnv()
      jasmineEnv.addReporter new jasmine.HtmlReporter
      jasmineEnv.execute()
    , false
