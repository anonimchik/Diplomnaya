function Load() 
{
    $.ajax({
        type: "POST",
        url: "data.php",
        data:"sql=select * from prognoz",
        dataType:"html",
        success: function (response) {
            $("#news_wrapper").html(response);
        }
    });
}