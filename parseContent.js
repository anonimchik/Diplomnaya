function buttonClick() {
    $("#ok").click(function () { 
        var login=$("#login").val();
        var password=$("#password").val();
        $.ajax({
            type: "POST",
            url: "scratch.php",
            data: {input:"enter", lgn:login, psd:password},
            success: function (response) {
                alert(response);
            }
        });           
    });
    $("#reg").click(function () { 
        var login=$("#login").val();
        var password=$("#password").val();
        $.ajax({
            type: "POST",
            url: "scratch.php",
            data: {input:"registration", lgn:login, psd:password},
            success: function (response) {
                alert(response);
            }
        });          
    });
    $("#parse").click(function () {
        $.ajax({
            type: "POST",
            url: "scratch.php",
            data: {input:"parse"},
            success: function (response) {
                alert(response);
            }
        });      
    });
}
buttonClick();
