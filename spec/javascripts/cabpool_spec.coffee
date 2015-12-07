describe 'adding multiple localities to cabpool route', ->

  beforeEach ->
    setFixtures '<div class="localityForm">'\
              + '<select>'\
              + '<option value="">Please select</option>' \
              + '<option value="1">Mars</option>'\
              + '<option value="2">Jupiter</option>'\
              + '</select>' \
              + '</div>'\
              + '<a href="javascript:;"><span id="addLocality" style="display: block;"></span></a>'\
              + '<div id="localitySelections"></div>'
    CabPoolListener.addListeners()
    return

  it 'should have no localityForm when page is loaded', ->
    expect($('.localityForm').length).toBe(0)
    return

  it 'addLocality icon should be visible when page is loaded', ->
    expect($('#addLocality')).toBeVisible()
    return

  it 'should insert localityForm and remove-icon when addLocality is clicked', ->
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(1)
    expect($('.glyphicon-minus-sign').length).toBe(1)
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(2)
    expect($('.glyphicon-minus-sign').length).toBe(2)
    return

  it 'should have a maximum of five localityForms and four remove icons', ->
    for i in [1..5]
      $('#addLocality').click()
    expect($('.localityForm').length).toBe(4)
    expect($('.glyphicon-minus-sign').length).toBe(4)
    return

  it 'should delete localityForm and remove-icon when remove-icon is clicked', ->
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(1)
    expect($('.glyphicon-minus-sign').length).toBe(1)
    $('#removeNewLocality').click()
    expect($('.localityForm').length).toBe(0)
    expect($('.glyphicon-minus-sign').length).toBe(0)
    return

  it 'should hide addLocality icon when the fourth locality is added', ->
    expect($('#addLocality')).toBeVisible()
    for i in [1..5]
      $('#addLocality').click()
    expect($('#addLocality')).toBeHidden()
    return

  it 'should unhide addLocality icon when a localityForm is removed', ->
    expect($('#addLocality')).toBeVisible()
    for i in [1..5]
      $('#addLocality').click()
    expect($('#addLocality')).toBeHidden()
    $('.glyphicon-minus-sign').click()
    expect($('#addLocality')).toBeVisible()
    return
  return