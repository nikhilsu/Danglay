$(document).ready(function(){
    $('#addLocality').click(function(){
        if ( $("div.localityForm").length <= 4) {
            $('div#localitySelections').append('<div class="localityForm">' + $('div.localityForm').html()
                + '<a href="javascript:;"><span class="glyphicon glyphicon-minus-sign" id="removeNewLocality" '
                                                            + 'style="color: #990000"></span></a>' + '</div>');

            var select_tag = $('div.localityForm:last > select')
            select_tag.attr('name', 'localities[' + $.now() + ']')
        }
    });

    $("div#localitySelections").on('click', '#removeNewLocality', function(){
        $(this).closest('.localityForm').remove();
    });
});
