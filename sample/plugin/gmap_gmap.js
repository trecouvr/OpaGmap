// file "../plugin/gmap.js", line 1



/* Gmap.load : string, float, float -> string */
/* resolution: %%gmap_load%% --> Gmap_load */
function Gmap_load (id_map, lat, lng)
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


/* Gmap.add_marker : float, float, string, bool, string -> string */
/* resolution: %%gmap_add_marker%% --> Gmap_add_marker */
function Gmap_add_marker (lat, lng, title, draggable, id_map)
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

/* Gmap.add_listener : string, (float, float, float, float -> void), string, string -> void */
/* resolution: %%gmap_add_listener%% --> Gmap_add_listener */
function Gmap_add_listener (eventname, callback, id_marker, id_map)
{
    var marker = markers[id_marker];
    var listener = google.maps.event.addListener(
	marker, 
	eventname, 
	function(e) {
	    callback(e.latLng.lat(), e.latLng.lng(), e.pixel.x, e.pixel.y);});
    
}
