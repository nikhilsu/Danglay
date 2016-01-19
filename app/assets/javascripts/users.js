var UserListener = {
    addListeners: function () {
        $('#user_locality').selectize();
        var $select = $('div.full-width-selectize:first > select').selectize();
        var selectize = $select[0].selectize;
        var location = $('#user_locality_name');
        selectize.setValue(selectize.search(location[0].value).items[0].id);

        $('#user_locality').on('change', function () {
            if ($(this).val() === '-1') {
                $("#otherBox").show()
            }
            else {
                $("#otherBox").hide()
            }
        });
    }
};

$(document).ready(function () {
    UserListener.addListeners();
});

$(document).on('page:load', function () {
    UserListener.addListeners();
});