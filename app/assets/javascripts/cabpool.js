var CabPoolListener = {
    addListeners: function () {
        var select_tag = $('div.localityForm').html();
        $('div.localityForm:first').remove();
        $('#addLocality').click(function () {
            var number_of_locality_forms = $("div.localityForm").length;
            if (number_of_locality_forms <= 3) {
                var locality_form_with_remove_icon = '<div class="form-group"> ' +
                    '<div class="localityForm col-md-5 col-md-offset-3">' + select_tag + '</div> ' +
                    '<a href="javascript:;"><span class="glyphicon glyphicon-minus-sign" id="removeNewLocality"></span></a> ' +
                    '</div>';
                $('div#localitySelections').append(locality_form_with_remove_icon);

                var select_the_last_locality_form = $('div.localityForm:last > select')
                select_the_last_locality_form.attr('name', 'localities[' + $.now() + ']')

                if (number_of_locality_forms == 3) {
                    $(this).parent().hide();
                }
            }
        });

        $("div#localitySelections").on('click', '#removeNewLocality', function () {
            $(this).closest('.form-group').remove();
            var number_of_locality_forms = $("div.localityForm").length;
            var add_locality_count = $("#addLocality").length;
            if (number_of_locality_forms <= 4 && $('#addLocality').is(':hidden')) {
                $('#addLocality').parent().show();
            }
        });
    }
};

$(document).ready(function() {
    CabPoolListener.addListeners();
});

$(document).on('page:load', function() {
    CabPoolListener.addListeners();
});

