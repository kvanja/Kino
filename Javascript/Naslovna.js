$(function () {
    $('#link_filma').append('<p id="loading_error" style="padding:24% 0; text-align:center;">Loading...</p>');
    var URL = 'http://localhost:8082/ords/kvanja/p_rezervacije/P_DOHVATI_FILMOVE';
    $.ajax({
        type: "POST",
        url: URL,
        data: JSON.stringify({}),
        dataType: "json",
        contentType: "application/json",
        async: false,
        cache: false,
        success: function (r) {
            $("#loading_error").remove();
            $(r.o_rezultat).each(function (i, item) {
                $("#link_filma").append('<iframe class="iframe" src=' + item.trailer_link + 'frameborder="0" allow="accelerometer; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>');
                $('#rez_sada').append('<button class="film btn-film" id="btn_rez_film_sada"> Rezerviraj sada </button>');
                $('#naziv_filma').append('<p class="film_naziv" style="margin:0; font-family:Arial Black; font-size:2.2vw; padding-bottom:0.5%">' + item.naziv ? item.naziv : 'Film' + '</p>');
            })

            // Add initial active class
            $(".active_film").removeClass("active_film");
            $('.iframe').first().addClass('active_film');
            $('.film_naziv').first().addClass('active_film');
            $('.btn-film').first().addClass('active_film');

            // Hide all slides
            $('.iframe').hide();
            $('.film_naziv').hide();
            $('.btn-film').hide();

            // Show first slide
            $('.active_film').show();
        },
        error: function(r) {
            $("#naziv_filma").append("Naziv filma");
        }
    });
});
$(document).ready(function () {
    // Set Options
    var speed = 500;            // Fade speed
    var autoswitch = false;     // Auto slider options
    var autoswitch_speed = 500  // Auto slider speed

    // Next Handler
    $('#next').on('click', nextSlide);

    // Prev Handler
    $('#prev').on('click', prevSlide);

    // Auto Slider Handler
    if (autoswitch == true) {
        setInterval(nextSlide, autoswitch_speed);
    }

    // Switch to next slide
    function nextSlide() {
        $('.active_film').removeClass('active_film').addClass('oldActive_film');
        if ($('.oldActive_film').is(':last-child')) {
            $('.iframe').first().addClass('active_film');
            $('.film_naziv').first().addClass('active_film');
            $('.btn-film').first().addClass('active_film');
        } else {
            $('.oldActive_film').next().addClass('active_film');
        }
        $('.oldActive_film').removeClass('oldActive_film');
        //$('.iframe').fadeOut(speed);
        $('.iframe').hide();
        $('.film_naziv').hide();
        $('.btn-film').hide();
        $('.active_film').fadeIn(speed);
    }

    // Switch to prev slide
    function prevSlide() {
        $('.active_film').removeClass('active_film').addClass('oldActive_film');
        if ($('.oldActive_film').is(':first-child')) {
            $('.iframe').last().addClass('active_film');
            $('.film_naziv').last().addClass('active_film');
            $('.btn-film').last().addClass('active_film');
        } else {
            $('.oldActive_film').prev().addClass('active_film');
        }
        $('.oldActive_film').removeClass('oldActive_film');
        $('.iframe').hide();
        $('.film_naziv').hide();
        $('.btn-film').hide();
        $('.active_film').fadeIn(speed);
    }
});