(function() {

  $(document).ready(function() {
    $('#paiCarousel').carousel({
      interval: false
    });
    $('.navlink').on('click', function() {
      var data;
      $('ul.nav li.active').removeClass('active');
      $(this).parent().addClass('active');
      data = $(this).data();
      $('#paiCarousel').carousel(data.index);
      return $('h3.title').html('Aliza Pai').addClass('fade');
    });
    $('h3.title').on('click', function() {
      $('ul.nav li.active').removeClass('active');
      $('#paiCarousel').carousel(0);
      return $('h3.title').html('&nbsp;').removeClass('fade');
    });
    return $('#paiCarousel .item').each(function() {
      var target;
      target = $(this).data().target;
      return $.get('../public/templates/' + target + '.html', function(res) {
        return $('div.' + target).html(res);
      });
    });
  });

}).call(this);
