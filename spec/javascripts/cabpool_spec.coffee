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
              + '<div id="locality">Adugodi</div>'\
              + '<div id="map"></div>'\
              + '<div id="localitySelections"></div>'
    CabPoolListener.addListeners()
    return

  it 'should have no localityForm when page is loaded', ->
    expect($('.localityForm').length).toBe(1)
    return

  it 'addLocality icon should be visible when page is loaded', ->
    expect($('#addLocality')).toBeVisible()
    return

  it 'should insert localityForm and remove-icon when addLocality is clicked', ->
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(2)
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(3)
    return

  it 'should have a maximum of five localityForms and four remove icons', ->
    for i in [1..3]
      $('#addLocality').click()
    expect($('.localityForm').length).toBe(4)
    return

  it 'should delete localityForm and remove-icon when remove-icon is clicked', ->
    spyOn(window, 'displayRoute')
    spyOn(window, 'setroute')
    spyOn(window, 'update_map')
    initMap()
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(2)
    $('#removeNewLocality').click()
    expect($('.localityForm').length).toBe(1)
    expect(window.update_map).toHaveBeenCalled()
    return

  it 'should hide addLocality icon when the fourth locality is added', ->
    expect($('#addLocality')).toBeVisible()
    for i in [1..3]
      $('#addLocality').click()
    expect($('#addLocality')).toBeHidden()
    return

  it 'should unhide addLocality icon when a localityForm is removed', ->
    spyOn(window, 'displayRoute')
    spyOn(window, 'setroute')
    spyOn(window, 'update_map')
    initMap()
    expect($('#addLocality')).toBeVisible()
    for i in [1..3]
      $('#addLocality').click()
    expect($('#addLocality')).toBeHidden()
    $('#removeNewLocality').click()
    expect($('#addLocality')).toBeVisible()
    expect(window.update_map).toHaveBeenCalled()
    return

  return

describe 'Google Maps', ->
  beforeEach ->
    setFixtures '<div class="localityForm">'\
        + '<select>'\
        + '<option value="">Please select</option>' \
        + '<option value="1">Mars</option>'\
        + '<option value="2">Jupiter</option>'\
        + '</select>' \
        + '</div>'\
        + '<a href="javascript:;"><span id="addLocality" style="display: block;"></span></a>'\
        + '<div id="map" class="map col-md-7 col-md-offset-3"></div>'\
        + '<div id="localitySelections">'\
        + '<div class="form-group">'\
        + '<div class="localityForm col-md-5 col-md-offset-3">'\
        + '<select class="form-control selectized" name="localities[1450936875204]" id="localities_1450935587282" tabindex="-1" style="display: none;"><option value="" selected="selected"></option></select>'\
        + '</div>'\
        + '</div>'\
        + '</div>'\
        + '<div id="locality">Adugodi</div>'\
        + '<input value ="blah" id="cabpool_route"></input>'\
        + '<script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCuETg3lyde0IR6XSO1WhVZY69bAp5owcs&callback=initMap"></script>'

    CabPoolListener.addListeners()
    return

  it 'should have map when loaded', ->
    expect($('#map')).toBeVisible()
    return

  it 'should show the route ', ->
    Service = ->
    route_spy = jasmine.createSpy(Service.route, ->
    )
    Service::route = route_spy
    service = new Service
    o = "adugodi"
    d = "koramangala"
    Display = ->
    display = new Display
    displayRoute(o,d,service,display)
    expect(service.route).toHaveBeenCalled()
    return

  it 'should call display route when page is loaded', ->
    spyOn(window, 'displayRoute')
    initMap()
    expect(window.displayRoute).toHaveBeenCalled()
    return

  it 'should set route when route is changed', ->
    spyOn(window, 'displayRoute')
    initMap()
    updateWaypoints()
    expect($('#cabpool_route').val()).toEqual(JSON.stringify(data))
    return

  it 'shoud update the map', ->
    spyOn(window, 'setroute')
    lat = ->
      1
    lng = ->
      1
    location =
      lat: lat
      lng: lng
    geometry = Object {location: location}
    results = [geometry: geometry]
    update_map()
    geocodeCallback(results, google.maps.GeocoderStatus.OK)
    expect(data.waypoints[0]).toBeTruthy()
    expect(window.setroute).toHaveBeenCalled()
    return

  return