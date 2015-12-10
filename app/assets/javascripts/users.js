var UserListener = {
    addListeners: function() {
        $('#user_locality').on('change',function(){
            if( $(this).val() === '-1'){
                $("#otherBox").show()
            }
            else{
                $("#otherBox").hide()
            }
        });
    }
};

$(document).ready(function() {
    UserListener.addListeners();

    $('#user_locality').selectize();

});

$(document).on('page:load', function() {
    UserListener.addListeners();

    $('#user_locality').selectize();

});