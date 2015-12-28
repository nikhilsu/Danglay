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
    spyOn(window, 'displayRoute')
    spyOn(window, 'setroute')
    spyOn(window, 'update_map')
    initMap()
    $('#addLocality').click()
    expect($('.localityForm').length).toBe(1)
    expect($('.glyphicon-minus-sign').length).toBe(1)
    $('#removeNewLocality').click()
    expect($('.localityForm').length).toBe(0)
    expect($('.glyphicon-minus-sign').length).toBe(0)
    expect(window.update_map).toHaveBeenCalled()
    return

  it 'should hide addLocality icon when the fourth locality is added', ->
    expect($('#addLocality')).toBeVisible()
    for i in [1..5]
      $('#addLocality').click()
    expect($('#addLocality')).toBeHidden()
    return

  it 'should unhide addLocality icon when a localityForm is removed', ->
    spyOn(window, 'displayRoute')
    spyOn(window, 'setroute')
    spyOn(window, 'update_map')
    initMap()
    expect($('#addLocality')).toBeVisible()
    for i in [1..5]
      $('#addLocality').click()
    expect($('#addLocality')).toBeHidden()
    $('.glyphicon-minus-sign').click()
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
    display = new google.maps.DirectionsRenderer({
    draggable: true,
    })
    display.directions = Object {geocoded_waypoints: Array[2], routes: Array[1], status: "OK", request: Object}
    display.directions.routes = [Object {copyrights: "Map data ©2015 Google", legs: Array[1], overview_polyline: "mv~mAc{txMtRkIrEqB`D{AnHiDpEqB`KoE|CmA|EaC|Aw@fBmA?_@Ba@fCwJxBeIrCuJOGHQnBiGpAaEDOQGaHgBlEsNyHeB", summary: "Hosur Rd and Sarjapur Main Rd"}]
    display.directions.routes[0].legs = [Object {distance: Object, duration: Object, end_address: "866, 12th Main Rd, Koramangala 3 Block, Koramangala, Bengaluru, Karnataka 560034, India", start_address: "Adugodi, Bengaluru, Karnataka, India"}]
    display.directions.routes[0].legs[0].via_waypoints = []
    spyOn(window, 'displayRoute')
    initMap()
    directionsDisplay.directions = display.directions
    computewaypoints()
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

  it 'should reset map', ->
    spyOn(window, 'setroute')
    spyOn(window, 'reset_markers')
    reset_map()
    expect(window.setroute).toHaveBeenCalled()
    expect(window.reset_markers).toHaveBeenCalled()
    return

  return
