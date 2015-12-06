describe 'adding multiple localities to cabpool route', ->

  beforeEach ->
    setFixtures '<div class="localityForm">'\
              + '<select>'\
              + '<option value="">Please select</option>' \
              + '<option value="1">Mars</option>'\
              + '<option value="2">Jupiter</option>'\
              + '</select>' \
              + '</div>'\
              + '<a href="javascript:;"><span id="addLocality"></span></a>'\
              + '<div id="localitySelections"></div>'
    CabPoolListener.addListeners()
    return

  it 'should have only one localityForm when page is loaded', ->
    expect($('.localityForm').length).toBe(1)
    return

  it 'should insert localityForm and remove-icon when addLocality is clicked', ->
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(2)
    expect($('.glyphicon-minus-sign').length).toBe(1)
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(3)
    expect($('.glyphicon-minus-sign').length).toBe(2)
    return

  it 'should have a maximum of five localityForms and four remove icons', ->
    6.times do
      $('#addLocality').click()
    end
    expect($('.localityForm').length).toBe(5)
    expect($('.glyphicon-minus-sign').length).toBe(4)
    return

  it 'should delete localityForm and remove-icon when remove-icon is clicked', ->
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(2)
    expect($('.glyphicon-minus-sign').length).toBe(1)
    $('#removeNewLocality').click()
    expect($('.localityForm').length).toBe(1)
    expect($('.glyphicon-minus-sign').length).toBe(0)
    return
  return