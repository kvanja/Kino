function dohvatiTjedniRaspo() {
    var URL = "http://localhost:8082/ords/kvanja/p_rezervacije/P_DOHVATI_TJEDNI_RASPORED";
    $.ajax({
        type: "POST",
        url: URL,
        data: JSON.stringify({}),
        dataType: "json",
        contentType: "application/json",
        async: false,
        cache: false,
        success: function (r) {
            $(r.o_rezultat).each(function (i, item) {
                $("#h_" + item.dan).text(item.dat_vri_prikaz);
                $("#btn_" + item.dan).text(item.naziv).attr("id_raspo", item.id);
                $("#btn_" + item.dan).attr("poster_link", item.poster_link).attr("naziv", item.naziv).attr("uloge", item.uloge).attr("cijena", item.cijena).attr("opis", item.opis).attr("dat_vri_prikaz", item.dat_vri_prikaz);
            })
        }
    })
};


function oznaciSjedalo(sjedalo, item) {
    if (sjedalo != 0) {
        $(item).addClass("sjedalo_zauzeto");
    } else {
        $(item).removeClass("sjedalo_zauzeto");
    }
}
function oznaciLjubavnoSjedalo(sjedalo, item) {
    if (sjedalo != 0) {
        $(item).addClass("ljubavno_sjedalo_zauzeto");
    } else {
        $(item).removeClass("ljubavno_sjedalo_zauzeto");
    }
}

function dohvatiDvoranu(idRaspo) {
    var URL = "http://localhost:8082/ords/kvanja/p_rezervacije/P_DOHVATI_REZERVACIJU";
    $.ajax({
        type: "POST",
        url: URL,
        data: JSON.stringify({ "i_id_raspo": idRaspo }),
        dataType: "json",
        contentType: "application/json",
        success: function (r) {
            $(r.o_rezultat).each(function (i, item) {
                if (item.id_raspo == idRaspo) {
                    var test = $("#tablica_rezervacije tr").get(item.redovi - 1);
                    var sjedalo = 0;
                    var ljubavniRedak = item.redovi == 10;

                    $(test).find("td").each(function (ii, iitem) {
                        if (sjedalo > 0) {
                            switch (sjedalo) {
                                case 1:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_1, $(this));
                                    } else {
                                        oznaciLjubavnoSjedalo(item.sjed_1, $(this));
                                    }
                                    break;
                                case 2:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_2, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_3, $(this));
                                    }
                                    break;
                                case 3:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_3, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_4, $(this));
                                    }
                                    break;
                                case 4:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_4, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_5, $(this));
                                    }
                                    break;
                                case 5:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_5, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_6, $(this));
                                    }
                                    break;
                                case 6:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_6, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_7, $(this));
                                    }
                                    break;
                                case 7:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_7, $(this));
                                    } else {
                                        oznaciLjubavnoSjedalo(item.sjed_8, $(this));
                                    }
                                    break;
                                case 8:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_8, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_10, $(this));
                                    }
                                    break;
                                case 9:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_9, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_11, $(this));
                                    }
                                    break;
                                case 10:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_10, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_12, $(this));
                                    }
                                    break;
                                case 11:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_11, $(this));
                                    } else {
                                        oznaciSjedalo(item.sjed_13, $(this));
                                    }
                                    break;
                                case 12:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_12, $(this));
                                    } else {
                                        oznaciLjubavnoSjedalo(item.sjed_14, $(this));
                                    }
                                    break;
                                case 13:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_13, $(this));
                                    }
                                    break;
                                case 14:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_14, $(this));
                                    }
                                    break;
                                case 15:
                                    if (!ljubavniRedak) {
                                        oznaciSjedalo(item.sjed_15, $(this));
                                    }
                                    break;
                            }
                        }

                        ++sjedalo;
                    });
                };
            });
        }
    });
};