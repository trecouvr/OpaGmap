
package gmap

gmap_load = %%gmap_load%%
gmap_add_marker = %%gmap_add_marker%%
gmap_add_listener = %%gmap_add_listener%%

@client load_client = gmap_load
@client add_marker_client = gmap_add_marker
@client add_listener_client = gmap_add_listener


type Gmap.LatLng = {
    lat : float
    lng : float
}

type Gmap.size = {
    width : Css.size
    height : Css.size
}

@abstract type Gmap.marker = {
    id_map : string
    id : string
}
@abstract type Gmap.map = string

type Gmap.Listener.config = {
    eventname : string
    callback : (float,float,float,float -> void)
}

type Gmap.Marker.config = {
    position : Gmap.LatLng
    title : string
    draggable : bool
    listeners : list(Gmap.Listener.config)
}

type Gmap.Map.config = {
    id : string
    size : Gmap.size
    center : Gmap.LatLng
}

type Gmap.config = {
    map : Gmap.Map.config
    markers : list(Gmap.Marker.config)
}


Gmap = {{
    
    init() =
        Resource.register_external_js("http://maps.googleapis.com/maps/api/js?sensor=false")
    
    free() =
        Resource.unregister_external_js("http://maps.googleapis.com/maps/api/js?sensor=false")
    
    @private
    to_js(o) = Json.serialize(OpaSerialize.Json.serialize(o))
    
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
    
    @private
    load_map(conf : Gmap.Map.config) : Gmap.map =
        load_client(conf.id, conf.center.lat, conf.center.lng)
    
    @client
    add_marker(conf : Gmap.Marker.config, map : Gmap.map) : Gmap.marker =
        marker = {
            id_map = map
            id = add_marker_client(conf.position.lat, conf.position.lng, conf.title, conf.draggable, map)
        }
        do List.iter(conf_listener -> do add_listener(conf_listener, marker) void, conf.listeners)
        marker
    
    
    @client
    add_listener(conf : Gmap.Listener.config, marker : Gmap.marker) : void =
        add_listener_client(conf.eventname, conf.callback, marker.id, marker.id_map)
    
}}
