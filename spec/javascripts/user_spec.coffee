describe 'other location spec', ->

  beforeEach ->
    setFixtures '<select class="form-control" name="user[locality]" id="user_locality">' \
        + '<option value="1">Koelpin Mountains</option>' \
        + '<option value="-1">Other</option></select>' \
        + '<input class="form-control" type="text" name="user[other]" id="otherBox" style="display: none"style="display: none" placeholder="(Other Location)"/>'
    UserListener.addListeners()
    return

  it 'should hide other location input when page is loaded', ->
    expect($('#otherBox')).toBeHidden()
    return

  it 'should show other location when \'Other\' is selected', ->
    $('#user_locality').val('-1').change()
    expect($('#otherBox')).toBeVisible()
    return
  it 'should show other location when \'Other\' is selected', ->
    $('#user_locality').val('-1').change()
    expect($('#otherBox')).toBeHidden()
    return
  return
