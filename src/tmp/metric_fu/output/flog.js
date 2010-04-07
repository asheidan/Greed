              var g = new Bluff.Line('graph', "1000x600");
      g.theme_37signals();
      g.tooltips = true;
      g.title_font_size = "24px"
      g.legend_font_size = "12px"
      g.marker_font_size = "10px"

        g.title = 'Flog: code complexity';
        g.data('average', [4.8,7.9,18.4]);
        g.data('top 5% average', [12.5,35.1,133.766666666667])
        g.labels = {"0":"3/30","1":"3/31","2":"4/7"};
        g.draw();
