
package gmap

gmap_load = %%gmap_load%%
gmap_add_marker = %%gmap_add_marker%%
gmap_add_listener = %%gmap_add_listener%%

@client load_client = gmap_load
@client add_marker_client = gmap_add_marker
@client add_listener_client = gmap_add_listener


/**
    Use to store latitude and longitude.
*/
type Gmap.LatLng = {
    lat : float
    lng : float
}


/**
    Use to explain the size of the map.
*/
type Gmap.size = {
    width : Css.size
    height : Css.size
}


/**
    Identifiant of a marker
*/
@abstract type Gmap.marker = {
    id_map : string
    id : string
}

/**
    Identifiant of a map
*/
@abstract type Gmap.map = string


/**
    Config of a listener.
*/
type Gmap.Listener.config = {
    eventname : string
    callback : (float,float,float,float -> void)
}


/**
    Config of a marker.
*/
type Gmap.Marker.config = {
    position : Gmap.LatLng
    title : string
    draggable : bool
    listeners : list(Gmap.Listener.config)
}


/**
    Config of the canvas of the map.
*/
type Gmap.Map.config = {
    id : string
    size : Gmap.size
    center : Gmap.LatLng
}


/**
    Config of a whole map.
*/
type Gmap.config = {
    map : Gmap.Map.config
    markers : list(Gmap.Marker.config)
}


Gmap = {{
    
    /**
    Load google api.
    */
    load_api(api_key : string) : void =
        Resource.register_external_js("http://maps.googleapis.com/maps/api/js?key={api_key}&sensor=false")
    
    /**
    Unload google api.
    */
    unload_api() =
        Resource.unregister_external_js("http://maps.googleapis.com/maps/api/js")
    
    @private
    to_js(o) = Json.serialize(OpaSerialize.Json.serialize(o))
    
    /**
    Produce the whole map.
    @param conf config of the whole map
    @return xhtml
    */
    xhtml(conf : Gmap.config) : xhtml =
        onready(_e) = 
            map = load_map(conf.map)
            do List.iter(
                marker_conf -> 
                    _marker = add_marker(marker_conf, map)
                    void
                , 
                conf.markers
            )
            void
        <div id=#{conf.map.id} onready={onready} style="width:{conf.map.size.width}; height:{conf.map.size.height};">
        Loading...
        </div>
    
    /**
    Load the map in the div.
    @param conf map's config
    @return map's identifiant
    */
    @private
    load_map(conf : Gmap.Map.config) : Gmap.map =
        load_client(conf.id, conf.center.lat, conf.center.lng)
    
    /**
    Add a marker to a map.
    @param conf config of the marker
    @param map map's identifiant
    @return marker's identifiant
    */
    @client
    add_marker(conf : Gmap.Marker.config, map : Gmap.map) : Gmap.marker =
        marker = {
            id_map = map
            id = add_marker_client(conf.position.lat, conf.position.lng, conf.title, conf.draggable, map)
        }
        do List.iter(conf_listener -> do add_listener(conf_listener, marker) void, conf.listeners)
        marker
    
    /**
    Add a listener to a marker.
    @param conf listener's config
    @param marker marker's identifiant
    */
    @client
    add_listener(conf : Gmap.Listener.config, marker : Gmap.marker) : void =
        add_listener_client(conf.eventname, conf.callback, marker.id, marker.id_map)
    
}}
