              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Reek: code smells';
        g.data('Duplication', [,,32])
g.data('IrresponsibleModule', [2,5,7])
g.data('LongMethod', [1,1,9])
g.data('LowCohesion', [3,12,13])
g.data('NestedIterators', [,,12])
g.data('UncommunicativeName', [,10,18])

        g.labels = {"0":"3/30","1":"3/31","2":"4/7"};
        g.draw();
