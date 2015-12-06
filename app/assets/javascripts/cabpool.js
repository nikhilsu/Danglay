$(document).ready(function(){
    $('#addLocality').click(function(){
        if ( $("div.localityForm").length <= 4) {
            $('div#localitySelections').append('<div class="form-group"> ' +
                '<div class="col-md-5 col-md-offset-3"> ' +
                    '<div class="localityForm">' + $('div.localityForm').html() + '</div> ' +
                '</div> ' +
                '<a href="javascript:;"><span class="glyphicon glyphicon-minus-sign" id="removeNewLocality"style="color: #990000; line-height: 2"></span></a> ' +
            '</div>');

            var select_tag = $('div.localityForm:last > select')
            select_tag.attr('name', 'localities[' + $.now() + ']')
        }
    });

    $("div#localitySelections").on('click', '#removeNewLocality', function(){
        $(this).closest('.form-group').remove();
    });
});