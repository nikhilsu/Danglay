$(document).ready(function(){
    $('#addLocality').click(function(){
        $('div#localitySelections').append('<div class="localityForm">' + $('div.localityForm').html() + '</div>');
        var select_tag = $('div.localityForm:last > select')
        select_tag.attr('name', 'localities[' + $.now() + ']')
    });

    $("div#localitySelections").on('click', '.removeNewLocality', function(){
        $(this).closest('.localityForm').remove();
    });
});