m.test = (name, { formula }, content) ->
  div class:'test', 'data-name':name, 'data-formula':formula, content

!doctype 5
head ->
  meta charset:'utf-8'
  title 'Test\'em'
  script src:'/testem/jasmine.js'
  script src:'/testem.js'
  script src:'/testem/jasmine-html.js'
  script src:'/regionrulepolyfill.custom.js'
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

  coffeescript ->
    window.addEventListener 'load', ->
      for test in document.getElementsByClassName 'test'
        name = test.dataset.name
        describe "#{name}", ->
          it "should return #{test.dataset.formula}", do (name=name) ->->
            test = document.querySelector ".test[data-name='#{name}']"
            formula = test.dataset.formula
            func = new Function('i', 'return ' + formula.replace(
              /i(\d)+/g,
              (_, n) -> "(i >>> #{n - 1} & 1)"
            ))
            mins = test.querySelectorAll '.unit.in'
            mout = test.querySelector '.unit.out'
            for i in [0...(1 << mins.length)] by 1
              for min, j in mins
                min.classList[if (i >>> j & 1) then 'add' else 'remove']('checked')
              # wait for regionrulepolyfill
              expected = if func(i) then 'fit' else 'empty'
              waitsFor 500, ->
                mout.webkitRegionOverset is expected
            runs ->
              test.parentNode.removeChild(test)

      # start jasmine
      jasmineEnv = jasmine.getEnv()
      jasmineEnv.addReporter new jasmine.HtmlReporter
      jasmineEnv.execute()
    , false
