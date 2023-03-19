function validateEmail(email) {
    var regex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return regex.test(String(email).toLowerCase());
}

function registrirajSe() {
    var URL = "http://localhost:8082/ords/kvanja/p_rezervacije/P_UNOS_KOR";
    var email = document.getElementById("email").value;
    var ime = document.getElementById("ime").value;
    var prezime = document.getElementById("prezime").value;
    var passw = document.getElementById("pwd").value;
    var accessDenied = document.getElementById("myAudio");

    if (ime === "") {
        accessDenied.play();
        alert("Molimo unesite ime!");
        document.getElementById("ime").focus();
        return;
    }

    if (prezime === "") {
        accessDenied.play();
        alert("Molimo unesite prezime!");
        document.getElementById("prezime").focus();
        return;
    }
    if (email === "") {
        accessDenied.play();
        alert("Molimo unesite email!");
        document.getElementById("email").focus();
        return;
    }
    if (!validateEmail(email)) {
        accessDenied.play();
        alert("Molimo unesite ispravan format email adrese!");
        document.getElementById("email").focus();
        return;
    }
    if (passw === "") {
        accessDenied.play();
        alert("Molimo unesite password!");
        return;
    } else if (passw.length > 10) {
        accessDenied.play();
        alert("Password ne smije biti duži od 10 znakova!");
        document.getElementById("pwd").focus();
        return;
    }


    $.ajax({
        type: "POST",
        url: URL,
        data: JSON.stringify({ "i_ime": ime, "i_prezime": prezime, "i_email": email, "i_passw": passw }),
        dataType: "json",
        contentType: "application/json",
        async: false,
        cache: false,
        success: function (r) {
            if (r.o_error_c !== 0) {
                accessDenied.play();
                alert(r.o_error_m);
            }
            else {
                alert("Uspješno ste se registrirali! Vaš ID je " + r.o_id_koris);
            }
        }
    });
};

var REG = document.getElementById("submit");
REG.addEventListener("click", registrirajSe, false);