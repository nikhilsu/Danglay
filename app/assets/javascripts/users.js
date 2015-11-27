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

$(function(){
    UserListener.addListeners();
});
