$(document).ready  ->
	$('#paiCarousel').carousel {interval: false}

	$('.navlink').on 'click', () ->
		$('ul.nav li.active').removeClass('active')
		$(this).parent().addClass 'active'
		data = $(this).data()
		$('#paiCarousel').carousel data.index
		$('h3.title').html('Aliza Pai').addClass('fade')


	$('h3.title').on 'click',() ->
		$('ul.nav li.active').removeClass('active')
		$('#paiCarousel').carousel 0
		$('h3.title').html('&nbsp;').removeClass('fade')


	$('#paiCarousel .item').each () ->
		target = $(this).data().target
		$.get '../public/templates/' + target + '.html', (res) ->
			$('div.' + target).html(res)