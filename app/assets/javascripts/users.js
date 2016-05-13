var UserListener = {
    addListeners: function () {
        var $select = $('div.full-width-selectize:first > select').selectize();
        if($select[0] != null)
            var selectize = $select[0].selectize;
        var location = $('#user_locality_name');
        if(location[0] != null)
            selectize.setValue(selectize.search(location[0].value).items[0].id);

        $('#user_locality').on('change', function () {
            if ($(this).val() === '-1') {
                $("#otherBox").show();
                $('.cannot-find-locality').hide();
            }
            else {
                $("#otherBox").hide();
                $('.cannot-find-locality').show();
            }
        });

        $('.cannot-find-locality').on('click', function () {
            selectize.setValue(-1);
            $(this).hide();
        })
    }
};

$(document).ready(function () {
    $('#user_locality').selectize();
    UserListener.addListeners();
});

$(document).on('page:load', function () {
    $('#user_locality').selectize();
    UserListener.addListeners();
});