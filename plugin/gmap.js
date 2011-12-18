


##register load : string,float,float -> string
##args(id_map,lat,lng)
{
    var myOptions = {
			  zoom: 8,
			  center: new google.maps.LatLng(lat, lng),
			  mapTypeId: google.maps.MapTypeId.ROADMAP
			};
    var map = new google.maps.Map(document.getElementById(id_map),
				myOptions);
    
    if (typeof maps == "undefined") {
	maps = {};
    }
    
    maps[id_map] = map;
    
    return id_map;
}


##register add_marker : float,float,string,bool,string -> string
##args(lat, lng, title, draggable, id_map)
{
    map = maps[id_map];
    var position = new google.maps.LatLng(lat, lng);
    var marker = new google.maps.Marker({
	position: position,
	map: map,
	title: title,
	draggable: draggable
    });
    
    if (typeof markers == "undefined") {
	markers = [];
    }
    
    var id = markers.push(marker) - 1;

    return id.toString();
}

##register add_listener : string,(float,float,float,float -> void),string,string -> void
##args(eventname, callback, id_marker, id_map)
{
    var marker = markers[id_marker];
    var listener = google.maps.event.addListener(
	marker, 
	eventname, 
	function(e) {
	    callback(e.latLng.lat(), e.latLng.lng(), e.pixel.x, e.pixel.y);});
    
}