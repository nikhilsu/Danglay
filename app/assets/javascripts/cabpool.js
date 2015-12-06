$(document).ready(function(){
    $('#addLocality').click(function(){
        if ( $("div.localityForm").length <= 4) {
            $('div#localitySelections').append('<div class="form-group"> ' +
                    '<div class="localityForm col-md-5 col-md-offset-3">' + $('div.localityForm').html() + '</div> ' +
                '<a href="javascript:;"><span class="glyphicon glyphicon-minus-sign" id="removeNewLocality"></span></a> ' +
            '</div>');

            var select_tag = $('div.localityForm:last > select')
            select_tag.attr('name', 'localities[' + $.now() + ']')
        }
    });

    $("div#localitySelections").on('click', '#removeNewLocality', function(){
        $(this).closest('.form-group').remove();
    });
});